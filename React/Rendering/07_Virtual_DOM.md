# Virtual DOM

### VDOM이 뭔가요?

<b>VDOM은 </b><b><span color="red">객체 형태로 표현한 DOM 구조</span></b>

```javascript
function h(type, props, ...children) {
  return { type, props: props || {}, children: children.flat() };
}
//실제로도 객체 형태로 가지고 있음.
```

### 면접 한줄

가상 DOM은 실제 DOM과 별개로 메모리에 유지되는 가벼운 JS 객체 트리로, 상태 변화가 일어나면 먼저 이 메모리 구조를 업데이트한 뒤 old/new VDOM을 diff하여 실제 DOM에는 최소한의 변경만 반영합니다.

### “왜 가상 DOM을 쓰나요?”

<quote>
실제 DOM은 변경될 때마다 스타일 계산, 레이아웃(Reflow), 페인트(Repaint)이 발생해 비용이 큽니다.

가상 DOM은 상태 변화로 인한 UI 변화를 메모리 상에서 빠르게 계산한 뒤,

old/new VDOM을 diff해서 <b><span color="red">실제로 필요한 변경만 최소한으로</span></b> 실제 DOM에 반영합니다.

그 결과, 브라우저 렌더링 비용이 줄어들어 성능이 향상됩니다.
</quote>

<toggle color="gray_bg">
<b>면접용 핵심 키워드</b>

- 실제 DOM 변경 비용: Reflow/Repaint → 고비용
- VDOM: DOM의 추상화된 메모리 모델
- diffing: old/new VDOM 비교
- minimal patch: 필요한 DOM 변경만 수행
- batching + commit: DOM 업데이트 최소 횟수
- 목적: 성능 최적화 + 선언적 UI 유지
</toggle>

### 키워드

<ul>
<li>
재조정(Reconciliation)
</li>
<li>
react Fiber
</li>
<li>
RenderTree
</li>
<li>
layout : reflow
</li>
<li>
paint : repaint
</li>
<li>
batch
</li>
<li>
Patch
</li>
</ul>

### 참고 자료 : 이정환의 React

### 화면업데이트가 빠르다는 리액트의 특징

### 브라우저의 렌더링 과정

<p>
CRP  브라우저의 렌더링 과정 : Critical Rendering Path
</p>

<image source="notion-file-block://3cfee90a-967f-80b5-a98b-e812e82b9aa2/d8d6ab79-3e8f-4c40-ac5b-21f5941e086a?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

→ DOM을 10번 수정한다는 것은. 브라우저가 화면을 다시 그리는 과정 (리페인트와 리플로우가 10번 진행된다.)

---

1. <b>HTML / CSS 코드를 각각 DOM으로 변환한다.</b>

HTML → DOM 으로 변환한다.

<image source="notion-file-block://3cfee90a-967f-80e2-98f7-eecf0aed2ee1/3952940e-0999-4262-b7ee-7f46d9825b13?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

문서 객체 모델

컴퓨터가 이해하기 쉬운 모델로 바꿈.

---

2. RenderTree

<p>
웹페이지의 청사진
</p>

DOM 과 CSSOM 각 요소들의 특징이 담긴 모든 정보를 Render Tree로 만듬.

---

<ol start="3">
<li>
Layout
</li>
</ol>

요소의 배치 잡기

→ 요소를 다시 잡는 것을 <b>리플로우</b>

---

4. Painting

<p>
실제로 화면에 그려내는 과정
</p>

→ 화면을 다시 그리는 것을 <b>리페인팅</b>

---

### 업데이트는 어캐 ?

<p>
js가 DOM을 수정되면 업데이트 발생
</p>

업데이트될 때 JS에 따라 DOM이 수정되고 DOM이 수정되면 렌더 트리를 다시 계산한다.

그렇게 되면 그 후의 레이아웃과 페인팅 단계가 다시 수행된다.

<video source="https://youtu.be/ZTnIxIA5KGw" />

<p>
이 과정에서, 가장 성능이 안좋은 단계가 이 두곳
</p>

<image source="notion-file-block://3cfee90a-967f-8035-aa39-f74de8bd785b/bdb7b005-d1a3-43c3-af52-9be809fc87d2?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

