# 이벤트 루프와 콜백함수

## 정의


- 이벤트 루프란 : 비동기 함수가 실행 되고 난 후 콜백함수를 이벤트 큐에 대기하고, 콜스택으로 옮겨 실행하도록 도와주는 역할
- 콜백 함수란 : 비동기 함수가 완료되고 난 후 실행하는 함수

## 특징


- 자바스크립트는 싱글 스레드이다.
  - 싱글 스레드의 단점 : 하나의 긴 작업이 메인스레드를 점유하고 있으면 다른 작업이 진행되지 못하고 앞의 작업이 완료되어야 실행될 수 있다. → 자원 낭비와 사용성이 저하
    - 메인 스레드를 블로킹하지 않고 처리 기간이 긴 작업을 피해 다른 작업을 먼저 수행할 수 있지 않을까?
      - 비동기 의 필요성
- 자바스크립트는 콜스택으로 운영된다.
- 자바스크립트가 실행환경의 비동기 api를 이용해 비동기 함수를 처리한다.
  - 비동기 함수가 완료되고 난 후 콜백함수가 콜스택으로 바로 들어가지 않고, 이벤트 큐에서 대기한다.
  - 이벤트 큐는 테스크 큐와 마이크로테스크 큐가 존재한다.
    - 테스크 큐(I/O, settimeout) 마이크로테스크 큐(promise.then() … )
- 이벤트 루프는 테스크 큐와 마이크로테스크 큐에 있는 작업들을 <b><span color="red">스케줄링</span></b>한다.
  - 스케줄링 순서
    1. 콜스택이 비면,
    2. 마이크로테스크 큐에있는 작업들을 순차적으로 수행
    3. 마이크로테스크 큐가 비면, 테스크 큐에있는 작업을 하나씩 수행.
       - 예외로 테스크 큐 작업 처리하다가 마이크로테스크 큐 작업이 생기면 마이크로테스크 큐에 있는 작업을 먼저 수행한다.
  - 이때, 이벤트 큐는 단지 대기열일뿐이다. 콜백함수는 콜스택에 올라와야 수행된다.

## 실제 사용 예시(사례)


## 보조 개념 정리


- 싱글 스레드 : 두개 이상의 작업이나 함수가 동시에 실행되지 않고 단일로 실행된다.
- 이벤트 큐 : 테스크 큐와 마이크로테스크 큐가 있으며, 콜백함수가 콜스택으로 올라가기전에 대기한다.
- 콜백함수: 비동기 함수가 처리되고 난 후 실행되어야할 함수
- 자바스크립트의 실행환경 : nodeJS, 브라우저
  - 실행환경마다 비동기 api 백그라운드 제공이 다르다.
    - nodeJS : libuv, 브라우저 : web api

## 면접에서 나올 수 있는 심화

