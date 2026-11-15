# CORS

## 1. 배경과 맥락

<quote>
어떤 이유 때문에 필요 했는가?
</quote>

<ul>
<li>
BFF 를 사용하지 않던 우리 프로젝트에서 RT를 쿠키로 받으려고 설계하였으나, cross origin 에 의해 브라우저에 쿠키가 저장이 안되고 있었다. 해결책으로 프록시를 사용하였는데, <b>프록시? 업스트림? Route handler? </b>개념이 생소하고 서버와 관련되는 용어들이었기 때문에 더 난해하고 이해하기 어려웠다.
</li>
<li>
당시엔 이해하지 못하고 구현에 집중하고자 넘겼는데 최근, LCP 속도를 개선하기 위해 서버 컴포넌트를 활용하기로 하였다. 기존에 사용하고 있던 프록시의 역할을 BFF로 완전히 도입하기로 하였다. 때문에 프록시 역할을 하는 방식에 대해 이해하고자 CORS에 대해 공부해보려한다.
</li>
</ul>

## 2. 기술 키워드

> <span color="gray_bg">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

- <b>CORS (Cross-Origin Resource Sharing)</b>
  <ul>
  <li>
  서버가 하용한 경우에만 <b>Cross-Origin을 허용한다.</b>
  </li>
  <li>
  브라우저의 기본 보안 정책은 SOP(Same-Origin Policy)이고, 다른 오리진으로의 요청 및 응답 접근을 기본적으로 차단합니다. CORS는 이 제한을 <b>서버가 허용한 범위 안에서</b> 선택적으로 풀어주는 메커니즘입니다<b>. → 즉 SOP가 원칙(차단), CORS가 그 예외(허용 조건)입니다.</b>
  </li>
  <li>
  브라우저는 <b>Same-Origin Policy</b>를 기반으로, 현재 페이지와 <b>origin이 다른 서버로 보내는 요청을 제한</b>한다.
  </li>
  <li color="gray_bg">
  Origin은

  - scheme(http/https)
  - host(localhost, stg.molip.today)
  - port(3000, 443 등)

  를 보기 때문에 해당 3개중에 하나만 달라고 origin이 다르다고 볼수있다.

  <b>즉, </b>[<b>http://localhost</b>](http://localhost/)<b> /api ↔  </b>[<b>https://stg.molip.today/</b>](https://stg.molip.today/)<b>api 는 오리진이 다르다.</b>
  </li>
  </ul>

  <p>
  브라우저가  fetch [https://stg.molip.today/v1/task/token](https://stg.molip.today/api/task/token) 처럼 직접 요청하면 origin이 다르기 때문에 검사한다.
  </p>

  <p>
  이것을<b> </b><b><span color="red">CORS</span></b>라고 한다.
  </p>
- <b>route handler</b>
  - Next.js의 <b>Route Handler</b>는 특정 <b>URL 경로(route)로 들어오는 HTTP 요청을 처리하는 서버 함수</b>이다.
    ```less
    //파일 구조
    app/api/task/[...path]/route.ts
    ```

    <p>
    브라우저가 <b><u>GET /api/task/token 로 보내면 ../api/task  == </u></b>해당 경로에 매핑된 route.ts를 실행하여 요청을 처리한다.
    </p>

    <p>
    <b>→ 이러한 특성을 이용해 브라우저의 백엔드 요청(fetch)역할을 대신 해줄 수 있다.</b>
    </p>

    <callout color="yellow_bg">
    <b>라우트 핸들러 ↔ 브라우저 흐름</b>

    1. 브라우저(localhost:3000)에서 [http://localhost:3000/api/task/token](http://localhost:3000/api/task/token) (NextJS)로 요청보낸다.
       <image source="notion-file-block://3cfee90a-967f-804c-b2f6-e6d2f0b0e528/c67e7451-b835-4102-ab1f-f7b0c7377e1c?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

       <p>
       <b>❓ 어떻게 가능한가?</b>

       <p>
       localhost:3000 포트를 Next 서버가 점유해서 HTTP 서버로 리슨 중이기 때문에, [http://localhost:3000](http://localhost:3000/api/task/token)가 <b>NEXT서버</b>로 열려있다.
       </p>

       Same origin(origin이 동일하기 때문에)이기 때문에 브라우저 정책 O
       </p>

       1. <b>app/api/task/\[...path\]/route.ts </b>가 <b><span color="red">그 경로를 라우팅 처리</span></b>한다.
    2. Next route-handler(서버에 작성된 코드)가  [<b>https://stg.molip.today/api/task/token</b>](https://stg.molip.today/api/task/token)<b> 로 재요청한다.</b>
       <p>
       <b>우회하는 느낌이 드는 것이 맞다</b>
       </p>
    </callout>

    <callout color="purple_bg">
    <b>Next서버가 재요청 보낼때도 결국 </b>[<b>localhost</b>](http://localhost)<b> origin을 갖는거 아닌가요?</b>

    - Next 서버가 뒤에서 stg로 대신 호출 -> <b>서버-서버 통신이라 브라우저 CORS와 무관하다.</b>
      - <b><span color="red">서버-서버 통신이 왜 CORS(cross-origin)랑 무관한건가?</span></b>
        - <b>서버</b>는 <b>브라우저 샌드박스</b>가 아닙니다. 그래서 브라우저처럼<b> Same-Origin Policy/CORS</b>에 묶이지 않습니다.
          <toggle color="gray_bg">
          <b>브라우저 샌드박스</b>

          웹사이트의 JavaScript 코드는 브라우저가 만든 <b><u>격리된 실행 환경(샌드박스) </u></b>안에서 실행된다.
          </toggle>
        - 그냥 <b>네트워크 가능한 대상</b>이면 <b><u>일반 HTTP 클라이언트처럼 요청</u></b>할 수 있습니다.
    - <b>브라우저: </b>보안 정책(CORS)으로 <b>cross-origin 제한</b>
    - <b>서버: </b>보안 정책 주체가 아니라서 <b>outbound</b> 요청 자유
      <toggle color="gray_bg">
      <b>outbound : </b>

      - 내버서 → 외부로 나가는 요청(<b>outbound</b>)
      </toggle>

      <p>
      Node.js는 <b><u>일반 HTTP 클라이언트</u></b>이므로 네트워크 접근이 가능한 서버라면 임의의 URL로 자유<b>롭게 요청을 보낼 수 있다.</b>
      </p>

      <p>
      때문에 인스턴스 두개
      </p>

      <p>
      따라서 Route Handler가 백엔드 API를 호출하는 과정에서는 CORS 검사가 발생하지 않는다.
      </p>
    </callout>
- <b>전체 요청 흐름</b>
  ```mermaid
  sequenceDiagram
      participant B as Browser
      participant N as Next.js Route Handler (Proxy)
      participant S as Backend Server (stg.molip.today)

      B->>N: GET /api/task/token
      N->>S: GET https://stg.molip.today/api/task/token
      S-->>N: Response
      N-->>B: Response
  ```

  <p>
  해당 그림에서 브라우저는 백엔드 서버에게 직접 요청을 보내지 않고 route handler를 거칩니다.
  </p>

  <p>
  route handler는 진짜 객체인 <b>백엔드 서버</b>를 감싸는 가짜 객체이고,
  </p>

  <p>
  브라우저는 이 가짜 객체(route handler)를 진짜 백엔드인 것처럼 상대합니다. 그래서 route handler가 프록시의 역할을 한다고 말할 수 있습니다.
  </p>
- <b>프록시 : </b>진짜 객체를 감싸는 가짜 객체, 진짜 객체를 위해 보정하거나 등등을 함.
- <b>업스트림 호출</b>
  - <b>업스트림 : 프록시(라우터 핸들러)</b>가 실제로 요청을 보내는 원본 백엔드 서버이다.
    - <b>업스트림 호출 : </b>라우터 핸들러가 브라우저 요청을 받아서 실제 백엔드로 대신 fetch 요청을 보냄.

<ul>
<li>
이 프록시를 사용해 단순히 외부에서 오는 RT를 origin이 다른 [localhost](http://localhost) 쿠키로 저장하기 위한 수단으로 사용하고 있지만, 이것을 전역적으로 사용한다면 <b>BFF(Backend For Frontend)</b> 가 되는 것이다.
</li>
</ul>

## 3. 고민했던 내용과 인사이트

- <b>러닝 커브가 있어 학습이 어려운 BFF, 왜 사용했는가? </b>
  <ul>
  <li>
  React를 해온 우리는 SPA가 익숙하고 브라우저에서 fetch를 보내는 것이 당연했다.

  - 하지만, LCP 개선중에 이런 생각이 들었다. FCP와 동시에 LCP가 렌더링 되면 어떨까?
  - NextJS는 이런 문제를 해결하기 위해서, 서버 컴포넌트를 지원한다.
    <ul>
    <li>
    서버 컴포넌트는 서버에서 렌더링을 우선적으로 렌더링을 해주기 때문에 FCP와 LCP가 거의 동일한 타이밍에 제공된다.
    </li>
    <li>
    이것을 이용하여 LCP를 개선하는 방법으로 이용한다.
    </li>
    <li>
    인증토큰이 필요한 api일 경우 AT를 필요로하는 경우가 많음

    <p>
    → 서버에서 fetch하려면auth token 필요
    </p>

    → sessionStorage token 이면 서버에서 접근못함 (JS실행 이기 때문에 CSR로 넘어감)

    → AT를 쿠키로 내려야한다! = 쿠키기반인증 도입

    → RSC + BFF 조합을 채택하기로 함.
    </li>
    </ul>

  > <b>실제 개선 내용</b>

  <ul>
  <li>
  첫번때 FCP/LCP : 서버 컴포넌트 도입
  </li>
  <li>
  두번째 FCP/LCP : 여전히 CSR
  </li>
  </ul>

  <image source="notion-file-block://3cfee90a-967f-8078-a323-d25840064bbd/f89782ed-d4db-430e-b628-333e38df89c6?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />


    </li>
  </ul>
- <b>그럼 대체 브라우저는 왜 이런 보안 정책을 걸어둔거냐?</b>
  <p>
  사용자의 인증 정보(쿠키, 세션 등)가 다른 사이트에서 악용되는 것을 막기 위해서
  </p>

  - 웹 서비스 대부분은 로그인 상태를 <b>쿠키(cookie)</b> 로 유지합니다.
    - bank.com 로그인하고 난뒤 → 브라우저에 session cookie 저장 →  이후 bank.com 요청마다 자동으로 <b>쿠키를 붙인다.</b>
  - <b>만약 Same-Origin 정책이 없다면</b>
    <ul>
    <li>
    bank.com 로그인하고 난뒤 → (쿠키 붙은 채로 )악성 사이트 evil.com 방문

    <ul>
    <li>
    악성사이트가 해당 코드를 실행

    - 브라우저는 자동으로 쿠키를 붙입니다.
    </li>
    </ul>

    ```less
    <form action="https://bank.com/api/transfer" method="POST">
      <input type="hidden" name="to" value="attacker" />
      <input type="hidden" name="amount" value="1000000" />
    </form>
    <script>document.forms[0].submit()</script>
    ```

    <code><form></code> 제출은 JS의 credentials 및 CORS 프리플라이트 없이도 브라우저가 쿠키를 자동으로 붙여서 보냅니다. 때문에 실제 CSRF 공격이 fetch보다 form을 많이 쓴다고 합니다.

    ```less
    POST https://bank.com/api/transfer
    Cookie: session=abc123
    ```
    </li>
    <li>
    <b>브라우저는 자동으로 쿠키를 붙여서 요청 보낸다. </b>→ 쿠키를 빼돌림.
    </li>
    <li>
    은행 서버 입장

    - 해당 쿠키를 갖고 은행 서버 입장 시 쿠키가 있기 때문에, 브라우저는 → 정상 로그인 사용자 요청이라고 생각함.  → 송금 실행
    </li>
    </ul>

<callout color="purple_bg">
위와 같은 상황을 <b>CSRF (Cross Site Request Forgery)</b>

<p>
<b>SOP는 CSRF를 막지 못합니다.</b> SOP는 다른 오리진의 스크립트가 응답을 읽는 것을 막는 것이고, 요청 자체가 나가는 것을 막는 정책이 아니기 때문입니다.
</p>

<p>
evil.com의 fetch는 SOP와 무관하게 그대로 bank.com에 도달하고, 쿠키도 붙습니다.
</p>

다만 evil.com이 그 응답을 JS로 읽지 못할 뿐입니다.

<p>
그런데 CSRF 공격은 "송금이 실행됐다"는 사실 자체가 목적이기 때문에, 응답을 읽을 필요가 없습니다. <br />그래서 SOP만으로는 CSRF를 막을 수 없고, 실제 방어는 SameSite 쿠키, CSRF 토큰, Origin/Referer 검증 같은 별도 수단으로 이루어집니다.
</p>
</callout>

- 돌고 돌아 언제나 예외는 발생하다. : 개발할때 다른 오리진에서 요청하거나 응답을 받아야할 상황이 발생
  - <b>이러한 예외상황을 대처하기 위해 CORS가 생김.</b>

\<form action="[https://bank.com/api/transfer](https://bank.com/api/transfer)" method="POST"><br />\<input type="hidden" name="to" value="attacker" /><br />\<input type="hidden" name="amount" value="1000000" /><br />\</form><br />\<script>document.forms\[0\].submit()\</script>