→ 때문에 만약 JS가 3000번 진행된다면 리플로우와 리페인트가 성능을 악화시킬것 → DOM 수정이 3000번 된거임

→ DOM을 10번 수정한다는 것은. 브라우저가 화면을 다시 그리는 과정 (리페인트와 리플로우가 10번 진행된다.)

### <b>JavaScript가 DOM을 10번 수정하면, 브라우저의 렌더링 단계(Layout / Paint)가 10번 발생할 수 있음.</b>

### 브라우저 렌더링 흐름:

1. <b>Style 계산 (Recalculate Style)</b>
2. <b>Layout (Reflow)</b>
3. <b>Paint (Repaint)</b>
4. <b>Composite (합성)</b>

DOM 변경 1번 → 최소 Style + Paint는 발생

Layout이 필요하면 Reflow까지 발생

DOM 변경이 10번 → 이 과정이 <b>최대 10번 발생할 수도 있음</b>

---

## <b>Re-render(리렌더링)</b>

<b>리렌더링에 대한 오해 </b>

- <b>프레임워크(React, Vue 등)나 가상 DOM이 사용된 시스템에서의 개념</b>
- 컴포넌트 상태 → 새로운 UI 트리 계산 → 변경된 부분만 실제 DOM에 반영(differences patch)

즉, 브라우저 단계가 아니라 <b>프레임워크 관점의 UI 재계산 작업</b>을 의미함.

<p>
리플로우와 리페인트는 렌더링의 일부이다.
</p>

## 리플로우와 리페인트

1. DOM에 즉각적으로 수정할 경우

<image source="notion-file-block://3cfee90a-967f-80f8-baba-e17a89477028/f801a58b-5e89-462d-a626-a8e5229826df?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<p>
→ 1번에서 Real DOM을 즉각적으로 수정할 경우에는 너무 많은 비용이 들기 때문에, 개선한 방향 :
</p>

- 다른 변수안에 누적으로 저장시키고<b> DOM은 한번만 수정할 것</b>

<image source="notion-file-block://3cfee90a-967f-80c5-9f8a-d5329e10303c/3c5644ad-ac15-4c0f-bf0a-a8c468972673?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

---

## VDOM의 철학 : 무거운 DOM은 최소한으로 수정하자.

<image source="notion-file-block://3cfee90a-967f-80af-a768-eb8d73f53869/86d90b29-80f2-4334-b769-cf365226e816?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

일일히 개발자가 구현해야했는데(vanilaJS처럼) 리액트가 자동으로 처리해줌

이 기능이 <b>virtual DOM 덕분임 </b>

## Virtual DOM

- React는 업데이트가 발생 시 <b>실제 DOM을 수</b>정하기 전에 <b>가상의 복제판 DOM</b>에 먼저 반영됨.

1. 가상의 돔은 실제돔을 복제한 것.
2. 기존 : JQuery 방식일 때, 업데이트 발생 시 모든 <b>실제 DOM을 수정했었지만, </b>
3. <b>변경 : 필요한 부분(실제 화면 상 바뀐 부분만) 가상돔의 등장으로 가상 돔에 먼저 반영한다. </b>

<p>
기존에는 2번의 변화가 일어났다면 실제 DOM은 2번 업데이트해야하지만 가상 돔 덕분에 여러번의 변화가 일어나도 최소한의 변화로 업데이트를 진행한다.
</p>

- <b>가상돔은 메모리에 존재하는 UI 상태의 JS 객체 트리이다.</b>

<b>→</b><b><span color="red"> 실제 돔의 가벼운 스냅샷(가상돔)</span></b>을 메모리(객체트리)에 저장해두고<b> </b><b><span color="red">UI 변화를 메모리에 있는 가상돔</span></b><b>에서 먼저 계산하는 것</b>

React 공식 문서 표현: <b>“An in-memory representation of the UI”</b>(메모리에서 존재하는 UI 표현)

<callout color="gray_bg">
→ 왜 메모리에 두는거지?

