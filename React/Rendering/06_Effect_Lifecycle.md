# Effect Lifecycle

## 정의


<toggle>
<b>Effect가 참조하는 props나 state가 바뀔 때 기존 Effect의 Cleanup은 언제 실행되나요?</b>

<p>
의존성 배열이 변경될 때, effect가 실행되는데 cleanup이 선실행됩니다. 
</p>
</toggle>

<toggle>
<b>클린업이 이전 값을 알고 있을 수 있는이유.</b>

<p>
자바스크립트의 클로저 때문에 기억하고 있습니다. 클로저는 함수 객체가 생성될 당시의 시점 값을 렉시컬 환경의 환경 레코드 값을 기억하는 것입니다. 따라서 클로저 함수가 이전 props를 받아도, 함수 객체는 해당 props의 값을 기억하고 있기 때문에, commit단계에서 클린업을 실행할때 이전 props값을 실행합니다. 
</p>
</toggle>

<toggle>
<b>의존성 배열의 값이 변경을 감지하는 기준이 뭔가요? </b>

<p>
리액트 useEffect의 의존성 배열은 이전 렌더링 값과 object.is로 비교합니다. objectis는 원시값은 값의 동일성을 비교하고 객체는 객체의 참조값을 비교하여, 객체 안의 값이 같더래도, 객체의 참조가 달라지면 의존성이 변경되었다고 판단합니다. 
</p>
</toggle>

<toggle>
<b> (React 07)useEffect는 어떤 종류의 작업에 사용하며, 사용자 이벤트 핸들러에서 처리하는 작업과 어떻게 구분하나요?</b>

useEffect는 상태나 props를 기준으로 외부 시스템과 동기화 해야할 때 사용합니다.

하지만, 이벤트 핸들러는 <b><span color="red">사용자의 특정행동을 처리하고 그 결과를 반영해야할 때 사용합니다.</span></b>

예를 들어 페이지가 마운트 되었을때 필요한 목록 데이터를 불러오는 작업은 Effect에서 처리할 수 있습니다. 하지만 저장버튼을 눌러 서버에 데이터를 전송해야할 때는 이벤트 핸들러로 처리할 수 있습니다.
</toggle>

<toggle>
useEffect에 들어갈 작업과 이벤트 핸들러에 들어갈 작업을 분리하는 기준

useEffect와 이벤트 핸들러는<b> 작업이 실행되어야하는 기준, 특정 행동에 따른 작업인가, 렌더링 결과에 따라 필요한 작업인가</b>으로 분리됩니다.

useEffect는 렌더링 props나 state에 따라 외부시스템과 동기화해야할때 사용되며, 이벤트 핸들러는 특정 사용자의 행동에 실행되어야할 때 사용합니다

예를 들어 첫 페이지가 마운트되어 페이지에서 필요한 데이터를 호출하거나 websocket을 연결하는 작업에서는 useEffect를 사용하고, 사용자가 저장버튼을 눌렀을때 데이터를 전송해야할 경우 이벤트 핸들러를 사용합니다.
</toggle>

<toggle>
<b>(React 08)Effect가 참조하는 props나 state가 바뀔 때 기존 Effect의 Cleanup은 언제 실행되나요?</b>

<p>
props나 state가 변경되어 새로운 렌더링이 커밋되면, 리액트는 이전 렌더단계에서 등록해둔 cleanup함수를 실행하고 새로운 setup함수를 실행합니다. 
</p>
</toggle>

<toggle>
<b>(React 09)의존성 배열에 매 렌더링마다 새로운 객체를 넣으면 Effect가 다시 실행될 수 있는 이유는 무엇인가요?</b>

의존성 배열은 object is로 비교하여 이전 렌더링 결과를 비교하기 때문입니다.

<b>핵심 : 매 렌더링 마다 새로운 객체를 생성해서 의존성 배열에 넣으면 객체의 참조값이 달라지고, 의존성 배열의 objectis는 참조값이 달라졌기에 값이 달라졌다고 판한다여 effect를 실행합니다. </b>
</toggle>

<toggle>
<b>(React 10)의존성이 변경되었을 때 Cleanup이 이전 Render의 값을 사용하는 이유는 무엇인가요?</b>

클린업 함수는 셋업함수가 실행될때 생성되어 반환되고 리액트가 이 함수 객체를 보관합니다. 클린업함수는 생성당시의 렉시컬 환경을 참조하고 있기 때문에, 새로운 렌더가 발생하더래도 이전 props나 state값을 사용할수있습니다.
</toggle>

<toggle>
<b>(React 11)Hook을 조건문이나 반복문 안에서 호출하면 문제가 되는 이유는 무엇인가요?</b>

