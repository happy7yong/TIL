# 서버 컴포넌트(RSC)

## 1. 배경과 맥락

> <span color="gray">어떤 이유 때문에 필요 했는가? </span>

- 비로그인 사용자 대상 공개 피드 페이지를 구현해야 했다.
- 해당 페이지는 검색 유입(SEO)이 중요하여 <b>ISR(Incremental Static Regeneration)</b> 전략을 적용하려 했다.
- 동시에 피드 특성상 <b>무한스크롤 로직</b>이 필요했다.
- 무한스크롤은 브라우저 이벤트(IntersectionObserver, scroll 등)에 의존하기 때문에 <b>클라이언트 컴포넌트에서만 실행 가능</b>하다.

그렇다면,

- ISR로 정적 캐싱된 서버 컴포넌트 기반 페이지에 클라이언트 사이드 무한스크롤을 결합하면 실행 흐름과 렌더링 경계는 어떻게 동작하는가?

<b>→ Server Component + Client Component 경계 설계 문제</b>라고 생각했다.

## 2. 기술 키워드

> <span color="gray">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

<ul>
<li>
<b>서버 컴포넌트</b> (React Server Component)

- 서버에서 실행
- 실행 결과 : RSC Payload - React Flight

<toggle>
payload          ///

RSC payload는<b> 서버 클라이언트 데이터 결과와 클라이언트 컴포넌트 참조 위치</b>가 존재.
</toggle>

<toggle>
브라우저로 JS 코드를 전달하지 않음

- 클라이언트의 JS 번들 크기 감소
</toggle>
</li>
<li>
<b>app router 렌더링 </b>모델

<toggle>
렌더링 결과물

- RSC payload (flight 데이터)
- react 트리 : 초기 html (SSR)
</toggle>

<toggle>
<b>동작 원리 :</b> 실행 → 생성 → 렌더 → 로드 → 진행 : 결과

<ul>
<li>
서버에서 <b>서버 컴포넌트(fetch 등) </b>실행
</li>
<li>
jsx 트리, RSC payload 생성
</li>
<li>
브라우저가 받고 html을 렌더
</li>
<li>
client 번들 로드
</li>
<li>
하이드레이션 진행

<b>결과 : 클라이언트 컴포넌트가 브라우저에서 실행</b>
</li>
</ul>
</toggle>
</li>
<li>
<b>서버 컴포넌트와 클라이언트 컴포넌트의 차이</b>

- 서버 컴포넌트 : 서버 실행
  <ul>
  <li>
  JS 번들 포함 X
  </li>
  <li>
  useEffect, useState 상태관리 X
  </li>
  <li>
  이벤트 핸들러 X
  </li>
  <li>
  데이터 fetch O
  </li>
  </ul>
- 클라이언트 컴포넌트 : 브라우저 실행
  <ul>
  <li>
  js 번틀, 상태, 이벤트 핸들러 모두 가능.
  </li>
  </ul>

</li>
</ul>

## 3. 고민했던 내용과 인사이트

- <b>ISR과 CSR이 충돌하는가?</b>
  - ISR은 서버에서 <b>HTML을 생성하고 캐싱</b>하는 전략 → 서버 컴포넌트
  - 무한 스크롤은 클라이언트에서 추가 데이터를 fetch하는 전략 → 클라이언트 컴포넌트
    <p>
    → 즉 둘의 실행 위치가 다르다.
    </p>

  - <b>ISR + CSR(무한 스크롤 이벤트) 동작 흐름</b>
  1. <b>서버 컴포넌트</b>에서 page = 1 데이터를 fetch
  2. <b>ISR 규칙</b>에 따라 HTML 생성 및 캐싱
  3. 클라이언트에서 <b>하이드레이션</b> 수행
  4. 이후 page=2부터 클라이언트에서 fetch
     <p>
     → 즉, 옵저버 추가 데이터는 ISR 캐시와 무관하게 동작
     </p>

- <b>그럼 서버-클라이언트 컴포넌트의 경계를 어떤 기준으로 작성하는 것이 좋은가?</b>
  - 서버에서 실행되는 컴포넌트인 서버 컴포넌트 → SEO에 좋다.
    - SEO에서 보여져야하는 서버 데이터를 서버 컴포넌트로 실행하도록 해야한다.

---
