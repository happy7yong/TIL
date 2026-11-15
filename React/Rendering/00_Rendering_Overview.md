# React 컴포넌트 렌더링 과정

## 정의


리액트 컴포넌트 렌더링 과정은, 컴포넌트를 실행해 UI를 계산하고, 변경사항을 실제 DOM에 반영하는 과정이다.

1. Trigger : 초기 렌더링이나, 상태 업데이트로 인해 렌더링이 요청된다.
2. Render : 컴포넌트를 실행하여 UI를 계산하고 현재 VDOM을 만들고, 기존 VDOM와 비교해서 변경이 필요한 부분을 탐색한다.
3. Commit : 렌더 파즈에서 찾은 변경사항을 바탕으로 실제 DOM에 필요한 변경사항을 반영한다.

## 특징


<b>React 렌더링 원리 </b>핵심 3단계  : Trigger → Render → Commit

1. <b>Trigger : 렌더링 시작</b>
   - 초기 렌더링 :  root.render()등을 통해 처음 <b>컴포넌트 렌더링을 요청한다.</b>
   - 상태 업데이트 : setState를 통해 <b>컴포넌트의 상태가 업데이트 될때.</b>
   - 부모 컴포넌트 렌더링 : 부모가 렌더링되면, 자식도 렌더링에 참여한다.
   - Context 변경 : Context값이 변경되면, 이 Context를 사용하는 컴포넌트도 함께 렌더링된다.
