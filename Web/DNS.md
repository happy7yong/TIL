# DNS

## 문제 및 배경

- 서버 배포하려고 도메인을 사려고 했는데 IP와 도메인의 관계와 어떻게 IP를 바꿔주는 걸까 라는 궁금증에 시작했습니다

## 핵심 키워드

<callout color="brown_bg">
- <b>DNS : </b>Domain Name System
  <p>
  사람이 이해하는 주소를 IP주소로 바꿔주는 시스템
  </p>
</callout>

<image source="notion-file-block://3cfee90a-967f-8092-b3fc-e53170fdabe9/e6be96c2-851e-467a-947c-529bac41f3bf?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<p>
장군(클라이언트)가 바로 왕(서버)에게 요청 응답을 받는 것이 아니라, 우체국을 거쳐서 요청 응답을 받는것임.
</p>

<p>
우체국 :만국 우편연합이 국가를 알려주고, 주소등록 대행소가 지역을 알려주고 주소관리기관
</p>

전초기지 :<span color="gray_bg"> </span><b><span color="gray_bg">프록시 / 게이트 웨이 / 로드 밸런스</span></b>

<p>
→ 여러개의 클라이언트 요청을 모아서 서버로 전달하고 트래픽 관리
</p>

<callout color="green_bg">
<b>시종은 한번에 3번 주소관리 기지로 방문하면 되지 왜 1번까지 갔을까?</b>

- 내가 알고 있는 주소가. 표준인지 (외부 표준 : 전세계 주소 표기 규칙) 알아야 하기 때문.
  - 청라(내가 알고 있는 주소) → 인천광역시 서구 청라 (국제 표준)
  - 1번에서 다른 시스템이 알 수 있도록 형식을 변환해야됨.
</callout>

<b>yong.kr이 실제로 찾아가는 과정 (그림에 비유)</b>

1. <b>사용자(클라이언트, 왼쪽 병사)</b>
2. <b><span color="blue">전초기지(</span></b><b><span color="red">Resolver</span></b><b><span color="blue">, 캐시 DNS)</span></b>
3. <b>① 만국 우편 연합 (</b><b><span color="blue">Root DNS</span></b><b>, 국제 표준 관리) : 최상위 계층</b>
4. <b>② 주소 등록 대행소 (</b><b><span color="blue">TLD DNS,</span></b><b> .kr 네임서버)</b>
5. <b>③ 주소 관리 기관 (</b><b><span color="blue">Authoritative DNS,</span></b><b> 권한 서버)</b>
   <p>
   → <span color="gray">“yong.kr 실제 위치(IP 주소)는 203.0.113.5야” </span>하고 최종 주소(IP) 반환.
   </p>
6. <b><span color="blue">우체국(실제 서버) = 로컬 DNS</span></b>
   <p>
   → 이제 클라이언트가 그 IP를 찾아가서 실제 웹사이트(yong.kr 서버)에 접속.
   </p>

---

<b>DNS (DNS 서버) : </b>Domain Name 전세계적으로 모든 컴퓨터가 식별하기 위해 사용되는 이름

<b>정의 \| </b><b><span color="blue">도메인 이름</span></b><b>과 </b><b><span color="blue">IP주소</span></b><b>를 연결하는 프로그램이나 서버</b>

- IP주소는 사람이 쉽게 기억할 수 없는데, 이런 IP주소를 사람이 쉽게 기억할 수 있는 도메인 이름과 맵핑해주는 시스템
- <b>리졸버 </b>: 도메인 이름을 IP주소로 변환해주는 역할 ⇒ 브라우저와 로컬DNS의 IP 를 잇는 역할

---

