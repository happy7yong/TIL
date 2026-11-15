# JSX와 React Element

## 정의


## 특징


React 렌더링 전체 과정

1. JSX 변환 : 화면 구조를 React Element로 표현
2. Trigger : 초기 렌더링 또는 상태 업데이트
3. Update Queue · Scheduling : 업데이트 등록, 처리 시점과 우선순위 결정
4. Render Phase : 컴포넌트 실행 → Fiber 작업 → Reconciliation
5. Commit Phase : 실제 DOM에 확정된 변경 사항 반영
6. Browser Paint · Effects : 화면 표시 및 외부 시스템 동기화

#### JSX를 작성하면 바로 화면에 그려질까?

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  return <h1>{count}</h1>;
}
```

return \<h1>\{count\}\</h1>은 실제 DOM을 직접 만드는 작업이 아니다.

JSX는 변환 도구에 의해 <b>JavaScript 함수 호출 형태로 변환</b>되고, 실행되면 React Element라는 객체를 반환. React가 그 결과를 바탕으로 다음 UI를 계산

## 실제 사용 예시(사례)


### JSX를 작성했다고 실행이 되는 건 아니다.

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(c => c + 1)}>
      숫자: {count}
    </button>
  );
}

const root = createRoot(document.getElementById("root"));
root.render(<Counter />);
```

- \<Counter/>는 JSX 구문이며, 변환 도구가 이것을 JavaScript 함수 호출 형태로 바꿔준다
  ```javascript
  jsx(Counter, {}); //바꾼 예시 
  ```

  <p>
  이후, 이 함수가 실행되면 react Element객체로 바꾼다.
  </p>
- root.render()가 실행되면, React가 해당 element 요소를 받아 렌더링 작업을 시작하고, 그 과정에서 <code>Counter()</code>를 실행해.
  - \<Counter /> → React Element 생성
  - React Render → <code>Counter()</code> 실행
  - React Commit → 실제 DOM 반영

## 보조 개념 정리


- React Element : 리액트에게 어떤 객체를 렌더링하면 좋을지 객체를 알려준것일뿐. 실행과는 다르다.
  ```javascript
  {
    type: Counter,
    props: {}
  }
  ```

---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

