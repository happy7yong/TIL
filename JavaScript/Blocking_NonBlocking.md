# 블로킹과 논블로킹

## 1. 배경과 맥락

<quote>
어떤 이유 때문에 필요 했는가?
</quote>

- 브라우저 성능 최적화를 위해 LCP 또는 TBT를 개선하는 과정에서 이런 단어를 많이 마주친다.
  <ul>
  <li>
  <b>“렌더링 차단”,</b> <b>JS 메인스레드를 00청크가 블로킹 중이다” </b>여기서 블로킹이라는 단어의 의미를 어렴풋이 알고있다. 하지만 결국 CS 면접에서 블로킹 논블로킹 / 비동기 동기에 대해 물어본다면 자신있게 말할 수 있는가? → 없다..
  </li>
  <li>
  개인 프로젝트 때 과제에 쫓겨 깊이있게 공부하지 못했던 블로킹 논블로킹에 대해 공부해 보려한다.
  </li>
  </ul>

<image source="notion-file-block://3cfee90a-967f-801e-bd84-ccd5cf65359d/45b0aea1-42e3-4ef5-9759-d8b5841a42e9?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png">
판서를 확인했는데 이런 소제목이 있었다 …
</image>

## 2. 기술 키워드

> <span color="gray_bg">키워드 위주로 적고 말로 설명하는 연습을 합시다. </span>

<callout color="purple_bg">
### 블로킹 vs 논블로킹

- <b>제어권</b>
  <ul>
  <li>
  함수를 실행할 수 있는 권리
  </li>
  <li>
  제어권이<b> 누구에게 있는지에 따라 구별</b>할수있다.
  </li>
  </ul>
</callout>

- <b>블로킹 </b>
  - <b>어떤 작업이 끝날때까지 다음작업이 진행되지 못하고 기다리는 상태</b>를 의미한다.
    <image source="notion-file-block://3cfee90a-967f-80b5-a9bc-c1fb54abd506/95730a9b-0feb-4392-af20-c4b04931d9a9?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
  - A함수가 B함수를 호출했다고 할때, A작업이 제어권을 B작업에게 넘겨준 동안 A작업은 B작업을 기다려야한다 → <b><span color="blue">A작업은 진행하지 못하고 대기</span></b> → 이후 B가 끝나고 A에게 제어권을 넘겨줌
    <callout color="brown_bg">
    <b>❓ 그렇다면 기존 작업보다 우선순위가 더 큰 작업이 들어왔을때 B작업이 시작된다고 이해해도 괜찮은가?</b>

    우선순위, 선점 X → 다른 작업이 실행되지 못하고<b> 다음 작업이 대기 상태</b>

    <b>예시) </b>

    1. 메뉴 고르기
    2. 밥 먹기
    3. TV보기
       <p>
       → 2번 밥먹기 작업이 늦어진다면 3번 TV보기는 블로킹 상태인 것.
       </p>
    </callout>

    <callout color="yellow_bg">
    <p>
    JS는 싱글 스레드와 RTC(Run to Completion 모델)을 사용하기 때문에 하나의 작업이 시작되면 끝날때까지 다른 작업이 끼어들수없다.
    </p>

    <b>JS 실행 중 → CPU 점유 → 렌더링 못함 → 이벤트 처리 못함</b>
    </callout>
- <b>논블로킹</b>
  - <b>어떠한 작업을 기다리지 않고 다음 작업을 계속 진행할수있는 상태</b>
  - 제어권을 A가 B에게 건네주지만 거의 바로 <b><span color="blue">B가 A에게 다시 돌려준다.</span></b>

  <image source="notion-file-block://3cfee90a-967f-809f-9944-eb64521eed74/3aa9cd8d-b2ee-4aba-9bc7-1ac6431fd641?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

  <callout color="brown_bg">
  <b>❓ 메인스레드에서 비동기 작업을 요청하면 해당 작업이 백그라운드(web API)에서 처리될경우, 메인스레드는 그 작업에 의해 점유당하지 않고 다음 작업을 이어갈수있다. 이것도 논블로킹인가?</b>

  <b>논블로킹 </b>: 메인 스레드를 오래 점유하지 않는 코드

  <b>예시) </b>

  1. 메뉴 고르기
  2. 밥 먹으면서 함께 (3번이었던)TV보기

  <b>3번 작업은 밥이 끝날때까지 기다리지 않는다.</b>
  </callout>

