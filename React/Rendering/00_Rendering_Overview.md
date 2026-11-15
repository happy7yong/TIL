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

## 면접CS질문

<callout icon="💡" color="gray_bg">
<p>
면접 답변은 외우지 않기! 글은 뜻을 전하기 위한 수단이다. 답변을 외우는것이 목적이 되어서는 안된다. 답변을 이해하고 상황에 따라 나만의 답변을 만들자 
</p>
</callout>

1. <b>React란? </b>
   <toggle>
   답변

   React는 사용자 인터페이스를 쉽게 만들 수 있도록 돕는 JavaScript 라이브러리입니다.<br />React는 컴포넌트 단위로 UI를 구성하고 재사용할 수 있으며, 상태에 따라 화면이 어떤 모습이어야 하는지 선언적으로 작성할 수 있습니다.

      </toggle>

   <p>
   리액트 : 사용자 인터페이스를 쉽게 만들수있음 → JavaScript 라이브러리
   </p>

   - <b>컴포넌트 기반</b> → ui 구성: <b>재사용</b>
   - 상태에 따라 화면 구성 → <b>선언적 UI</b> : 상태에 따라 UI <b>선언</b>적 작성
2. 선언적 UI란?
   - 절차 작성 X
   - 현재 상태에서는 화면이 어떻게 보여야하는지 작성하는 방식
3. React에서 컴포넌트란?
   <toggle>
   답변

   컴포넌트는 UI를 구성하는 단위입니다. 일반적으로 함수 형태로 작성하며, JSX를 반환하면 React가 이를 바탕으로 화면을 렌더링합니다. 또한 컴포넌트를 재사용할 수 있습니다.

      </toggle>

   - 개념 : UI를 구성하는 단위
   - 구현 :
     - 함수 형태
     - JSX 반환 → 리액트가 이 결과를 화면에 렌더링
     - 재사용
4. Virtual DOM이란 무엇인가요?
   <toggle>
   답변

   UI 구조를 메모리상의 객체 트리로 표현한 것입니다. <br />React는 이전과 새로운 렌더링 결과를 비교해 실제 화면에 필요한 변경을 결정합니다.
   </toggle>
5. State와 Props의 차이는 무엇인가요?
   <toggle>
   답변

   Props는 부모 컴포넌트가 자식에게 전달하는 값이고, State는 컴포넌트가 기억하고 관리하는 값입니다. State가 바뀌면 React가 화면 갱신을 위해 다시 렌더링할 수 있습니다.
   </toggle>
6. React에서 상태가 바뀌면 화면은 어떻게 갱신되나요?
   <toggle>
   답변 

   상태가 바뀌면 React가 컴포넌트를 다시 렌더링해 새로운 UI를 계산합니다. 이전 결과와 비교한 다음 필요한 변경을 실제 DOM에 반영합니다.
   </toggle>
7. React의 Render 단계와 Commit 단계는 어떻게 다른가요?
   <toggle>
   답변

   Render 단계에서는 UI가 어떻게 바뀌어야 할지 계산합니다. Commit 단계에서는 실제 DOM에 필요한 변경을 반영합니다.
   </toggle>
8. React 렌더링은 어떻게 되나요?
   <toggle color="gray_bg">
   답변

   리액트는 렌더링이 요청되면, 렌더단계에서 컴포넌트를 실행합니다. <b>컴포넌트 함수에서 반환한 react Element</b>로 다음 UI를 계산하고, 이전 렌더링 결과와 현재 렌더링 결과를 비교하여 변경사항을 판단합니다. 이후 커밋 파즈에서는 계산된 변경사항을 실제 DOM에 반영하는 작업을 진행합니다.

   <quote>
   <b>정리 </b>

   <ol>
   <li>
   렌더 단계 : 컴포넌트 실행 / reactElement로 UI 계산 / 이전 렌더링결과와 다음 렌더링 결과를 비교 
   </li>
   <li>
   커밋 단계 : 실제 DOM에 반영하는 작업
   </li>
   </ol>
   </quote>
   </toggle>
9. React 컴포넌트는 언제 리렌더링 되나요?
   <toggle color="gray_bg">
   답변

   - 컴포넌트의 State가 업데이트될 때
   - 부모 컴포넌트가 리렌더링될 때
   - 컴포넌트가 구독하는 Context 값이 변경될 때
   </toggle>
10. React의 Render 단계와 Commit 단계는 어떻게 다른가요?
    <toggle color="gray_bg">
    답변

    - 각 단계의 특징을 짧게말하고 비교해라

    렌더 단계에서는 컴포넌트 함수를 실행하고 UI를 계산합니다. 이전 렌더링 결과와 비교해 변경사항을 판단합니다. 커밋 단계에서는 계산된 변경사항을 실제 DOM에 반영하는 작업을 진행합니다.
    </toggle>
11. <b>(케빈 면접CS) </b>왜 Render 단계에서는 실제 DOM을 직접 변경하면 안되나요?
    <toggle color="gray_bg">
    답변

    <p>
    리액트는 렌더링 도중 <b><span color="red">더 높은 우선순위</span></b>의 업데이트가 발생하면 기존에 렌더링 되어야할 결과를 폐기할 수 있습니다. 
    </p>

    <p>
    <b><span color="red">확정되지 않은</span></b> 렌더링 결과를 실제 DOM에 반영되면 <b><span color="red">UI의 일관성</span></b>이 깨질수있기 때문에 리액트에서는 커밋과 렌더 단계를 분리합니다. 
    </p>
    </toggle>
12. 컴포넌트가 실행되면 실제 DOM도 반드시 변경되나요?
    <toggle color="gray_bg">
    답변

    컴포넌트가 리렌더링 될 때 실제 DOM은 필요하지 않은경우에 변경되지 않습니다. 예를들어 버튼의 값이 달라지고, 태그 버튼의 컴포넌트가 실행되었어도, 실제 DOM은 변경되지 않았다면 실제 DOM에는 변경될 부분이 없을 수 있습니다.

    - <b>컴포넌트의 state가 A에서 B로 변경되어 컴포넌트 함수는 다시 실행됐지만, 화면의 버튼은 전혀 바뀌지 않는 상황을 하나 들어주세요.</b>
      <p>
      count값이 0에서 1로 변경되었을때, count라는 텍스트는 바뀔수있겠지만 상태를 변경시킨 버튼은 렌더링 요소가 변경되지 않습니다. 따라서 해당 버튼은 컴포넌트는 실행되었지만 실제 DOM에 반영되지 않습니다.
      </p>
    </toggle>
13. React는 상태가 변경되면 어떤 부분을 실제 DOM에 반영할지 어떻게 판단하나요?
    <toggle color="gray_bg">
    답변

    리액트는 요소의 타입과 key를 기준으로 변경합니다. 예를 들어 같은 타입인 버튼이 텍스트만 달라졌을 경우에는, DOM의 노드를 재사용하여 텍스트만 dom에 반영합니다. 하지만 기존 버튼이 div로 변경되어야할 경우에는 다른 타입이기 때문에 재사용할수없으며 새로운 노드를 생성하여 사용합니다.
    </toggle>

    
    
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