리액트에서 hook은 각 hook을 호출 순서를 기준으로 대응시키기 때문입니다. hook이 조건문이나 반복문을 통해 호출순서가 달라지거나 갯수가 달라질경우, hook이 기존 자신의 hook을 대응하지 못하고 상태를 일관적이게 관리하지 못할 수 있습니다. 따라서 hook은 각 컴포넌트의 최상위에서 호출하거나 조건부 동작이 필요할때 hook 안에서 반영해야합니다.
</toggle>

<b>키워드</b>

- 사용자
- 행동
- 처리
- 작업
- 렌더가 커밋되다.

> <b>알고있어야할 기본 개념 </b>

<ul>
<li>
객체를 생성하는 것 (환경레코드에 등록)과, 객체를 실행하는 것(실행컨텍스트에서 실행)은 다르다. 

```javascript
react = () => {
	console.log("B")
	return ()=> {console.log("A")} //객체 2
}//객체 1

return_fun = react()
return_fun()

//출력결과 B, A
```

1. react 변수는 <b>함수 객체1</b>을 생성하고 렉시컬 환경의 환경레코드에 저장한다.
2. react() 를 <b><span color="yellow_bg">호출</span></b>하면, <b>함수 객체1</b>가 실행 컨텍스트에 등록되고 “B”를 출력합니다.
3. <b>함수 객체2</b>는 생성되면 참조값이 return\_fun의 환경레코드 바인딩에 저장된다.
4. return\_fun()를 <b><span color="yellow_bg">호출</span></b>하면, <b>함수 객체2</b>를 실행 컨텍스트에 등록하고 “A”를 출력합니다.
</li>
</ul>

## 특징


- Concurrent Rendering 과 Effect LifeCycle 의 관계
  - <b>Render 단계:</b> React가 다음 UI를 계산하는 단계. Concurrent Rendering에서는 이 작업이 중단되거나 폐기될 수 있어. → 확정되지 않은 작업들을 많이 수정해, 빈번하게 수정작업이 발생됨.(불안정한 작업)
  - <b>Commit 단계:</b> 완료된 렌더링 결과를 확정하고 필요한 DOM 변경을 반영하는 단계. (안정적이고 확정된 작업)
  - <b>Effect:</b> Commit 이후, 실제로 반영된 컴포넌트를 기준으로 외부 시스템과 동기화하는 작업.
    - Commit이후에 effect 작업이 진행되는 것이 핵심. paint 전후관계는 확실하지 않음.

  <p>
  → render단계에서는 확정되지 않은 많은 작업이 일어나고 폐기되거나 재개되거나 수정되는 일이 많이 발생하기 때문에<b><span color="red"> 일관성을 지키기 위해 </span></b>확정된 렌더링인 commit 이후에 useEffect를 진행
  </p>

### useEffect 실행 순서

1. render
2. commit
3. if useEffect 의존성 배열값 변경 시
   1. cleanup 실행
   2. setup 실행

### 1 useEffect는 왜 필요할까?

외부 시스템과의 작업은 순수하게 발생해야하기 때문이다.

컴포넌트를 렌더링 하는 도중에 웹소켓 연결이 시작한다. 만약 렌더링 결과가 폐기될 경우, 화면에 채팅방이 표시되지 않는데 웹소켓이 연결될 수 있습니다. 이런 외부 시스템과의 동기화를 위해 effect를 사용한다.

<b>useEffect는 화면에 커밋이 진행된 이후, 화면에 실제로 반영된 이후에 연결을 시작하고 사용하지 않을 경우 cleanup으로 해제합니다.</b>

- <b>useEffect에 넣을 부수효과 기준 : 작업이 실행되어야 하는 원인</b><b><span color="red">(특정 행동에 따른 작업인가, 렌더링 결과에 따라 필요한 작업인가</span></b><b>)</b>
  <ul>
  <li>
  <b>Event Handler:</b> 사용자가 특정 행동을 요청했을때, 그 결과를 처리하는데 사용
  </li>
  <li>
  <b>Effect:</b> 사용자의 특정 행동에 상관없이 컴포넌트가 외부 작업이 필요해질때 사용 
  </li>
  </ul>

  
  
### <b>2 Setup-Cleanup-Setup</b>

React는 의존성이 변경되어 Effect를 다시 실행할 때 <b>이전 Effect의 Cleanup을 먼저 수행하고 새로운 Setup을 실행해.</b>

- useEffect : 매 Render마다 실행되지 않는다.
  - 의존성 배열의 값이 같을 경우, 다시 실행되지 않는다.
- cleanup : cleanup은 새로운 render가 시작되는 순간 실행되는 것이 아니다.
  - 의존성 배열이 변경되면 새로운 effect가 실행되기전에 클린업이 실행된다.

