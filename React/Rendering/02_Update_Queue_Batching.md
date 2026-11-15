# Update Queue와 Batching

## 정의


<ul>
<li>
updateQueue : (짧 개념 : 추상적이어도됨.)리액트에서 상태 업데이트를 요청하는 함수를 저장하는 내부구조입니다. (특징)setState와 같은 상태 업데이트 함수가 호출되면 updateQueue에 함수가 저장되고, 렌더링 과정에서 순차적으로 실행합니다.  
</li>
<li>
<b>React에서 setState에 값을 직접 전달하는 방식과 함수형 업데이트 방식은 어떤 차이가 있나요?</b>

<p>
<b>다음 상태를 계산하는 방식</b>에서 차이가 존재합니다. 
</p>

값을 직접 전달하는 방식은 현재 렌더링 시점의 상태를 기준으로 계산한 값을 전달합니다. 따라서 같은 이벤트에서 setCount(count + 1)을 여러 번 호출하면 모두 같은 값을 요청하게 됩니다. 반면 함수형 업데이트는 이전 상태를 받아 다음 상태를 계산하는 함수를 전달합니다. React는 렌더링 과정에서 이 함수들을 순서대로 처리하며, 앞선 업데이트의 결과를 다음 함수에 전달합니다.
</li>
<li>
<b>Trigger에서 두 개의 업데이트 요청을 등록했다면, 다음 Render에서 React는 이 요청들을 어떻게 처리하고 최종적으로 어떤 상태 값을 계산할까?</b>

이벤트 핸들러에서 setCount가 두 번 호출되면 두 개의 업데이트 요청이 큐에 등록됩니다. 이후 React가 렌더링 과정에서 업데이트 함수를 순서대로 처리합니다. 첫 번째 함수는 0을 받아 1을 반환하고, 두 번째 함수는 그 결과인 1을 받아 2를 반환하므로 최종 상태는 2가 됩니다
</li>
<li>
<b>(React - 02)React에서 이전 state를 바탕으로 다음 state를 계산할 때 함수형 업데이트를 쓰는 이유는 무엇인가요?</b>

함수형 업데이트는 이전 값에 의존하여 다음 상태를 업데이트할 때 사용합니다. React는 setState의 함수를 받으면 업데이트 큐에 등록하고, 순차적으로 실행합니다. 이때 함수형 업데이트는 이전 업데이트 결과를 인자에 전달하여 다음 업데이트에 반영하여 계산하기 때문입니다.
</li>
<li>
<b>(React - 03)같은 클릭 핸들러에서 setCount(count + 1)을 세 번 호출하면 다음 render에는 어떤 값이 반영되나요?</b>

다음 렌더러에서는 초기 값에서 1을 증가한 값이 반영됩니다. setCount안에 값을 전달한 방식은 클릭 핸들러가 생성된 시점에 참조하고 있는 상태를 기억하기 때문입니다. 따라서 여러번 setCount안에 값을 전달하여 호출하더래도, 해당 값은 같은 값을 참조 하고 있기 때문에 다음 렌더링에 여러번의 호출이 반영되지 않습니다.
</li>
<li>
<b>(React - 04) 같은 이벤트 안에서 먼저 값으로 state를 교체하고 뒤에서 updater 함수를 넘기면 React는 두 업데이트를 어떤 순서로 계산하나요?</b>

리액트는 업데이트 큐에 등록된 순서대로 처리합니다. 때문에, 먼저 전달받은 값을 상태로 교체하고, 업데이트 함수는 이전 업데이트 결과를 인자로 받아 다음 업데이트에 반영합니다.
</li>
</ul>

> <b>기출 변형 문제</b>

- <b>여러 상태 업데이트가 연속해서 발생할 때뿐 아니라, 비동기 콜백이나 오래 유지되는 이벤트 핸들러에서도 함수형 업데이트가 유용할 수 있는 이유는 무엇일까?</b>
  <ul>
  <li>
  값을 전달하는 방식을 사용할 때에는, 오래된 상태 값이 계산한 최신 값을 덮어쓸수있다.  
  </li>
  <li>
  값을 전달하는 방식에서는 현재 렌더링에서 참조하는 상태로 계산하기 때문에, <b>오래된 상태</b>를 사용할 수 있다. 반면 <b>함수형 업데이트는 리액트에서 업데이트를 처리할때, </b><b><u>이전 업데이트 결과를 인자로 받아 다음 업데이트에 반영</u></b><b>한다.</b> 그래서 <b><span color="blue">이전 상태에 의존하는 변경일 경우(이유)</span></b> 함수형 업데이트가 더 유리하다.
  </li>
  </ul>

### 자주 사용되는 단어

- <b><span color="blue">참조 </span></b>
- <b><span color="blue">오래된 상태</span></b>
- <b><span color="blue">이전 업데이트 결과 → 인자</span></b>
- <b><span color="blue">기억</span></b>
- 등록
- 처리
- 계산
- 반영
- 의존

## 특징


