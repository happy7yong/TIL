# use client에 대한 오해

## 배경

VideoCard 컴포넌트의 부모 컴포넌트가 use client, 클라이언트 컴포넌트라는 가정에서 시작되었습니다.

```javascript
"use client";

import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";

dayjs.extend(relativeTime);

export function VideoCard({ video }) {
  return (
    <div>
      <h3>{video.title}</h3>
      <p>업로더: {video.uploader}</p>
      <span>{dayjs(video.uploadedAt).fromNow()}</span>
    </div>
  );
}
```

<p>
“use client”라는 예약어가 파일 안에 선언되어있다면 CSR 즉, 클라이언트에게 html을 그릴 수 있는 책임을 넘겨준다는 뜻인줄알았다. 하지만 use client가 있어도 서버에서 실행이 된다는 것을 언젠가의 프론트 소모임의 발표에서 들은 바가 있었고, SSR을 위한 코드를 작성하였는데, use client가 필요한 것을 보고 서버 컴포넌트와 클라이언트 컴포넌트의 경계를 잘못 설계했나, 라고 생각했는데 그것은 아니었다.
</p>

### 서버와 클라이언트

<b>"Server"와 "Client"단어가 서로 다른 두 차원에서 사용됨.</b>

<b>차원 A: 컴포넌트의 종류 (</b><b><span color="red">어디서 코드가 실행</span></b><b>될 수 있는가)</b>

- Server Component: 서버에서<b>만</b> 실행
- Client Component: 서버에서도, 클라이언트에서도 실행

<b>차원 B: 렌더링이 일어나는 장소 (특정 시점에 </b><b><span color="red">어디서</span></b><b> </b><b><span color="red">HTML/UI가 만들어지는가</span></b><b>)</b>

- SSR (Server-Side Rendering): 초기 HTML을 서버에서 만든다
- CSR (Client-Side Rendering): 초기 HTML은 비어있고, 브라우저에서 JS 실행해서 만든다

<p>
use client는 A이다. → 클라이언트에서도 실행할 수 있도록 하라. 라는 의미이다.
</p>

1. <b>Server Component는 서버에서만 실행된다.</b>
   <p>
   → 서버 컴포넌트는 서버에서<b><span color="red">만</span></b> 실행되기 때문에 <b>JS 번들에 포함되지 않는다.</b>
   </p>

   - 실행 결과 : RSC Payload - React Flight
     - payload : RSC payload는<b> 서버 클라이언트 데이터 결과와 클라이언트 컴포넌트 참조 위치</b>가 존재.
2. <b>Client Component도 서버에서 한 번 실행된다 (SSR), 그리고 클라이언트에서 또 한 번 실행된다 (Hydration).</b>
   <p>
   → 서버에서도 실행되고, 클라이언트에서도 실행된다.<b> : 그럼 2번 실행되는 것인가? 맞다.</b>
   </p>

   <callout icon="📌" color="green_bg">
   그럼 클라이언트 컴포넌트는 2번 실행되는 것인가? 두번 실행되는 것이 맞다.

   1. <b>서버에서 한번(SSR) </b>: <code>app/(default)/page.tsx</code>가 렌더링될 때, 그 안의 <code><Page />(컴포넌트)</code>도 함께 서버에서 호출됩니다. React가 이 컴포넌트를 실행해서 HTML 문자열을 만듭니다
   2. <b>클라이언트에서 한번(Hydration)</b> : 브라우저가 HTML을 받고 JS 번들이 로드되면, React가 같은 <code>Page</code>를 클라이언트에서 다시 실행해서 가상 DOM을 만들고, 이미 그려진 실제 DOM과 매칭합니다.
   </callout>
3. <b><code>use client</code></b><b>는</b><b><span color="blue"> "여기서부터 클라이언트 번들에 포함시켜라"</span></b><b>라는 경계 표시일 뿐, "서버에서 실행하지 마라"가 아니다.</b>

- <b>CSR(Client-Side Rendering)은 App Router 기본 모드가 아니다. Client Component를 쓴다고 자동으로 CSR이 되는 게 아니다.</b>