### <b>3 Cleanup은 어떻게 이전 Render의 값을 사용할까?</b>

- <b>javascript의 closure를 이용</b>
- cleanup함수는 effect가 setup될때 만들어지는 함수이다.
- useEffect에 전달하는 Setup 함수는 <b>Render 단계에서 생성되어 React에 전달</b>된다.
- Setup 함수는 <b>Commit 이후 실행</b>되며, 이때 return으로 Cleanup 함수 객체를 반환한다.
- React는 반환받은 Cleanup 함수를 보관하고 있다가 <b>의존성이 변경되거나 컴포넌트가 언마운트되면 호출</b>한다.
- Cleanup 함수는 Closure를 통해 이전 Setup 및 Render의 렉시컬 환경을 참조하므로 <b>이전 props와 state 값을 사용할 수 있다.</b>

### 4 의존성 배열의 값이 변경을 감지하는 기준

- object.is() : 참조 동일성 비교
- <b>객체의 참조값이 동일한지 비교합니다.</b>
- <b>발생할 수 있는 문제 : </b>리렌더링을 진행할 때마다 의존성 배열에 있는 값이 같더래도 참조하는 객체가 다르다면 useEffect는 실행될 수 있습니다.

### 5 Rules of Hooks

- 같은 컴포넌트의 인스턴스가 매 렌더에서<b> hook의 호출 순서와 갯수가 동일</b>해야한다.
  <ul>
  <li>
  이유 : 리액트는 hook을 변수이름으로 구분하지 않고 <b><span color="red">호출 순서에 따라 hook을 대응</span></b>시킨다. 
  </li>
  </ul>
- <b>발생할 수 있는 문제 / 조건부 실행 : </b>조건문이나 반복문에서 hook을 호출하면 호출순서와 갯수가 달라질 수 있기 때문에 최상위에서 호출해야합니다.

### 6 Strict Mode

<ul>
<li>
useEffect를 추가로 실행시켜, 클린업함수가 작성되어있는지 확인한다. 
</li>
<li>
<b>없으면 발생할 수 있는 문제 : </b>클린업함수가 필요한 상황에서 클린업 함수가 없을경우, 이전 렌더링에서 생성된 셋업함수 객체는 정리되지 않고, 중복으로 등록될 문제가 발생할 수 있다. 

- 서로 다른 두 함수 객체 A와 B를 이벤트 리스너로 등록
- <b>불필요한 이벤트 처리와 메모리 점유 문제 </b>
</li>
</ul>

## 실제 사용 예시(사례)


예를 들어 채팅방 A에서 B로 이동하는 렌더링이 시작됐는데, 도중에 C로 이동하는 업데이트가 발생해서 B의 렌더링이 폐기됐다고 했을 경우

- B 채팅방은 실제 화면에 확정되지 않았으니까, B에 대한 WebSocket 연결도 시작되지 않는 거지

### useEffect와 이벤트 핸들러 구별

```javascript
function ChatRoom() {
  const [roomId, setRoomId] = useState("A");

  function handleChangeRoom() {
    setRoomId("B");
  }

  useEffect(() => {
    const socket = connectToRoom(roomId);

    return () => socket.disconnect();
  }, [roomId]);

  return (
    <button onClick={handleChangeRoom}>
      B 채팅방으로 이동
    </button>
  );
}
```

- <b>이벤트 핸들러 :</b> 버튼을 눌렀을때, 누른 행동 자체를 처리 : B로 아이디 바꿈
- <b>Effect : </b>변경된 roomId에 맞춰 채팅방 화면을 바꾼다 - 외부 세션 연결을 유지

### setup - cleanup - setup

```javascript
function ChatRoom({ roomId }) {
  useEffect(() => {
    const socket = connectToRoom(roomId);
    console.log(`${roomId} 연결`);

    return () => {
      socket.disconnect();
      console.log(`${roomId} 연결 해제`);
    };
  }, [roomId]);

  return <div>{roomId} 채팅방</div>;
}
```

- <b>Setup:</b> A 채팅방 WebSocket 연결
- <b>Cleanup:</b> 기존 연결을 정리하는 함수
- <b>Dependency:</b> roomId가 바뀌면 Effect를 다시 동기화할 필요가 있는지 판단하는 기준

#### 채팅방A에서 B로 이동할때 흐름

```javascript
function ChatRoom({ roomId }) {
  useEffect(() => {
    const socket = connectToRoom(roomId);
    console.log(`${roomId} 연결`);

    return () => {
      socket.disconnect();
      console.log(`${roomId} 연결 해제`);
    };
  }, [roomId]);

  return <div>{roomId} 채팅방</div>;
}
```