<image source="notion-file-block://3cfee90a-967f-8068-8bb3-e7faa18b193e/61739112-2f77-412f-9587-0dfcc2ca307d?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<table header-row="true">
<colgroup>
<col />
<col />
<col width="460.99998474121094" />
</colgroup>
<tr>
<td>
<b>순서</b>
</td>
<td>
<b>동작명</b>
</td>
<td>
<b>설명</b>
</td>
</tr>
<tr>
<td>
1
</td>
<td>
도메인 이름 입력
</td>
<td>
사용자가 웹 브라우저에 도메인 이름을 입력합니다.
</td>
</tr>
<tr>
<td>
2
</td>
<td>
<b>브라우저에서 </b><b><span color="red">DNS 캐시</span></b><b> </b>확인
</td>
<td>
1. 브라우저 캐시 확인<br />2. OS 캐시 확인
</td>
</tr>
<tr>
<td>
3
</td>
<td>
<b><span color="red">브라우저 → 로컬 DNS</span></b>
</td>
<td></td>
</tr>
<tr color="gray_bg">
<td>
4
</td>
<td>
<b><span color="red">로컬 DNS 리졸브 요청</span></b>
</td>
<td>
<b>브라우저는 로컬 DNS 리졸브에 해당 도메인의 IP 주소를 요청합니다.<br />(로컬 DNS 서버 = 캐싱 DNS 서버 = ISP DNS 서버 ≒ Non-Authoritative Name Server 중에 하나)</b>
</td>
</tr>
<tr color="gray_bg">
<td>
5
</td>
<td>
<b>로컬 DNS 캐시 확인</b>
</td>
<td>
로컬 DNS 서버는 먼저 자신의 캐시를 확인하여 요청된 도메인의 IP 주소가 있는지 검사합니다.
</td>
</tr>
<tr color="gray_bg">
<td>
6
</td>
<td>
<b><span color="blue">루트</span></b> DNS 서버 요청
</td>
<td>
캐시에 없다면, 로컬 DNS 서버는 루트 DNS 서버에 요청을 전송합니다.
</td>
</tr>
<tr color="gray_bg">
<td>
7
</td>
<td>
<b><span color="blue">TLD</span></b> DNS 서버 요청
</td>
<td>
루트 DNS 서버는 해당 도메인의 TLD(Top-Level Domain)에 해당하는<b> TLD DNS 서버의 주소를 로컬 DNS 서버</b>에 알려줍니다.
</td>
</tr>
<tr color="gray_bg">
<td>
8
</td>
<td>
<b><span color="blue">NS 서버 </span></b>요청
</td>
<td>
로컬 DNS 서버는 TLD DNS 서버에 요청을 전송하여 권한 있는 NS 서버의 주소를 얻습니다.
</td>
</tr>
<tr color="gray_bg">
<td>
9
</td>
<td>
<b><span color="red">도메인 IP 주소</span></b> 조회
</td>
<td>
로컬 DNS 서버는 권한 있는 NS 서버에 요청을 전송하여 실제 도메인의 IP 주소를 조회합니다.
</td>
</tr>
<tr>
<td>
10
</td>
<td>
IP 주소<br /><b><span color="red">로컬 DNS 서버</span></b>로 반환
</td>
<td>
권한 있는 DNS 서버는 조회된 IP 주소를 로컬 DNS 서버로 반환합니다.
</td>
</tr>
<tr>
<td>
11
</td>
<td>
IP 주소<b> 캐싱</b>
</td>
<td>
로컬 DNS 서버는 이 IP 주소를 자신의 캐시에 저장합니다.
</td>
</tr>
<tr>
<td>
12
</td>
<td>
IP 주소 브라우저로 반환
</td>
<td>
로컬 DNS 서버는 조회된 IP 주소를 사용자의 브라우저로 반환합니다.
</td>
</tr>
<tr>
<td>
13
</td>
<td>
웹 서버 연결
</td>
<td>
브라우저는 받은 IP 주소를 사용하여 웹 서버에 연결합니다.
</td>
</tr>
<tr>
<td>
14
</td>
<td>
웹 페이지 로드
</td>
<td>
웹 서버는 요청된 웹 페이지를 사용자의 브라우저로 전송합니다.
</td>
</tr>
</table>

<callout color="green_bg">
<b>로컬 DNS란? 지역 네트워크 : 내가 가장 먼저 의존하는 서버(나와 가장 가까운 서버)</b>

→ 캐시가 있으면 바로 IP변환 (캐시를 가져옴)

→ 없으면 로컬 <b>DNS의 리졸브</b>에게 요청( Root DNS → .kr TLD DNS → [yong.kr](http://yong.kr/) 권한)

→ 최종 IP를 받아오면 <b><span color="red">내 컴퓨터</span></b>한테 전달 → <b><span color="blue">일정기간</span></b>동안 캐시를 저장해둠.
</callout>

> <b>DNS 캐시가 저장되는 곳</b>

<ol>
<li>
내 컴퓨터 로컬 PC (OS)
</li>
<li>
로컬 DNS 서버

1. 수많은 사용자가 공통으로 쓰는<b> DNS 서버도 캐시를 보관</b>해서 효율적으로 응답
</li>
<li>
중간 프록시/ 게이트웨이 서버에 캐싱
</li>
</ol>

<callout color="yellow_bg">
<b>요약</b>

브라우저는 먼저 캐시를 확인하고, 없으면<b> 로컬 DNS 리졸버에 요청</b>하며, 리졸버가 <b>DNS 계층을 탐색해 IP를 찾아 반환</b>한다.
</callout>

---

<b>DNS 진행 과정 </b>

<image source="notion-file-block://3cfee90a-967f-805f-97fd-ff156b1f7294/2eccb75a-c6be-4d3d-baff-d320b6da61c7?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