<callout color="purple_bg">
<h3>
동기 vs 비동기
</h3>

- <b>함수의 종료 시점</b>
- <b>결과값의 전달 시점</b>
</callout>

- <b>동기</b>
  - <b>작업이 순차적으로 진행되고, 앞 작업이 끝날때까지 기다리는 실행 방식</b>
    <image source="notion-file-block://3cfee90a-967f-8022-90d8-e61b43b83763/6a004700-b850-4157-9b35-25d28fdcc55d?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=2960ac9b-c0b4-4eb8-bfab-12528170e972.png" />
  - A함수가 B함수를 호출했다고 할때, <b>B의 작업이 끝난 시점과 A작업이 B의 작업 결과를 기다린다.</b>
  - A함수 관점 : B의 결과물을 받아야되기때문에 B를 감시중(대기중) (active)
- <b>비동기</b>
  - <b>작업 요청 후 기다리지 않고 다음 작업 실행</b>

  <image source="notion-file-block://3cfee90a-967f-8079-b5c7-c471ec903a7b/0c50e5fc-5da5-4822-b1b4-2e1ffdfb2f82?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

### 핵심 기준

- <b>블로킹 논블로킹 : </b>실행 중<b> 스레드 상태</b>
  - CPU 모두 점유중일 경우 → 스레드가 작업에 의해 모두 할당되었기 때문에 다른 작업 불가능 → 블로킹됨.
    <image source="notion-file-block://3cfee90a-967f-8035-87ee-ced59a33e56e/87decc64-6901-43b5-b84f-aa0199a377a6?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
- <b>동기 비동기</b> : 제어권이 누구에게 있는가 →<b> 결과 전달 방식</b>

---

## 3. 고민했던 내용과 인사이트

### <b>❓ A가 B를 기다리는 건 동기나 블로킹이나 똑같은거 아니유?</b>

<p>
A입장에서는 그럴수있지만 A가 B를 기다리며 다른 작업 수행이 가능하다.
</p>

1. 번호표 뽑음
2. 호출될 때까지 카페에서 <b>대기</b>
3. 번호 호출되면 창구 감
4. 결과 받음

- <b>2번에서 번호를 기다리며 카페에서 대기 (논블로킹)</b>
- <b>결과를 받아야됨. (동기)</b>

1. 음식 주문
2. 친구랑 게임함
3. 음식 도착 알림

- <b>결과 나중에 받음(논블로킹)</b>
- <b>기다리지 않음(비동기)</b>

### ❓ 블로킹과 논블로킹이 브라우저에서 어떻게 발생될 수 있는가?

- <b>브라우저에서 발생할수있는 상황</b>
  <p>
  1\. JS 실행
  </p>

  <p>
  2\. 렌더링
  </p>

  <p>
  3\. 사용자 클릭 처리
  </p>

  - JS 실행(오래걸림) → 렌더링 못함 → 클릭 이벤트 처리 못함.
- 실제 상황
  ```ts
  for (let i = 0; i < 10000000000; i++) {}
  ```

  <p>
  JS 실행 시작 → 반복문 계속 실행 → 메인 스레드 점유 → 렌더링 못함 → 사용자 입력 못받음
  </p>

  <p>
  <b>= JS가 끝나기 전까지 렌더링을 못합니다.</b>
  </p>

  - 이걸 <b>Main Thread Blocking, Long Task</b>
    <image source="notion-file-block://3cfee90a-967f-802c-b303-e1ecd481a06b/4ce6818a-fdeb-4cce-9ed6-d089ea948bf8?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
