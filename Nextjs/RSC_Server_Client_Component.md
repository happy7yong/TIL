# Server Component와 Client Component

| 구분 | 묻는 질문 | 핵심 |
| --- | --- | --- |
| <b>Server Component</b> | 이 컴포넌트 코드는 어디서 실행돼야 해? | <b>서버에서만 실행</b> |
| <b>Client Component</b> | 이 컴포넌트 코드는 어디서 실행돼야 해? | <b>브라우저에서도 실행 필요</b> |
| <b>SSR</b> | 렌더링 결과를 언제/어디서 만들까? | <b>요청 시 서버에서 HTML 생성</b> |
| <b>CSR</b> | 렌더링 결과를 어디서 만들까? | <b>브라우저에서 JS로 UI 렌더링</b> |

## 정의

<b>Server Component</b>

- <b>서버에서만 React 컴포넌트 로직을 실행하는 컴포넌트입니다.</b>
  <p>
  브라우저에서 해당 컴포넌트 코드를 실행할 필요가 없어 클라이언트 JavaScript 번들에 포함되지 않습니다.
  </p>

<b>Client Component</b>

- <b><span color="blue">브라우저에서도 React 컴포넌트 로직을 실행</span></b><b>해야 하는 컴포넌트입니다.</b>
  <p>
  상태, 이벤트 처리, 브라우저 API처럼 브라우저에서 실행되어야 하는 기능이 필요할 때 사용합니다.
  </p>

> HTML을 어디서 만드는지가 아니라, <b>React 컴포넌트 코드가 </b><b><span color="red">브라우저에서도 실행</span></b><b>되어야 하는지</b>로 구분합니다.

---

## 특징

1. <b>Client Component라고 해서 CSR인 것은 아니다</b>
   - Client Component도 최초 페이지 로드에서는 서버에서 HTML로 미리 렌더링될 수 있다.
     <p>
     이후 브라우저가 Client Component의 JavaScript를 다운로드하고 hydration하면서 이벤트 핸들러, 상태 등의 동작을 연결한다.
     </p>

     <toggle color="gray_bg">
     주의

     - Client Component ≠ CSR
     - Server Component ≠ SSR
     </toggle>

     <p>
     Server / Client Component는<span color="red"> </span><b><span color="red">컴포넌트 실행 경계</span></b>이고, SSR / SSG / CSR은 <b><span color="red">렌더링 전략</span></b>
     </p>
2. <b>Server Component</b>는 hydration하지 않는다
   - Server Component의 React 로직은 서버에서 실행되므로 브라우저에서 해당 컴포넌트의 React 코드를 다시 실행할 필요가 없기 때문에 Server Component 자체의 JavaScript를 클라이언트로 보내서 hydration하지 않는다.
     <p>
     반대로 Client Component는 브라우저에서도 React 코드가 실행되어야 하므로 JavaScript가 전달되고 hydration이 필요하다.
     </p>
3. use client는 <b>클라이언트 컴포넌트의 경계</b>를 만든다
   - use client 단순히 <b>이 파일만 클라이언트에서 실행한다</b>라는 의미로 보기보다 <b><span color="red">Server / Client module graph 사이의 경계를 정의하는 진입점</span></b>으로 이해해야한다.
     <p>
     use Client 가 선언된 모듈이 import하는 모듈들은 Client module graph에 포함될 수 있다.
     </p>
4. 클라이언트 컴포넌트는 서버의 초기 렌더링 환경에서도 참여한다?
   - 클라이언트 컴포넌트도 서버에서 처음 렌더링할때, 참여합니다. 리액트의 render phase > commit phase > useEffect 단계에서 렌더파즈단계를 서버에서 실행하고 브라우저로 넘겨주는데,
     - <b>그렇다면, Client Component를 최소화하는 게 중요하다?</b>
       <p>
        필요한 부분에만 <code>use client</code> 경계를 두는 게 좋아. Client Component는 초기 서버 렌더링에도 참여할 수 있지만, 브라우저에서 실행할 JavaScript도 필요하다. 
       </p>

       <p>
       때문에 불필요하게 큰 영역을 Client Component로 만들면 클라이언트 번들과 Hydration 부담이 커질 수 있어. 
       </p>

       > 예시 : <b>useClient로 명시한 모듈에 fetch가 본문에 있다면, </b>서버에서도 코드가 실행되고, 클라이언트에서도 코드가 실행된다. <br />→ 즉, 클라이언트 컴포넌트가 서버에서도 실행가능한 코드면 코드가 실행되고, 브라우저에서는 반드시 실행된다.

<p>
4\. React Tree와 Module Graph는 다르다