> <b>NextJS의 app router에서 동작</b>

<ul>
<li>
<b>app router 렌더링 </b>모델

- 렌더링 결과물
  - RSC payload (flight 데이터)
  - react 트리 : 초기 html (SSR)
- <b>동작 원리 :</b> 실행 → 생성 → 렌더 → 로드 → 진행 : 결과
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
</li>
</ul>

> <b>요약</b>

- <b>RSC와 Client Component는 SSR 관점에서 무엇이 다른가?</b>
  - RSC: 서버에서 실행한 결과(트리)만 직렬화해서 보냄. 코드는 안 감.
  - Client Component: 서버에서 HTML 만들고, 코드도 클라이언트 번들에 포함시켜서 같이 보냄. 클라이언트가 받아서 재실행(hydration)함.
    |  | Server Component (RSC) | Client Component |
    | --- | --- | --- |
    | 서버에서 실행 | ✅ | ✅ (SSR 단계) |
    | 클라이언트에서 실행 | ❌ | ✅ (Hydration 단계) |
    | 클라이언트 번들에 코드 포함 | ❌ (0 byte) | ✅ |
    | <code>useState</code>, <code>useEffect</code>, 이벤트 핸들러 | ❌ | ✅ |
    | Hydration 대상 | ❌ | ✅ |
    | 직렬화 형태 | RSC payload | HTML + props 직렬화 |
- <b>서버와 클라이언트의 책임 분리</b>
  <p>
  서버와 클라이언트가 같은 컴포넌트 함수를 실행하지만, <b>목적이 다르다.</b>
  </p>

  |  | 서버 실행 | 클라이언트 실행 (Hydration) |
  | --- | --- | --- |
  | 목적 | HTML 문자열 생성 | DOM에 이벤트 핸들러 부착 + 가상 DOM 메모리 구성 |
  | 결과물 | HTML | React 내부 상태 (Fiber 트리) |
  | <code>useEffect</code> | 실행 안 됨 | 실행됨 |
  | 이벤트 핸들러 | 없음 (HTML엔 못 담음) | 부착됨 |

  ---

### 발생할 수 있는 문제점

1. <b>use client가 있을경우 서버에서 한번, 클라이언트에서 한번 실행되면 안전이 보장되고 어차피 SSR이 되는 것 아닌가? 무슨 문제가 있을까?</b>
   <p>
   불필요한 코드 까지 클라이언트<b> JS 번들</b>에 합쳐서 보내질 수 있다. 클라이언트 입장에서는 이미 한번 서버에서 실행된 코드인데다가 서버에서 실행이 되어도 번들 코드가 받은 html에 이미 그려져있으면, 일을 두번한 샘.
   </p>

   <p>
   <b>JS 번들</b>이 커지면 JS코드는 실행 컨텍스트에 올라가서 평가와 실행단계가 길어지고 이게 곧 TBT를 유발한다.
   </p>

   <p>
   해당 이미지서 스크립트 82ms가 뜻하는 것이 바로 위에서 말한 평가/실행단계이다.
   </p>

   <image source="notion-file-block://3cfee90a-967f-802c-99f7-f4562b58c019/403738b2-6d45-4cb7-aa46-af911662d06f?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

   <p>
   해당 부분이 길어지면 TBT가 증가하고 하이드레이션이 늦어질수있다.
   </p>

   <p>
   → 최적화 방법 : RSC 경계 분리, 번들사이즈 줄이거나, 지연로딩
   </p>

---

```javascript
[서버]
  RSC 실행
    ↓
  Client Component를 만나면 → 함께 SSR (HTML 생성)
    ↓
  HTML + RSC payload + dehydrated state 직렬화
    ↓
[네트워크]
    ↓
[브라우저]
  HTML 페인트 ← LCP 발생 지점
    ↓
  JS 번들 다운로드
    ↓
  RSC payload는 React 트리에 그대로 삽입 (hydration 없음)
  Client Component는 코드 실행해서 가상 DOM 만들고 실제 DOM과 매칭 (Hydration)
    ↓
  이벤트 핸들러 부착 완료 → 인터랙티브
```

