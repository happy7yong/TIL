# WebSocket Race Condition

## 1. 배경과 맥락

> <span color="gray">어떤 이유 때문에 필요 했는가?</span>

<p>
웹소켓 장애 대응 LifeCycle을 설계하다, 브라우저에서 새로고침시에 세션이 이미 있다고 연결되지 않는 이슈가 발생했다. connect, reconnect의 문제라고 생각했다.
</p>

WebSocket reconnect 로직을 구현하면서 <b>이전 세션 종료와 새 연결 시도</b>가 비동기 이벤트 순서로 충돌 → 경쟁상태 발생

<b>이번 배경은 웹소켓의 경쟁상태를 개선하면서 도입하게 된 </b><b><span color="red">웹소켓 상태 관리(state guard) </span></b><b>에 대한 배경</b>

<callout color="gray_bg">
TOSS, naver 등 기업에서 웹소켓을 다양한 상황에서 활용하면서 면접 이나 코테에서 웹소켓에 대한 지식을 물어보는 경우가 많아졌다고 한다. 때문에 웹소켓의 기본인 장애 대응책을 비롯해 이벤트 루프에서 처리하는 순서에 대해 알아보고자한다.
</callout>

## 2. 기술 키워드

> <span color="gray">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

- <b>콜 스택 : </b>메인스레드에서 현재 실행 컨텍스트를 관리해 주는 자료구조
- <b>백그라운드 : </b>비동기 함수는 web api(브라우저)에서 실행된다.
  - 백그라운드는 JS 런타임환경이 아닌 브라우저 런타임 환경에 존재
- <b>이벤트 루프 :</b> 이벤트 큐(작업 완료된 비동기 함수) → 콜스택으로 돌려보낼 수있도록 순서 관리 \[신호등\]
  - 종류 2가지 (우선순위 내림차순)
    1. 마이크로테스크 큐 : promise 객체 등의 작업
    2. 테스크 큐 : I/O, setTimeout 등의 작업

> <b>코드의 의도</b>

- <b>“연결이 끊기면 자동으로 연결해라”</b>

```javascript
//STOMP를 사용하였지만 기본적인 구조를 확인하기 위해 기본 socket 코드로 가져와보았습니다.
let socket;

function connect() {
  socket = new WebSocket("wss://example.com/ws");

  //소켓이 열리고 나면 실행시켜주세요 : onopen
  socket.onopen = () => {
    console.log("connected");
  };
  //소켓이 닫히고 나면 실행시켜주세요 : onclose
  socket.onclose = () => {
    reconnect();
  };
}

function reconnect() {
  console.log("reconnecting...");
  setTimeout(() => {
    connect();
  }, 1000);
}
```

<quote color="gray_bg">
<b>발생할 수 있는 문제</b>

<p>
소켓의 장애 대응할 일이 많습니다 → 특히 소켓 Ping/pong 확인시에도 연결이 끊김이 확인되면 재연결을 시도해야합니다.
</p>

- 네트워크 끊김
- 서버 restart
- 연결이 끊기면서 token refresh

모두 동시에 일어날경우 → connect는 3번 시도한다.
</quote>

→ 불필요한 소켓이 3개나 연결되어있을 수도 있음 : 때문에 한 사이트에서는 하나의 소켓만 연결해둔다.

<b>소켓 하나만 연결하는 것으로 정책을 세웠을때 문제 발생점</b>

- <b>새로고침 시 connect</b>
  1. 새로고침 시에 기존의 소켓이 close가 됨. (이때 네트워크 요청이 느려서 소켓이 완전히 닫히지 않음.)
  2. 소켓 연결 요청이 들어옴 → 이미 소켓이 열려있어서 서버관점에서는 소켓연결을 거부함.

## 3. 고민했던 내용과 인사이트

### <b>❓ 해당 connect가 두번 발생하는 문제에 이벤트 루프가 크게 관여한 점이 없는데?</b>

<ul>
<li>
이벤트 루프가 비동기를 관리하기 때문에 이벤트 루프와 관여가 있다고 한것이었음.
</li>
<li>
이벤트 루프가 아니라, 비동기 - 네트워크 응답 시간에 의한 문제였음.

- 하지만 이벤트 루프로 인해 웹소켓을 사용하면서, 페이지 mount, socket close, reconnect timer, token refresh 등 다양한 이벤트가 발생하고 이벤트 루프에 의해 의도했던 순서대로 발생하지 않을 가능성이 높다.<b><span color="blue"> → 불가피한 많은 다양한 문제점이 발생될 가능성 농후</span></b>
  <p>
  <b>→ 상태관리의 필요성</b>
  </p>
</li>
</ul>

### <b>❓ 페이지 새로고침 시 이전 JS가 언제 완전히 종료되는지</b>

- 대부분의 경우 새로고침하면 기존 페이지의 JS 실행 컨텍스트는 바로 종료되기 때문에 <code>onclose → reconnect()</code>가 실행되지 않는다.

### <b>❓ 그럼 실무에서는 어떻게 관리하는가? → 웹소켓의 상태관리</b>

> <b>connection state(연결 상태)관리</b>

<ul>
<li>
connect 호출시 stomp의 경우

<image source="notion-file-block://3cfee90a-967f-803c-b16b-d0e708566eb8/1ef4ff29-9f55-4f8d-8055-23b241ac0672?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
</li>
<li>
<b>CONNECT(클라이언트 → 서버 메시지)</b>와 <b>CONNECTED(서버 → 클라이언트 메시지)</b>

- CONNECT가 왔을 경우에 아무것도하지 않고 반환
</li>
</ul>

```javascript
if (state === "CONNECT" || state === "CONNECTED") return
```

<b>비동기 작업인 웹소켓의 라이프사이클</b>

<callout color="gray_bg">
IDLE → CONNECT → CONNECTED → DISCONNECTING → IDLE
</callout>

- <b>웹소켓 상태관리 도입</b>
  - <b>connect : </b>이미 연결 중이면 connect 무시

  ```javascript
  function connect() {
    if (state === "CONNECT" || state === "CONNECTED") {
      return
    }

    state = "CONNECT"

    socket = new WebSocket(url)
  }
  ```

  - onopen

  ```javascript
  socket.onopen = () => {
    state = "CONNECTED"
  }
  ```

  - onclose

  ```javascript
  socket.onclose = () => {
    state = "IDLE"
    scheduleReconnect()
  }
  ```

  <ul>
  <li>
  reconnect

  - <b>지수 백오프(exponential backoff)</b>
    <p>
    1초→2초→4초→8초  (지수적으로 증가시킴)
    </p>

    <p>
    : 분산 시스템과 네트워크 시스템의 표준 재시도 전략

    → 네트워크 무한 대기 및 서버 트래킹 방지
    </p>
  </li>
  </ul>

  ```javascript
  let retry = 0

  function scheduleReconnect() {
    const delay = Math.min(1000 * 2 ** retry, 30000)

    setTimeout(() => {
      connect()
      retry++
    }, delay)
  }
  ```

→ 모든 connect는 state guard로 보호
