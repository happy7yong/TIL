# React Portal

<p>
키워드 : 이벤트 위임/버블링/SyntheticEvent
</p>

# 1. React Portal / createPortal

## 정의

<b>Portal은 부모 컴포넌트의 DOM 계층 바깥으로 자식을 렌더링할 수 있게 해주는 React 기능</b>이에요. <code>createPortal(children, domNode)</code> 형태로 호출하면, React 트리상으로는 부모의 자식이지만 실제 DOM에서는 지정한 다른 노드 아래에 그려집니다.

## 특징

- React 트리 구조(컴포넌트 계층)와 DOM 트리 구조(실제 마크업 위치)가 <b>분리</b>됩니다.
- React 트리는 그대로이므로 <b>Context, props 전달, 이벤트 버블링 모두 부모 컴포넌트 기준으로 동작</b>합니다.
- 두 번째 인자는 실제 DOM 노드여야 하므로, <b>SSR 환경에서는 </b><b><code>document</code></b><b> 접근 시점 제어가 필요</b>합니다.

## 사용 상황

1. <b>모달, 토스트, 툴팁, 드롭다운</b> — 부모의 <code>overflow: hidden</code>이나 <code>z-index</code> 스택 컨텍스트에 갇히면 안 되는 UI
2. <b><code>position: fixed</code></b><b>가 부모의 </b><b><code>transform</code></b><b>, </b><b><code>filter</code></b><b>, </b><b><code>will-change</code></b><b> 때문에 viewport 기준이 아닌 부모 기준으로 동작하는 문제 회피</b>
3. 부모 레이아웃에 영향을 주지 않으면서 시각적으로 최상위에 떠야 하는 요소

---

# 2. DOM 트리 vs React 트리

## 정의

- <b>DOM 트리</b>: 브라우저가 실제로 그리는 HTML 노드 계층. 스타일, 레이아웃, 네이티브 이벤트 전파의 기준이 됩니다.
- <b>React 트리</b>: React 컴포넌트의 부모-자식 관계. props 흐름, Context, 합성 이벤트 전파의 기준이 됩니다.

## 평소

일반적으로 두 트리는 <b>거의 동일한 구조</b>예요. <code><Parent><Child /></Parent></code>는 DOM에서도 <code><div><div /></div></code> 같은 형태로 나타나죠.

## Portal 사용 시 분리되는 지점

```javascript
import { createPortal } from 'react-dom';

function App() {
  return (
    <div id="parent">                    {/* React: App > div */}
      <h1>일반 영역</h1>
      {createPortal(
        <div id="child">Portal</div>,    {/* React: App > div의 자식 */}
        document.getElementById('modal-root')  // DOM: #modal-root의 자식
      )}
    </div>
  );
}
```

<b>결과</b>:

<ul>
<li>
<b>React 트리</b>:

```javascript
React 트리
App
└─ div#parent
   ├─ h1
   └─ div#child   ← React상으로는 parent의 자식
```
</li>
<li>
<b>DOM 트리</b>:

- 실제 HTML DOM에는 <code>child</code>가 <code>parent</code> 안에 들어가지 않음.

```javascript
<body>
  <div id="root">
    <div id="parent">
      <h1>일반 영역</h1>
    </div>
  </div>

  <div id="modal-root">
    <div id="child">Portal</div>
  </div>
</body>
```
</li>
</ul>

## 핵심 포인트

- <code>#child</code>는 DOM에서 <code>#modal-root</code> 아래에 위치
- 하지만 <b>이벤트 버블링은 React 트리를 따르므로</b> <code>#child</code>에서 발생한 클릭은 React에선 <code>#parent</code>까지 전파됨
- Context도 React 트리 기준이라 <code>#parent</code>가 <code>Provider</code>를 감싸면 <code>#child</code>에서 <code>useContext</code>로 받을 수 있음
- React는 컴포넌트 트리 관점에서 <code>#child</code>를 여전히 <code>App</code>의 자손으로 관리하지만, 렌더링 시점에 <code>ReactDOM.render</code>가 <code>#modal-root</code>에 직접 자식을 삽입하는 방식이에요.

---

---

---

### 이벤트 버블링

이벤트 버블링(Event Bubbling)은

<b>이벤트가 발생한 요소에서 시작해서 부모 요소 방향으로 이벤트가 전파되는 것</b>

```javascript
<div id="parent">
  <button id="child">클릭</button>
</div>
```

```javascript
parent.addEventListener('click', () => {
  console.log('parent 클릭');
});

child.addEventListener('click', () => {
  console.log('child 클릭');
});
```

<p>
출력 :
</p>

child 클릭

parent 클릭

<b>발생되는 이유</b>

1. 실제 클릭 대상(child)에서 이벤트 발생
2. 부모(parent)로 이벤트 전달
3. 더 상위 부모로 계속 전달

```javascript
body
 └─ parent
     └─ child   ← 여기 클릭
```

---

### Portal과 관계

Portal은 DOM은 분리되지만 React 트리는 유지됨.→ React는 이벤트도 <b>React 트리 기준으로 버블링</b>

```javascript
<div onClick={() => console.log('parent')}>
  {createPortal(
    <button onClick={() => console.log('child')}>
      클릭
    </button>,
    document.getElementById('modal-root')
  )}
</div>
```

<b>리액트에서의 노드 구조</b>

```javascript
App
└─ div(parent)
   └─ button(child)
```

> 실제 DOM 트리

```javascript
<body>
  <div id="root">
    <div>
      <!-- parent div -->
    </div>
  </div>

  <div id="modal-root">
    <button>클릭</button>
  </div>
</body>
```

<p>
실제 dom안에는 #parent 안에 button 없음 → 포탈로 나갔기 때문에
</p>