1. <b>Hydration Mismatch : 서버 SSR 결과 ≠ 클라이언트 Hydration 결과 일 때 어떤 문제가 발생할 수 있을까?</b>
   <p>
   하이드레이션이 발생하려면<b> 결정론적(같은 입력는 같은 결과를 초래해야한다)</b>이어야한다.
   </p>

   <p>
   서버에서 호출했을때와 클라이언트에서 호출했을때 같은 결과가 나와야 리액트가 매치할수있기 때문
   </p>

   ```javascript
   "use client";

   import dayjs from "dayjs";
   import relativeTime from "dayjs/plugin/relativeTime";

   dayjs.extend(relativeTime);

   export function VideoCard({ video }) {
     return (
       <div>
         <h3>{video.title}</h3>
         <p>업로더: {video.uploader}</p>
         <span>{dayjs(video.uploadedAt).fromNow()}</span>
         {/*       ↑ 여기가 비결정적 문제의 구간*/}
       </div>
     );
   }
   ```

   > 왜 발생하는가

   <p>
   같은 컴포넌트 함수를 두 번 실행하지만 환경이 다르기 때문.
   </p>

   - <code>Date.now()</code>: 서버 응답 시각 vs hydration 실행 시각 (수백 ms\~수 초 차이)
   - <code>window</code>, <code>localStorage</code>: 서버에 없음, 클라이언트에 있음
   - <code>Math.random()</code>: 양쪽 결과 다름
   - 타임존: 서버 vs 사용자

   <p>
   근본 원인 한 줄: <b>결정론 위반</b>.<br />서버와 클라이언트가 같은 입력 → 같은 출력을 내야 하는데, 비결정적 입력이 섞이면 깨진다.
   </p>

   ### 예시

   <p>
   상대시간으로 변경해주는 함수를 통해 하이드레이션이 발생하였을때, 아래와 같이 <b>결정론이 위반</b>될수있다.
   </p>

   ```javascript
   서버:     <Component /> → "30분 전"
   클라이언트: <Component /> → "30분 전"   ← 같아야 매칭 성공
   ```

   ```javascript
   서버:     <Component /> → "30분 전"
   클라이언트: <Component /> → "31분 전"   ← Mismatch
   ```

   ### 처리 방법

   > <b>useEffect 이후 렌더</b>

   ```javascript
   function VideoCard({ uploadedAt }) {
     const [relativeTime, setRelativeTime] = useState(null);

     useEffect(() => {
       setRelativeTime(dayjs(uploadedAt).fromNow());
     }, [uploadedAt]);

     return <span>{relativeTime ?? uploadedAt}</span>;
     //                          ↑ 첫 렌더는 절대시각
   }
   ```

   <p>
   <b>여기서 결정론이 보장되는 방식</b>:
   </p>

   - 서버 렌더: <code>relativeTime</code>은 <code>null</code> → 절대시각 표시 (HTML에는 null로 담아서 전달)
   - 클라이언트 첫 렌더 (hydration 시점): <code>relativeTime</code>은 아직 <code>null</code> → 절대시각 표시
   - <b>둘 다 같은 결과</b>  → mismatch 없음

   <p>
   그 다음 useEffect가 실행되면서 상대시간으로 전환되는데, 이건 <b>hydration이 끝난 후</b>에 일어나는 일반 state 업데이트라 mismatch와 무관
   </p>


   ### 왜 문제인가 (성능과의 연결)

   <p>
   React 18부터는 mismatch 시 트리 전체가 깨지지 않고 해당 부분만 클라이언트 재렌더로 fallback.<br />하지만 fallback도 메인 스레드 JS 비용으로 잡힘 → <b>TBT 증가, hydration 완료 지연</b>.
   </p>

   <p>
   → Performance 패널의 스크립트 시간이 늘어나는 원인 중 하나가 mismatch fallback.
   </p>

   <p>
   → SSR + Hydration으로 얻은 LCP 개선이 TBT 악화로 상쇄될 수 있음.
   </p>