<ul>
<li color="gray_bg">
<b>처음 헷갈렸던 부분</b>

```ts
<AppShell> //client Component
  <Page /> //serverComponent 
</AppShell>
```

에서 AppShell이 Client Component라면 그 아래의 Page도 무조건 Client Component라고 생각했다.
</li>
<li>
React의 컴포넌트 트리에서 자식으로 존재하는 것과 Client Component가 해당 모듈을 직접 import하는 것은 다른 문제다.

즉, <b>리액트 트리와 모듈 그래프</b>는 다르다.

```ts
// 어떤 Server Component

import AppShell from './AppShell' // Client
import Page from './Page'         // Server

export default function ServerParent() {
  return (
    <AppShell>
      <Page />
    </AppShell>
  )
}
```

라는 컴포넌트가 있으면, page의 임포트를 서버컴포넌트에서 하고 있기 때문에 서버에서 page를 렌더링합니다. 클라이언트 자식에 children으로 받고 있어도, <b>어디서 임포트 하냐가 중요</b>

- 리액트 트리
  ```ts
  ServerParent
     ↓
  AppShell (Client)
     ↓
  Page (Server)
  ```
- 모듈 그래프
  ```ts
  ServerParent (Server)
   ├─ import → AppShell (Client)
   └─ import → Page     (Server)
  ```
</li>
</ul>
</p>

---

## 실제 사용 예시(사례)

- <b>MOLIP 공개 피드 페이지</b>
  <p>
  비로그인 사용자가 접근하는 공개 피드 페이지는 검색 유입이 중요해서 <b>정적 렌더링/ISR</b>을 활용하고 싶었다.
  </p>

  <p>
  하지만 피드에는 무한스크롤이 필요했고, <b>무한스크롤에서는 IntersectionObserver와 같은 브라우저 API</b>를 사용해야 했다. → 즉 클라이언트 컴포넌트가 필요했따
  </p>

  <toggle color="gray_bg">
  왜 클라이언트 컴포넌트가 필요하냐?

  <p>
  브라우저에서 실행가능한 코드가 있어야하기 때문. 
  </p>
  </toggle>

  <p>
  페이지 전체를 Client Component로 만들 필요가 없다! 
  </p>

  ```txt
  Server Component
  ├── 서버에서 처리할 데이터/정적 영역
  └── Client Component
      └── IntersectionObserver를 사용하는 무한스크롤 영역
  ```

  - <b>브라우저에서 React 코드가 </b><b><span color="red">실제로 실행되어야 하는 영역만 Client Component 경계로 분리할 수 있다. \<\< 바람직한 클라이언트 컴포넌트 분리</span></b>
- 클라이언트 컴포넌트고 서버 초기 렌더링에 참여한다고 했는데 클라이언트 컴포넌트는 서버에서도 실행되고 브라우저에서도 실행되는건가?

---

## 보조 개념 정리

<ul>
<li>
CSR : 브라우저에서 JavaScript를 실행하여 UI를 렌더링하는 방식.
</li>
<li>
SSR : 사용자의 요청 시점에 서버에서 렌더링 결과를 만들어 응답하는 렌더링 전략.
</li>
<li>
SSG / Static Rendering : 빌드 시점에 렌더링 결과를 미리 만들어두고 이후 요청 때 정적으로 제공하는 렌더링 전략 → 서버컴포넌트도 정적 렌더링 가능
</li>
<li>
Hydration : 서버에서 미리 만들어진 html에 클라이언트 컴포넌트의 JS 로직을 연결해서 브라우저에서 상호작용 가능한 ui를 만드는 과정
</li>
<li>
RSC Payload : 서버 컴포넌트의 렌더링 결과를 클라이언트에 전달하기 위해 react가 사용하는 데이터 표현

- 클라이언트로 넘어갔을때 위치를 잃지 않도록 주소같은 역할을 한다고 함. → 자세하게 어떻게 표현되어있는지는 모르겠음 상상으론 한국 번지수 정도로 생각하기
</li>
<li>
클라이언트로 넘어갔을때 위치를 잃지 않도록 주소같은 역할을 한다고 함. → 자세하게 어떻게 표현되어있는지는 모르겠음 상상으론 한국 번지수 정도로 생각하기
</li>
<li>
Module : import / export로 서로 연결되는 코드 단위.

- 하나의 모듈안에 컴포넌트, 함수, 상수 등이 함께 존재 가능
</li>
<li>
하나의 모듈안에 컴포넌트, 함수, 상수 등이 함께 존재 가능
</li>
<li>
Module Graph : 각 모듈이 어떤 모듈을 임포트 하고 있는지 연결하는 그래프 
</li>
</ul>

---

## 회고