<ul>
<li>
실제 DOM은 브라우저 엔진 내부 구조물이기 때문에 접근이 무겁고 느리다 → 비용이 크다.
</li>
<li>
JS 객체는 메모리에 있는 단순 객체이기 때문에 빠르다.
</li>
</ul>
</callout>

<h3>
구조
</h3>

<callout color="brown_bg">
<b>\[ Render Phase\]</b>

<b>Old Fiber Tree<br />New Fiber Tree 생성 (컴포넌트 실행하여 그림 Tree)</b><br />↓<br />Reconciliation (diff)<br />↓<br />Effect List 생성 (변경사항 기록)
</callout>

<callout color="yellow_bg">
<b>\[Commit Phase\]</b><br /><br />Effect List 기반으로<br />→ 실제 DOM 업데이트
</callout>

### VDOM의 특징

1. Virtual DOM은 실제 DOM을 가벼운 JS 객체로 추상화한 UI 트리 구조
2. React는 상태 변경이 일어나면 먼저<b> Virtual DOM을 갱신하여 변화된 UI 상태를 계산한다.</b>

- React는 상태 업데이트를 <b>batch 처리 </b>(React 18 concurrent mode)
- 하지만 최종 commit을 여러 번 할 수도 있음 (async rendering)

<callout color="yellow_bg">
<b>기존 바닐라JS는 부분 업데이트가 안되는 걸까?</b>

가능하다

```py
document.getElementById("count").textContent = 10;
```

→ 해당 노드만 변경됨.

---

<b>기존 문제</b>

1. <b>불필요한 렌더링 발생</b>
   ```py
   element.style.width = "100px";
   element.style.height = "200px";
   ```

   <p>
   실행하게 되면 layout → layout → layout
   </p>
2. <b>개발자가 계산에 대한 최적화를 해야함.</b>
   <p>
   최소 변경을 보장할 수 있도록 직접 계산해야함.
   </p>

   ```py
   if (countChanged) {
     // 직접 찾고
     // 직접 바꾸고
   }
   ```
</callout>

### 요약

(1) 상태 업데이트 발생<br />(2) 새로운 <b>Virtual DOM </b>생성<br />(3) 이전 Virtual DOM(old VDOM)과 새 Virtual DOM(new VDOM)을 비교(diff)<br />(4) 차이가 나는 부분만 실제 DOM에 반영(Patch)

---

<h2>
React Fiber
</h2>

새로운 렌더링 엔진 알고리즘

<b>재조정 알고리즘의 구현체 </b>

기존 : Virtual DOM 계산이 느리면 diff 하나 계산할 동안 메인 스레드를 점윻는 등 UI 렉이 발생했었음.

그 느린걸 어떻게 개선하지? → <b>작업을 작은 단위로 쪼개자</b>

<callout color="brown_bg">
작업을 쪼개다

<p>
→ 한번에 모든 계산을 하지 않고 (기존 X) 스레드의 상황을 확인하며 작은 작업이 끝나면 잠깐 멈춤
</p>

<p>
→ 멈춘 사이에 스레드 블락이 풀림
</p>
</callout>

VDOM 트리의 각 노드를 작은 작업 단위 Fiber Node로 만든다.

### old/new Vdom diff

fiber : vdom 트리를 fiber 트리로 구성하고 old new 트리를 비교해서 변경점을 찾는다.

<b>이전 React </b>

```css
[전체 VDOM 트리] → 한번에 diff → 한번에 DOM 업데이트
```

<b>React Fiber </b>

<ul>
<li>
작업 단위를 쪼개고 우선순위를 적용함.
</li>
</ul>

```css
Fiber Node 단위로 잘게 쪼갬
  ↓
낮은 우선순위: 잠시 멈춤(Pause)
높은 우선순위: 먼저 실행
  ↓
최종 commit 때 DOM 업데이트
```

---

<callout icon="💡">
state 가 변경되면-> new VDOM이 생성되고, DIFF로<b> old VDOM을 변경 </b>-> Real DOM을 Patch
</callout>

❗ “DIFF로 old VDOM을 변경”은 아니라

✔ “DIFF로 oldVDOM과 newVDOM<b><span color="yellow_bg"> 차이를 계산 </span></b>→ <b><span color="yellow_bg">Real DOM에 patch 적용”</span></b>
