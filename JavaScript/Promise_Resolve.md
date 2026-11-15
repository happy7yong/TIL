# Promise, resolve

## 정의


- promise : <b>작업의 상태와 결과</b>를 나타내는 객체
- resolve : 작업을 성공적으로 이행했을 경우 실행하는 함수
- then : Promise가 이행되었을 때 실행할 콜백을 등록하는 함수

## 특징


## 실제 사용 예시(사례)


```javascript

const promise = new Promise((resolve) => {
  console.log('A');
  resolve('완료!');
});

promise.then((result) => {
  console.log('B', result);
});

console.log('C');

```

1. <code>new Promise()</code> 안의 실행 함수는 즉시 동기적으로 실행돼. 그래서 <code>A</code>가 출력되지
   <ol>
   <li>
   promise안에 객체가 생성될때 이기 때문에, 초기값 함수? 
   </li>
   </ol>
2. <code>resolve('완료!')</code>를 호출하면 Promise가 성공 상태로 이행돼.
3. <code>.then()</code>에 등록한 콜백은 Microtask로 예약되어, 현재 동기 코드가 끝난 다음 실행돼.

```javascript

Promise.resolve().then(() => {
  heavyCalculation();
});

```

Promise.resolve() → 이미 성공한 프로미스 객체를 만들겠다. 이후 then에있는 함수를 마이크로테스크 큐에 예약하겠다.

## 보조 개념 정리


## 면접 질문

- <code>Promise.resolve().then(() => heavyCalculation())</code>에서 Promise를 사용했다는 이유만으로 메인 스레드 블로킹이 해결됐다고 볼 수 있을까?
  - 기존 자바스크립트 메인 스레드에서 실행되고 있었습니다. 왜냐하면 Promise.resolve는 프라미스 상태를 성공 상태로 이행시킨 다음에 then이 heavy calculation 함수를 마이크로태스크 큐에 예약하겠다는 뜻이기 때문에 마이크로태스크 큐에 예약이 된 후에 마이크로태스크 큐 콜백 함수를 실행할 시점이 다가오면 자바스크립트 콜스택인 메인 스레드에 올라가서 실행이 될 것이기 때문입니다.

---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