1. SSR == server Component? CSR == client Component
   <p>
   SSR을 공부하면서 ServerComponent를 많이 접했고 CSR를 공부하면서 Client Component를 접했기 때문에, 서버컴포넌트와 SSR의 개념이 헷갈렸다. 처음 html을 서버에서 렌더링하는 것이 ServerComponent의 역할이고 브라우저에서 렌더링하도록 하는것이 Client Component의 역할이라고 생각했다. 그래서 너무나 자연스럽게 SC = SSR , CC = CSR
   </p>

   <p>
   그러나,
   </p>

   <p>
   <b><span color="red">렌더링 전략 (SSR/CSR)과 컴포넌트 실행 경계는 다른 축</span></b>이다.
   </p>

   <quote>
   <b>SSR / SSG / CSR</b>

   <b>→ UI를 언제, 어디에서 렌더링하는가? </b><br />이게 그 헷갈렸던 어디서 화면을 렌더링하는가에 대한 질문과 관련된
   </quote>

   <quote>
   <b>Server / Client Component</b>

   → 이 React 컴포넌트의 코드가 어디에서 실행되어야 하는가?<br /><b>클라이언트 컴포넌트도, 초기 html은 서버에서 미리 렌더링될 수 있다. 그렇기 때문에 SC CC의 구분점은 브라우저에서 실행되어야하는 코드인가?</b>
   </quote>

SSR을 공부하면서 ServerComponent를 많이 접했고 CSR를 공부하면서 Client Component를 접했기 때문에, 서버컴포넌트와 SSR의 개념이 헷갈렸다. 처음 html을 서버에서 렌더링하는 것이 ServerComponent의 역할이고 브라우저에서 렌더링하도록 하는것이 Client Component의 역할이라고 생각했다. 그래서 너무나 자연스럽게 SC = SSR , CC = CSR

그러나,

<b><span color="red">렌더링 전략 (SSR/CSR)과 컴포넌트 실행 경계는 다른 축</span></b>이다.

<quote>
<b>SSR / SSG / CSR</b>

<b>→ UI를 언제, 어디에서 렌더링하는가? </b><br />이게 그 헷갈렸던 어디서 화면을 렌더링하는가에 대한 질문과 관련된
</quote>

<b>→ UI를 언제, 어디에서 렌더링하는가? </b><br />이게 그 헷갈렸던 어디서 화면을 렌더링하는가에 대한 질문과 관련된

<quote>
<b>Server / Client Component</b>

→ 이 React 컴포넌트의 코드가 어디에서 실행되어야 하는가?<br /><b>클라이언트 컴포넌트도, 초기 html은 서버에서 미리 렌더링될 수 있다. 그렇기 때문에 SC CC의 구분점은 브라우저에서 실행되어야하는 코드인가?</b>
</quote>

→ 이 React 컴포넌트의 코드가 어디에서 실행되어야 하는가?<br /><b>클라이언트 컴포넌트도, 초기 html은 서버에서 미리 렌더링될 수 있다. 그렇기 때문에 SC CC의 구분점은 브라우저에서 실행되어야하는 코드인가?</b>

1. <b>Component Tree와 Module Graph를 섞어서 생각함</b>
   <p>
   화면상 <b>Client Component </b>아래에 있다고 해서 모든 자식이 자동으로 Client Component가 되는 것은 아니다.
   </p>

   <p>
   children으로 전달된 <b>Server Component</b>와 <b>Client Component</b>가 직접 import한 module을 구분할 필요가 있다.
   </p>

   <p>
   → 누가 임포트 했냐? SC냐 CC냐가 중요하다.
   </p>

화면상 <b>Client Component </b>아래에 있다고 해서 모든 자식이 자동으로 Client Component가 되는 것은 아니다.

children으로 전달된 <b>Server Component</b>와 <b>Client Component</b>가 직접 import한 module을 구분할 필요가 있다.

→ 누가 임포트 했냐? SC냐 CC냐가 중요하다.

---

## 궁금한 내용

- RSC Payload에는 정확히 어떤 정보가 들어가는가?
- Client Component가 서버에서 초기 HTML로 렌더링되는 과정과 Server Component 실행 과정은 어떻게 다른가?
- 'use client' 아래의 module graph는 실제 번들링 과정에서 어디까지 Client Bundle에 포함되는가?
- Server Component에서 Client Component로 props를 넘길 때 왜 직렬화 가능한 값이어야 하는가?
- App Router에서 Static Rendering / Dynamic Rendering과 기존 SSR / SSG 개념은 정확히 어떻게 대응되는가
- 컴포넌트 트리와 모듈 크래프의 관계, 어떻게 다른가? 어째서 다른가?

---