- Microtask Queue에 있는 콜백이 실행될 때마다 새로운 Microtask를 계속 등록한다면, 브라우저 화면 렌더링에는 어떤 영향이 발생할 수 있을까요?
  <p>
  <b>Microtask가 왜 렌더링을 막을까?</b>
  </p>

  ```javascript
  button.addEventListener("click", () => {
    count.textContent = "1";

    queueMicrotask(function repeat() {
      queueMicrotask(repeat);
    });
  });
  ```

  <p>
  버튼을 누르면 JavaScript가 DOM의 숫자를 1로 바꾼다. 그런데 브라우저가 변경된 DOM을 화면에 그리기 전에 Microtask를 처리해야 하는데, 여기서는 Microtask가 끝없이 생성되기 때문에, DOM 안에서는 숫자가 1로 변경됐어도, 실제 화면에는 여전히 0이 보일 수 있다.
  </p>

  <p>
  → 이벤트 루프가 Microtask를 모두 처리한 뒤, 렌더링이 필요한 시점에 화면을 갱신할 기회를 줌 → 이와 같은 상황에서는 이벤트 루프가 계속 Microtask 콜백들이 메인 스레드에서 계속 실행된다 → 화면의 갱신이 지연된다.
  </p>

  <p>
  [마이크로테스크 큐 변형](https://app.notion.com/p/409ee90a967f8099bd0cf49c1341f53e)
  </p>

---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>


---

## 프론트 소모임 추가 정리

## 1. 배경과 맥락

> <span color="gray">어떤 이유 때문에 필요 했는가?</span>

<p>
웹소켓 장애 대응 LifeCycle을 설계하다, 브라우저에서 새로고침시에 세션이 이미 있다고 연결되지 않는 이슈가 발생했다. connect, reconnect의 문제라고 생각했다.
</p>

새로고침 → 새 페이지에서 세션연결 시도<b> connect </b>→ 이전 소켓을 닫음 → 재 연결 시도→<b> connect </b>

<b>: connect 2번 발생</b>

→ 해당 문제를 <b>새 페이지 코드 + 이전 페이지 이벤트 </b>라고 해석했다.

<p>
 싱글스레드인 JS가 비동기 작업이 수행되는 체계를 알아보고자한다.
</p>

---

## 2. 기술 키워드

> <span color="gray">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

### <b>싱글 스레드</b>

- 두개이상의 연산이나 함수를 동시에 실행할 수 없다.
  - 하나의 연산이 실행중이면, 스레드가 block 된다.
- <b>싱글 스레드의 단점</b>
  - 네트워크 요청, DB I/O 등은 시간이 <b><u>오래 걸리는 작업이 스레드를 block 하고 있으면</u></b><u> </u>다른 작업을 수행하지 못한다. → 자원낭비 사용성저하
    - <b><span color="blue"><u>메인 스레드를 block 하지 않고 처리 시간이 긴 작업을 피해 다른 작업을 먼저 실행하게 하면 어떨까?</u></span></b><b><span color="blue"> </span></b><b><span color="yellow_bg">→</span></b><b><span color="red"> 비동기 처리</span></b><b><span color="yellow_bg">의 필요성</span></b>

<quote color="green_bg">
<b>javascript의 실행 환경</b>

1\. 브라우저 2. NodeJs

싱글 스레드인 JS에서는 작업이 콜 스택하나로 운영되는데 비동기 작업을 처리할수있도록 백그라운드를 제공해주는 것이 <b>WebAPI(브라우저)와 LibUv(nodeJS)</b>
</quote>

### <b>비동기 처리는 어디서 하는가?</b>

- <b>브라우저</b>에서 비동기를 처리할 때, <b>Web api </b>를 사용
  - <b><u>메인 스레드가 아니라</u></b><b><span color="red"><u> 백그라운드</u></span></b><b><u>에서 처리</u></b><b> →</b><b><span color="yellow_bg"> 비동기 작업</span></b>
- <b> NodeJS</b>에서 비동기 처리 : libuv 에서 처리

---

### <b>백그라운드</b>(libuv, webapi에서 제공)

- 메인 스레드에 있는 비동기 작업을 <b>백그라운드</b>로 위임한다.
- 메인 스레드에서 요청하였기 때문에 백그라운드에서 어떤 결과가 나왔는지 알수있어야한다.
  <ul>
  <li>
  때문에 비동기 함수를 호출할 때,<b>  </b><b><u>비동기 처리 완료 시에 메인 스레드에서 실행할 함수</u></b>를 함께 전달 →<b><span color="purple"> 콜백 함수</span></b>라고 함. : 대부분의 비동기 함수들은 callback 함수를 받을수있다
  </li>
  </ul>

  <image source="notion-file-block://3cfee90a-967f-8049-b0f2-d4659bd34429/8898f63b-7b36-4410-abac-a7dd6ea36b2c?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
- 콜백함수 :<b> 나중에 다시 호출되어야하는 함수</b>
- <b><span color="blue"><u>해당 콜백함수는 언제 바쁘게 돌아가는 메인스레드에 들어와 실행되어야할까?</u></span></b>
  - 해당 체계를<b> </b><b><span color="red">Event loop</span></b>가 정해준다.


### <b>콜 스택</b>

- 메인 스레드가 <b>현재 실행 중인 함수(실행 컨텍스트)</b> 를 관리하는 자료구조
  <ul>
  <li>
  LIFO(스택)
  </li>
  <li>
  Main Thread = 1, Call stack = 1

  → 동시에 두개의 JS를 실행할수없다.
  </li>
  </ul>

<columns>
<column ratio="50">
<callout color="gray_bg">
<b>Browser Runtime (브라우저 실행환경)</b>

```javascript
└─ JavaScript Engine (V8, SpiderMonkey 등)
   └─ Call Stack
```

```javascript
└─ Runtime Environment (Browser / Node.js)
   ├─ Event Loop
   ├─ Web APIs
   └─ Task Queue / Microtask Queue
```
</callout>
</column>
<column ratio="50">
<image source="notion-file-block://3cfee90a-967f-8040-b9df-c8d67d7e9a1f/08e975b3-1c79-43db-8b6c-e2ecaab5caf5?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
</column>
</columns>

<ul>
<li>
만약 콜 스택에 비동기함수(setTime)가 들어올 경우 <b><span color="red">즉시 </span></b>pop

→ 백그라운드로 이동

→ (비동기 함수 처리 완료) 콜백함수가<b><span color="pink"> </span></b><b><span color="blue">Event Queue</span></b>라는 공간에 쌓인다.

→ 콜백 함수를 Event Queue에서 메인 스레드(Call stack)으로 이동 :<b> </b><b><span color="red">Event Loop </span></b>
</li>
</ul>

### 이벤트 루프

- 주요 행동 : <b>event queue</b>에 있는 비동기 <b>콜백 작업</b>을 <b>콜 스택</b>에 넣어주는 작업
- <b>Event Queue, Call stack의 신호등</b>

### 이벤트 큐

- <b>Task Queue</b>
  - setTimeout, webSocket event message, I/O 등

  ```javascript
  setTimeout(() => console.log("A"), 0);
  ```
- <b>Microtask Queue</b>
  - promise의 작업들을 진행하는 큐
  - 우선순위가 높다

  ```javascript
  Promise.resolve().then(() => console.log("B"));
  ```

### 이벤트 루프의 실행 규칙(스케줄링)

1. Call Stack 실행
2. Microtask Queue 전부 실행
3. Task Queue 하나 실행
4. 다시 Microtask Queue 확인

<p>
→ 콜스택이 비었을때, 마이크로테스크 큐를 확인하고, 마이크로테스크 큐에 있는 작업을 하나씩 콜스택에 올리면서 콜백함수를 처리한다. 마이크로테스크 큐가 완료되면, 테스크 큐가 하나 실행되고, 이때 다시 마이크로테스크 큐에 콜백함수가 들어오면 마이크로테스크 큐에 있는 작업을 콜스택에 올려 처리한다.
</p>

- <b>이벤트 큐에 대기하고 있는 콜백함수는 콜스택에 올라와야 실행이 된다.</b>
- <b>이벤트 큐(테스크 큐, 마이크로테스크 큐)는 대기 큐이다.</b>

<ul>
<li>
그러니까 비동기 함수가 백그라운드에서 처리가 완료된 후에 <b>이벤트 큐</b>에 와서 콜백함수를 대기시키 있다.

<ul>
<li>
큐에 있는 작업은 콜백함수!

```javascript
setTimeout(() => {
  console.log('안녕!');
}, 1000);

//() => {} : 이걸 콜백함수라고 부름. 백그라운드에서 1000시간 셋타임이라는 작업이 완료되면 콜백함수를 부를 수 있도록한다.
```
</li>
</ul>
</li>
</ul>

<h2>
 3\. 고민했던 내용과 인사이트
</h2>

### ❓ setTimeout(() => console.log('A'), 0)과 console.log('B')가 있을 때, 실행 순서

<toggle color="gray_bg">
답

B A

1\. setTimeout 콜백함수 → <span color="red">즉시 </span>백그라운드로 pop

<ol start="2">
<li>
console.log B 콜 스택 실행 (return)
</li>
<li>
콜스택 비워짐
</li>
<li>
백그라운드 → 이벤트 큐 (콜백함수 A) → 콜스택으로 Push
</li>
<li>
console.log A 콜스택 실행 (return)
</li>
</ol>
</toggle>

### ❓ 아래의 코드의 실행 순서

```javascript
console.log('1');
setTimeout(() => console.log('2'), 0);
Promise.resolve().then(() => console.log('3'));
Promise.resolve().then(() => console.log('5'));
console.log('4');
```

<toggle color="gray_bg">
답

1

4

3

5

2

1. 콜스택에 1 4 남고 나머지 전출
2. 테스크 큐에 쌓여있는 2, 하지만 마이크로테스크에 3 5이 쌓여있다.
</toggle>

```javascript

```