2. <b>Render : 다음 UI를 계산</b>
   <p>
   리액트의 컴포넌트를 실행하여 state, props기반으로 현재 UI를 계산한다.
   </p>

   1. 컴포넌트 함수를 실행하여 <b><span color="red">React Element를 반환 </span></b>
      <p>
      [01. JSX와 React Element](https://app.notion.com/p/6e1ee90a967f82fc9e2e016ceed51b6d) 
      </p>
   2. 이전 렌더링 결과 React Element를 기준으로 새로운 UI구조를 계산
   3. <b><span color="blue">Reconciliation(재조정)과정을 통해 이전 렌더링 결과와 다음 렌더링 결과를 비교한다.</span></b>
   4. 실제 DOM에 반영되어야할 요소가 무엇인지 파악한다.

   <p>
   리액트는 내부적으로 <b>Fiber구조를 활용해 렌더링 작업과 컴포넌트 상태를 관리한다</b>.
   </p>

   <p color="gray_bg">
   <b>❓ Render Phase에서는 실제 화면에 반영된 DOM을 직접 변경하지 않는 이유? </b>

   렌더링 계산이 반복되거나, 중간에 폐기되거나, 수정될 수 있기 때문이다. 확정되지 않은 렌더링 결과가 외부 시스템에 영향을 주게 되면 화면과 상태의 일관성이 깨질수있다. 따라서 렌더 파즈는 외부에 부수효과를 남기지 않는 순수 계산 과정이어야한다.
   </p>
3. <b>Commit </b>: 변경 사항 반영
   <p>
   render phase에서 계산한 변경사항을 바탕으로 실제 dom에 반영한다
   </p>

   <p>
   리액트는 상태 텍스트만 변경이 되었을때, 요소는 유지하고 텍스트만 변경할 수 있습니다. 
   </p>

   <p>
   → 컴포넌트가 렌더링 되었다고, 실제 DOM이 변경되는 것은 아니다. 
   </p>
4. <b>Browser Paint :</b> 브라우저가 변경된 화면을 표시한다.
   <p>
   React의 Commit이후 스타일 계산, Layout, Paint, Composite 등의 과정을 거쳐서 변경된 화면을 표시한다.
   </p>

   <p>
   React의 Render phase와 브라우저의 Rendering은 다른 개념.
   </p>

   - React<b> Render phase : 다음 UI를 계산하는 과정 → DOM에 반영되기 전,</b>
   - Browser<b> Rendering </b>: <b>DOM과 스타일</b>을 바탕으로 실제 화면을 그리는 과정<b> → DOM에 반영된 후.</b>

   <p>
   <b>주의 :</b> DOM 변경이 발생할 때마다, 모든 Layout과 Paint 과정이 반복되는 것은 아니다. 브라우저가 변경작업을 모아서 처리하거나, 일부 단계를 생략할 수 있다.
   </p>

<quote>
<b>Render와 Commit을 분리하는 이유</b>

React는 렌더링 계산과, 실제 DOM 변경의<b><span color="blue"> 책임을 분리한다.</span></b>

- <b>문제 : </b>특히 Concurrent Rendering에서는 우선순위가 낮은 렌더링 작업을 중단하거나 폐기하고 다른 렌더링 작업을 진행할 수 있다. → 만약 Render Phase에서 실제 DOM을 변경한다면, 나중에 폐기되거나 변경될 렌더링 결과가 이미 화면에 반영되는 문제가 발생할 수 있다.
</quote>

<callout icon="✨" color="yellow_bg">
<b>UI 계산(render) ≠ dom에 UI 반영(commit) ≠ dom을 브라우저에 그리기(browser paint)</b>
</callout>


    
    
## 실제 사용 예시(사례)


### 렌더링 결과가 폐기될 수 있는 대표적인 사례 : 12번

<ul>
<li>
아직 계산 중인 렌더링보다 더 우선순위가 높은 업데이트가 발생했을 때
</li>
<li>
검색 결과 목록 

- 사용자가 r을 입력 : 리액트가 우선순위가 낮은 r입력 시작
- 렌더링 도중 re입력 : 새 입력을 처리해야하는 상황
- r 렌더링 결과 폐기 가능 : 이전 작업의 계산 결과를 아직 반영하지 않았기 때문
- re에 맞는 UI 표시 :<b> 새롭게 확정된 결과를 표시 </b>
</li>
</ul>

### <b> Counter 컴포넌트</b>

```javascript
import { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(prev => prev + 1)}>
      Count: {count}
    </button>
  );
}
```

- <b>초기 렌더링 과정</b>
  <p>
  root.render(\<Counter/>) 
  </p>

  <p>
  → Trigger : 초기 렌더링 요청 
  </p>

  <p>
  → Render : Counter 함수 실행 <b>(Render)</b>
  </p>

  <p>
  → state인 count = 0을 기반으로 다음 UI 계산 <b>(Render) </b>
  </p>

  <p>
  → Commit : 실제 buttonDOM 생성 및 연결<b> (Commit)</b>
  </p>

  <p>
  → Browser Paint : “Count : 0 ” 표시<b> (Layout, paint, composite)</b>
  </p>

### 버튼 클릭 후 렌더링 과정

<p>
사용자가 버튼을 클릭해 setState를 통해서 상태를 업데이트 요청을 합니다. 
</p>

<ol>
<li>
버튼 클릭
</li>
<li>
setCount(prev ⇒ prev + 1)
</li>
<li>
React에 상태 업데이트 등록 
</li>
<li>
Render Phase : 컴포넌트를 계산하고 실행한다. 

- Counter 함수 실행
- state였던 count = 1을 기반으로 새 UI 생성
- Reconciliation으로 이전 결과와 비교
- <b>→ button의 텍스트 변경 필요 판단</b>
</li>
<li>
Commit Phase : 렌더 파즈에서 계산한 변경 사항을 반영

- 기존 button DOM 유지 : button DOM을 새로 생성할 필요 없음
- 텍스트 “Count : 0” → “Count : 1” dom에 반영
</li>
<li>
Browser Paint : 변경된 화면 표시
</li>
</ol>

### 4. 실제 프로젝트 경험 — Mogi Logi

Mogi Logi 프로젝트에서 Vanilla JavaScript를 이용해 Virtual DOM을 직접 구현한 경험과 연결할 수 있습니다.

```txt
상태 변경
    ↓
새로운 VNode 트리 생성
    ↓
이전 VNode와 새로운 VNode 비교(Diff)
    ↓
변경 사항 계산
    ↓
실제 DOM에 Patch 적용
```

이 경험을 통해 화면을 계산하는 작업과 실제 DOM에 반영하는 작업이 구분된다는 점을 직접 확인했습니다.

다만 직접 구현한 VDOM의 구조와 React Fiber의 실제 내부 동작은 동일하지 않습니다.

## 보조 개념 정리


<ul>
<li>
JSX : UI를 작성하기 위한 JavaScript 문법 확장. 변환 후 React Element를 생성하는 함수 호출 형태로 실행됩니다.예시 ) jsx(count)
</li>
<li>
React Element : 어떤 UI를 보여줄지 설명하는 JavaScript 객체 → 설계도
</li>
<li>
Virtual DOM : UI구조를 메모리상에서 표현하고 비교하는 개념. 
</li>
<li>
Reconciliation : 이전 렌더링 결과와 다음 렌더링 결과를 비교하여 필요한 변경을 판단하는 과정
</li>
<li>
Fiber : React가 컴포넌트의 상태와 렌더링 작업을 관리하는 내부 자료구조.
</li>
<li>
Update Queue : React가 상태 업데이트를 등록하고 처리하는 내부 구조
</li>
<li>
Batching : 여러 상태 업데이트를 묶어서 불필요한 렌더링을 최소화하는 동작
</li>
<li>
Concurrent Rendering : 렌더링 작업을<b> 우선순위에 따라 </b>중단하거나 다시 시작할 수 있는 동작 방식이다.
</li>
<li>
useEffect : 외부 시스템과의 동기화를 위해 사용하며, <b>커밋 이후에 실행</b>됩니다. 브라우저 Paint와의 선후 관계는 동작에 따라 달라질 수 있다.  
</li>
<li>
리렌더링 : 이미 마운트된 컴포넌트를 다시 렌더링되는 것 
</li>
</ul>

---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