1. <b>A 채팅방 Commit 완료 : setup A 실행완료 → A 연결 시작</b>
2. <b>roomID B 로 변경 : B에 대한 Render → Commit 완료</b>
3. <b>기존 Effect Cleanup : Cleanup A 실행 → A 연결 중단</b>
4. <b>새 Effect Setup : Setup B 실행 → B 연결시작</b>

<b>hello 값이 A에서 B로 변경될 때 useEffect가 일어나는 전체 흐름 </b>

```javascript
useEffect(() => { //Setup 함수
  console.log(`Setup!${hello}`);

  return () => { //Cleanup 함수
    console.log(`Cleanup!${hello}`);
  }; 
}, [hello]);
```

1. <b>Render A</b>
   <p>
   컴포넌트 함수가 props로 hello = A로 받았을때, useEffect에 <b>Setup A 함수</b>를 리액트에 <b><span color="purple">등록</span></b>한다.
   </p>

   <p>
   렉시컬 환경의 환경레코드에 해당 <b>setup A </b>함수의 참조를 바인딩한다.
   </p>
2. <b>Commit A 이후</b>
   <p>
   리액트가 setup <b><span color="purple">함수</span></b>를 실행한다. →<b><span color="blue"> Setup! A</span></b> 출력
   </p>

   <p>
   <b><span color="green">Cleanup A </span></b>함수를 리액트에 등록한다. 동일하게 부모 렉시컬환경 환경레코드에 해당<b> cleanup A </b>함수의 참조를 바인딩한다. 
   </p>
3. <b>Render B</b>
   <p>
   컴포넌트 함수가 props로 hello = B로 받았을때, useEffect에<b> </b><b><span color="blue">Setup B </span></b><b>함수</b>를 리액트에 <b><span color="purple">등록</span></b>한다.
   </p>

   <p>
   부모 렉시컬 환경의 환경레코드에 해당<b> Setup B </b>함수의 참조를 바인딩한다.
   </p>
4. <b>Commit B 이후, Effect 재동기화</b>
   <p>
   리액트가 클린업 함수를 선실행한다. → <b><span color="blue">Cleanup! A</span></b><b> 출력</b>
   </p>

   <p>
   리액트가 셋업 함수를 <b><span color="purple">실행</span></b>한다 → <b><span color="blue">Setup! B </span></b><b>출력 </b>
   </p>

   <p>
   <b><span color="green">Cleanup B</span></b>함수를 리액트에 등록한다. 동일하게 부모 렉시컬 환경 환경레코드에 해당 cleanup B 함수의 참조를 바인딩한다.
   </p>

### 의존성 배열이 object.is라서 발생할 수 있는 문제

<ul>
<li>
해당 코드에서 (Trigger)사용자가 버튼을 눌렀을 때 (Render)리렌더링발생, chatRoom 컴포넌트는 실행된다. options 함수객체는 새롭게 생성되고, useEffect의 의존성 배열이었던 options는 인스턴스가 변경되어 useEffect는 (Commit)setup함수를 실행한다. 

- roomId가 변경되지 않았어도, 불필요하게 채팅방연결을 해제하게 되는 일이 발생

```javascript
function ChatRoom({ roomId }) {
  const [count, setCount] = useState(0);

  const options = {
    roomId: roomId,
  };

  useEffect(() => {
    console.log("채팅방 연결", options.roomId);

    return () => {
      console.log("채팅방 연결 해제");
    };
  }, [options]);

  return (
    <button onClick={() => setCount(c => c + 1)}>
      클릭 횟수: {count}
    </button>
  );
}
```
</li>
<li>
해결 방법

- useEffect안에서 객체를 만들고, 원시값을 의존성배열에 넣는다.

```javascript
function ChatRoom({ roomId }) {
  useEffect(() => {
    const options = { roomId };

    const socket = connectToRoom(options);

    return () => {
      socket.disconnect();
    };
  }, [roomId]);

  return <div>{roomId} 채팅방</div>;
}
```
</li>
</ul>

## 보조 개념

<ul>
<li>
환경 레코드 : 객체를 보관하는 공간 자체라기보다 식별자와 바인딩을 관리하는 구조

- 객체는 힙 안에 저장되고, <b>참조값이 부모 렉시컬 환경의 환경레코드에 바인딩 </b>되는 구조
</li>
<li>
[object.is](http://object.is) : 객체 참조 동일성 
</li>
</ul>

---

## 회고

<ul>
<li>
<b>양이 제일 방대하고 길다.. 보통 학습이 1시간에서 2시간 내외였는데 useEffect파트는 혼자 3시간분량.. </b>
</li>
<li>
실행컨텍스트 환경레코드 렉시컬 환경 다 useEffect에서 나오는구만 다 아는사람들이구먼 
</li>
</ul>

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