- <b>React는 각 Hook이나 컴포넌트와 연결된 업데이트를 관리</b>
- <b>리액트의 렌더링 큰 핵심 3단계 : </b><b><span color="red">Trigger </span></b><b>→ Render → Commit </b>

리액트에서 useState로 가져온 state 값은 <b>렌더링 시점의 상태를 담은 값</b>이다.

- <b><span color="red">State as snapshot</span></b><b> </b>: <b>상태를 렌더링 시점의 스냅샷처럼 다룬다.</b>
- <b>핵심 : 이벤트 핸들러는 자신이 생성된 렌더링 시점의 상태값을 기억한다.</b>
  - 완전 환경 레코드랑 비슷 → 실제로 <b><span color="red">클로저(오래된 상태)</span></b>랑 연결된다고 함.

### updateQueue : 상태 관리 업데이트 자료구조

<ul>
<li>
useState가 함수로 전달되었을때, 함수들이 실행되기를 기다려야할때 업데이트 큐에서 대기한다. 
</li>
<li>
일반 계산함수는 업데이트 큐에 포함되지 않는다.
</li>
<li>
<b>값을 전달하는 방식도 업데이트 큐에 등록된다. (값전달, 함수전달 둘다 등록)</b>

```javascript
function handleClick() {
  const result = calculate(10); // 즉시 실행

  setCount(prev => prev + 1);   // React에 업데이트 요청
}

function calculate(n) {
  return n * 2;
}
```

- calculate(10)은 일반적인 JavaScript 함수 호출
- setCount(prev => prev + 1)은 React에 상태를 업데이트해 달라는 요청
- <b>각 과정의 역할 : 상태 업데이트 요청은 Trigger , 상태를 계산하는 것은 Render , 결과를 화면에 반영하는 것은 Commit</b>
  - Trigger: <code>setCount</code> 호출 시 업데이트 요청이 큐에 등록됨. <b>→ 대기</b>
  - Render: React가 큐에 등록된 업데이트를 처리해 다음 상태를 계산함.
  - Commit: 필요한 DOM 변경이 실제 화면에 반영됨.
</li>
</ul>

### 버튼을 처음 클릭했을때의 과정

1. 현재 렌더링 count값은 0
2. setCount(1)로 상태 업데이트 요청
3. 같은 이벤트 핸들러에는 consolelog상태에 0이 출력됨.
4. 리액트가 상태를 업데이트하고, 1표시
5. 화면의 버튼에 1표시

- 0으로 출력되는 이유 : 리액트에서 각 hook은 컴포넌트와 연결된 업데이트를 관리하고 있기 때문에, 해당 이벤트 핸들러가 생성된 렌더링 시점의 스냅샷, 즉 렌더링 시점의 상태를 기억하고 있기 때문이다.

<b>값을 직접 전달하는 방식</b>

```javascript
function handleClick() {
  setCount(count + 1);
  setCount(count + 1);
  setCount(count + 1);
}
```

- 정답 : 1
- 이유 : 이벤트 핸들러가 생성된 시점에 참조하고 있는 상태값을 기억하고 있기 때문에 count는 단지 핸들러가 알고있는 상태값일뿐이다. 때문에 여러번 상태 업데이트를 요청해도,이 시점의 count값에 요청하는 것이다.
  - <b><span color="red">이벤트 핸들러가 생성된 시점</span></b>

<b>함수를 전달하는 방식</b>

```javascript
function handleClick() {
  setCount(prev => prev + 1);
  setCount(prev => prev + 1);
  setCount(prev => prev + 1);
}
```

- 함수형이기때문에, 순차적으로 함수가 실행되는 것과 같다.
  - 이때 발생한 함수들은<b> 업데이트큐</b>에 쌓인다.
  - <b>각 함수가 </b><b><span color="red">직전 계산 결과를 전달</span></b><b>받는다</b>

---

## 실제 사용 예시(사례)

### 비동기 콜백이나 오래 유지되는 이벤트 핸들러에서도 함수형 업데이트가 유용할 수 있는 이유 : 오래된 상태를 참조하는 현상 (Stale Closure)

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  function handleDelayedClick() {
    setTimeout(() => {
      setCount(count + 1);
    }, 3000);
  }

  return <button onClick={handleDelayedClick}>{count}</button>;
}
```

<quote>
<b>\[문제\] 시간에 따른 상태 변화</b>

1. 처음 <code>count = 0</code>일 때 타이머 등록
2. 다른 이벤트로 상태가 <code>2</code>까지 증가
3. 3초 뒤, 기존 콜백에서 <code>setCount(count + 1)</code> 실행
4. 콜백이 기억한 <code>count</code>는 여전히 <code>0</code>이므로 <code>setCount(1)</code> 요청
5. 업데이트가 처리되면 상태가 <code>2</code>에서 <code>1</code>로 바뀔 수 있음
</quote>

- 함수형 업데이트 방식을 활용할 경우 : 해당 업데이트를 처리할 때마다 누적된 최신 상태로 함수를 전달하기 때문에 2에서 3으로 증가시킬 수 있다.

## 보조 개념 정리


---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

