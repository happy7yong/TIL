# Ran | 뭇별의 장

남겨진 기록은 기억이 되어 나를 다음 행선지로 이끌어 준다.

## 📌 기록 규칙

- 공식 문서 찾아보는 습관 들이기.

## ✨ Study Collections

### JAVA

- [Jvm](Java/JVM.md)
- [Garbage Collection](Java/Garbage-Collection.md)
- [PermGen과 Metaspace](Java/PermGen-Metaspace.md)
- [Type](Java/Type-String.md)
- [Thread, runnable](Java/Thread-Runnable.md)
- [ExecutorService-Synchronized](Java/ExecutorService-Synchronized.md)
- [Optional](Java/Optional.md)
- [[Deep Dive] Java의 enum 객체는 꼭 불변인 건 아니다?](Springboot/Java-Enum-immutable.md)

### Web

- [01 - DNS 요청 흐름과 동작 원리](Web/network_dns_request_flow.md)
- [02 - Proxy Server](Web/Proxy.md)
- [03 - HTTP Cache](Web/HTTP_Cache.md)
- [07 - Cookie : 1st Party Cookie - 3rd Party Cookie](Web/Cookie.md)
- [08 - Storage : Local - Session](Web/Storage_Local_Session.md)
- [09 - Session](Web/Session.md)
- [09-1 - Cookie vs Storage vs Session](Web/Cookie_Storage_Session.md)
- [10 - JWT](Web/JWT.md)
- [[Deep Dive] SSL/DLS](Web/TLS_SSL.md)
- [11 - Port Forwarding (포트포워딩)](Web/Port_Forwarding.md)
- [12 - 집 네트워크 핵심 구조: DHCP, NAT, SNAT, DNAT](Web/Home_Network_DHCP_NAT_DNAT.md)
- [13 - LAN과 MAC 핵심 정리](Web/LAN_MAC_ARP_DHCP_Reservation.md)
- [14 - WebSocket 연결과 STOMP CONNECT의 차이](Web/WebSocket_STOMP_PubSub.md)
- [15 - STOMP 세션 로그 해석 (CONNECT ~ SEND)](Web/STOMP_Session_Log_Trace.md)
- [16 - STOMP destination과 event type의 차이](Web/STOMP_Destination_vs_EventType.md)
- [17 - Publish / Subscribe / Broadcast / Broker 구조 정리](Web/Pub_Sub_Broadcast.md)
- [DOM이란 무엇인가요](Web/DOM.md)
- [DNS](Web/DNS.md)
- [CSRF](Web/CSRF.md)
- [CORS](Web/CORS.md)
- [WebSocket Race Condition](Web/WebSocket_Race_Condition.md)
- [웹 네트워크 요청 흐름](Web/Network_Request_Flow.md)

### CS

- [01 - WebSocket 연결 수명주기: TCP, URL, STOMP, 이벤트 통신](CS/WebSocket_TCP_STOMP_EventFlow.md)
- [02 - TCP 3-Way Handshake: 시퀀스 번호 동기화](CS/TCP_3Way_Handshake.md)

### Spring

- [Spring Boot 입문하기 : 도서 조회](Springboot/Spring-book-search.md)
- [Spring Boot 입문하기 : sysout의 위험과 logger의 권장](Springboot/Spring-sysout-logger.md)
- [Enum과 친해지기 + TS와 JAVA의 Enum](Springboot/Enum-About.md)
- [JDBC에서 JPA로: 전환 흐름 정리](Springboot/02_JPA_intro_from_JDBC.md)
- [CGLIB / Proxy Entity]() //

### Database

- [NoSQL](DataBase/NoSQL.md)
- [Index](DataBase/Index_cluster_noncluster.md)
- [Tree : B-Tree, B+Tree](DataBase/Tree-BTree.md)

### JPA

- [ORM 개념과 JPA/Hibernate 관계 입문](JPA/01_ORM_intro.md)
- [ORM 개념과 JPA, Hibernate의 관계](JPA/02_JPA_intro_from_JDBC.md)
- [JPA의 개념과 JDBC와의 관계](JPA/02_JPA_intro_from_JDBC.md)
- [리플렉션(Reflection)이란](JPA/04_Reflection_concept_and_example.md)
- [영속성 컨텍스트(Persistency Context)와 엔티티의 생명주기](JPA/03_JPA_persistence_context.md)
- [연관관계 : 1:N(OneToMany), N:1(ManyToOne)](JPA/JPA_relationship_mapping_unidirectional_bidirectional.md)
- [Proxy 객체와 equals/instanceof 비교](JPA/JPA_proxy_and_equals_instanceof.md)
- [연관관계 : fetch 방식 - Eager vs Lazy + N+1문제](JPA/JPA-fetch-Lazy-Eager.md)
- [Spring Data JPA의 개념과 구조](JPA/Spring_data_jpa_repository.md)

### JavaScript

- [[Deep Dive] 함수선언문 vs 함수표현식 vs 화살표 함수의 호이스팅 TDZ 차이](JavaScript/JS_Hoisting-TDZ-Function-Types.md)
- [디바운싱, 쓰로틀링](JavaScript/Debounce_Throttle.md)
- [Promise, resolve](JavaScript/Promise_Resolve.md)
- [이벤트 루프와 콜백함수](JavaScript/Event_Loop_Callback.md)
- [Object.is](JavaScript/Object_is.md)
- [자바스크립트에서 객체가 저장되는 방법](JavaScript/Object_References_Memory.md)
- [렉시컬 스코프와 스코프 체인](JavaScript/Lexical_Scope_Scope_Chain.md)
- [호이스팅과 var / let / const TDZ](JavaScript/Hoisting_var_let_const_TDZ.md)
- [블로킹과 논블로킹](JavaScript/Blocking_NonBlocking.md)

### Git

- [Git Flow 기본 정리](Git/GitFlow.md)

### React

- **Rendering**
  - [00 - React 컴포넌트 렌더링 과정](./React/Rendering/00_Rendering_Overview.md)
  - [01 - JSX와 React Element](./React/Rendering/01_JSX_React_Element.md)
  - [02 - Update Queue와 Batching](./React/Rendering/02_Update_Queue_Batching.md)
  - [03 - Render와 Reconciliation](./React/Rendering/03_Render_Reconciliation.md)
  - [04 - Commit 단계](./React/Rendering/04_Commit_Phase.md)
  - [05 - Fiber와 Concurrent Rendering](./React/Rendering/05_Fiber_Concurrent_Rendering.md)
  - [06 - Effect Lifecycle](./React/Rendering/06_Effect_Lifecycle.md)
  - [07 - Virtual DOM](./React/Rendering/07_Virtual_DOM.md)
  - [React.memo / useCallback / useMemo](./React/Rendering/React_Memoization.md)
- **Fundamentals**
  - [00 - Side Effect란 무엇인가](./React/Fundamentals/00_SideEffect.md)
  - [01 - 순수 함수(Pure Function) 기본 개념](./React/Fundamentals/01_PureFunction.md)
  - [02 - useEffect 의존성 배열 기본 개념](./React/Fundamentals/02_DependencyArray.md)
  - [03 - useEffect에서 발생하는 문제와 올바른 사용법](./React/Fundamentals/)
- **Reducer**
  - [00 - Reducer 이해하기](./React/Reducer/00_Reducer_Basics.md)
  - [01 - useReducer 사용하기](React/Reducer/01_useReducer-basic.md)
  - [01 - 불변성과 업데이트 패턴](./React/Reducer/01_Immutability_and_Update_Patterns.md)
  - [02 - 비동기 로딩 상태 관리](./React/Reducer/02_Async_Loading_State_Management.md)
  - [03 - 낙관적 업데이트(Optimistic Update)](./React/Reducer/03_Optimistic_Update.md)
  - [04 - React 19 – useOptimistic](./React/Reducer/04_React19_useOptimistic.md)
  - [05 - React Query vs useOptimistic 비교](./React/Reducer/05_RQ_vs_useOptimistic.md)
  - [06 - 상태관리 관점에서 Reducer 모델 정리](./React/Reducer/06_StateManagement_and_ReducerModel.md)
- **React Query**
  - [00 - React Query 기본 개념 정리](./React/ReactQuery/00_RQ_Basics.md)
  - [01 - React Query의 에러 처리 & Promise 모델](./React/ReactQuery/01_RQ_Error_Handling_and_Promise_Model.md)
  - [02 - useMutation의 동작 흐름](./React/ReactQuery/02_RQ_Mutation_Flow.md)
  - [03 - React Query 캐시 메커니즘(Cache Mechanism)](./React/ReactQuery/03_RQ_CacheMechanism.md)
  - [04 - React Query의 메모리 구조 & GC(Garbage Collection)](./React/ReactQuery/04_RQ_GarbageCollection_and_Memory.md)
  - [05 - React Query 내부 구조: Action → Reducer → QueryState 흐름](./React/ReactQuery/05_RQ_Internal_Reducer.md)
  - [06 - useQuery vs prefetchQuery](./React/ReactQuery/06_RQ_UseQuery_vs_PrefetchQuery.md)
  - [07 - queryClient](./React/ReactQuery/07_RQ_QueryClient.md)
  - [08 - gcTime, staleTime](./React/ReactQuery/08_RQ_GcTime_StaleTime.md)
  - [09 - 캐시 무효화](./React/ReactQuery/09_RQ_Query_Invalidation.md)
- **Architecture**
  - [Single Flight 정리](./React/Architecture/Single-Flight.md)
  - [BFF 기본 구조와 역할](./React/Architecture/BFF.md)
  - [ESLint 정리](./React/Architecture/ESLint.md)
  - [FSD (Feature Sliced Design) 개요](./React/Architecture/FSD-Feature%20Sliced%20Design.md)
  - [FSD 레이어 개념](./React/Architecture/레이어.md)
  - [PWA 개요](./React/Architecture/PWA.md)
  - [Polyfill 정리](./React/Architecture/Polyfill.md)
  - [Service Worker 개념 메모](./React/Architecture/Service-workder.md)
  - [AI 구조 4단계 스캔법](./React/Architecture/ai-구조-4단계-스캔법.md)
  - [커스텀 훅 return 읽기](./React/Architecture/custom-hook-return-reading.md)
  - [Next.js + FSD](./React/Architecture/nextjs-fsd.md)
  - [Prettier 정리](./React/Architecture/preitter.md)
  - [Push Notification 구조](./React/Architecture/push-notificate.md)
  - [공개 API 설계 메모](./React/Architecture/공개api.md)
  - [아키텍처 규칙](./React/Architecture/규칙.md)
  - [서비스워커 라이프사이클](./React/Architecture/서비스워커-라이프사이클.md)
  - [서비스워커 예시 코드](./React/Architecture/서비스워커-예시코드.md)
  - [서비스워커와 웹워커](./React/Architecture/서비스워커-웹워커.md)
  - [서비스워커 캐시 전략](./React/Architecture/서비스워커-캐시.md)
  - [프리패칭과 코드 스플리팅](./React/Architecture/프리패팅-코드스플리팅.md)
  - [캐시 퍼스트 vs 네트워크 퍼스트](./React/Architecture/images/캐시퍼스트-네트워크퍼스트장단점.md)
- **Misc**
  - [PL Meeting 메모](./React/PLmeeting.md)
  - [RHF + zod 정리](./React/RHF+zod.md)
  - [React Portal](./React/Portal.md)
  - [FE 단위 테스트: Vitest + React Testing Library](./React/Testing/Unit_Testing_Vitest_RTL.md)

### Next.js

- [App Router: route 정리](./Nextjs/next-route.md)
- [Route Group 정리](./Nextjs/routegroup.md)
- [SSR / CSR / ISR / SSG 동작 비교](./Nextjs/SSR-CSR-ISR-SSG.md)
- [브라우저/서버 캐시 종류 정리](./Nextjs/Cache-종류.md)
- [TanStack, Next, App Shell 캐시 위치](./Nextjs/tanstack,next,appshell-캐시-위치.md)
- [RSC에서 Server 안의 Client Component 실행 흐름](./Nextjs/RSC-server-client-execution-flow.md)
- [Server Component와 Client Component](./Nextjs/RSC_Server_Client_Component.md)
- [RSC Payload](./Nextjs/RSC_Payload.md)
- [use client에 대한 오해](./Nextjs/Use_Client_Misconceptions.md)
- [렌더링 전략](./Nextjs/Rendering_Strategies.md)
- [서버 컴포넌트(RSC)](./Nextjs/RSC_Basics.md)
- [BFF 프록시 패턴](./Nextjs/BFF-proxy.md)

### Infra / Cloud

- [AWS S3와 정적 배포 구조](Infra/Cloud/AWS/AWS_S3_and_Static_Deployment.md)
- [CDN 개념과 CloudFront](Infra/Cloud/AWS/CDN_and_CloudFront_Basics.md)
- [ALB와 WebSocket 라우팅: pending 원인 분석](Infra/Cloud/AWS/ALB_WebSocket_Routing.md)

### Algorithm - Coding Test

- [자료구조 기본: 선형 vs 비선형](./Algorithm/Linear-vs-NonLinear-DataStructure.md)
- [스택과 큐 기본](./Algorithm/stack-queue.md)
- [BOJ 2667: 단지번호붙이기 BFS 풀이](./Algorithm/BOJ-2667-Connected-Components-BFS.md)
- [🌱 하루 한 문제 코딩테스트 챌린지!](https://github.com/100-hours-a-week/KTB_RAN_ALGORITHM)

## 🪶 Conference

### Toss

- [TMC25 – 인터랙션 개발 워크플로우 분석](./Conference/Toss/TMC25_Interaction_Workflow.md)

## 🌱 UX/UI

- [디자인 시스템을 언어로 이해하기](./UXUI/Design_System_Language.md)
- [Modal UI 사용 가이드 (팝업 / 바텀시트 / 스낵바)](UXUI/Modal_UI_Guidelines.md)
- [UX/UI 참고 사이트 모음](./UXUI/helperSite.md)

## Troubleshooting

- [Troubleshooting 기록 및 작성 양식](./Troubleshooting/README.md)
- [[VS Code / TypeScript] tsconfig 옵션에 빨간 줄이 표시된 이유](./Troubleshooting/01_VSCode_TypeScript_Version_Mismatch.md)

## TIL

- [2026년 11월 26일](./TIL/2026-11-26_Daily_Review.md)
- [2026년 11월 25일](./TIL/2026-11-25_Daily_Review.md)
- [2026년 11월 24일](./TIL/2026-11-24_Daily_Review.md)
- [2026년 11월 13일](./TIL/2026-11-13_React_Rendering_Interview_Practice.md)
- [2026년 11월 06일](./TIL/2026-11-06_Daily_Review.md)
- [2026년 11월 05일](./TIL/2026-11-05_Daily_Review.md)
- [2026년 11월 04일](./TIL/2026-11-04_Daily_Review.md)
- [2026년 11월 03일](./TIL/2026-11-03_Daily_Review.md)
- [2026년 11월 02일](./TIL/2026-11-02_Daily_Review.md)
- [2026년 11월 01일](./TIL/2026-11-01_Daily_Review.md)
- [2026년 10월 31일](./TIL/2026-10-31_Daily_Review.md)
- [2026년 10월 30일](./TIL/2026-10-30_Daily_Review.md)
- [2026년 10월 29일](./TIL/2026-10-29_Daily_Review.md)
- [2026년 10월 28일](./TIL/2026-10-28_Daily_Review.md)
- [2026년 10월 27일](./TIL/2026-10-27_Daily_Review.md)
- [2026년 10월 26일](./TIL/2026-10-26_Daily_Review.md)
- [2026년 10월 25일](./TIL/2026-10-25_Daily_Review.md)
- [2026년 10월 24일](./TIL/2026-10-24_Daily_Review.md)
- [2026년 10월 23일](./TIL/2026-10-23_Daily_Review.md)
- [2026년 10월 22일](./TIL/2026-10-22_Daily_Review.md)
- [2026년 10월 21일](./TIL/2026-10-21_Daily_Review.md)
- [2026년 10월 20일](./TIL/2026-10-20_Daily_Review.md)
- [2026년 10월 19일](./TIL/2026-10-19_Daily_Review.md)
- [2026년 10월 18일](./TIL/2026-10-18_Daily_Review.md)
- [2026년 10월 16일](./TIL/2026-10-16_Daily_Review.md)
- [2026년 10월 15일](./TIL/2026-10-15_Daily_Review.md)
- [2026년 10월 14일](./TIL/2026-10-14_Daily_Review.md)
- [2026년 10월 13일](./TIL/2026-10-13_Daily_Review.md)
- [2026년 10월 12일](./TIL/2026-10-12_Daily_Review.md)
- [2026년 10월 11일](./TIL/2026-10-11_Daily_Review.md)
- [2026년 10월 10일](./TIL/2026-10-10_Daily_Review.md)
- [2026년 10월 09일](./TIL/2026-10-09_Daily_Review.md)
- [2026년 10월 08일](./TIL/2026-10-08_Daily_Review.md)
- [2026년 10월 07일](./TIL/2026-10-07_Daily_Review.md)
- [2026년 10월 06일](./TIL/2026-10-06_Daily_Review.md)
- [2026년 10월 02일](./TIL/2026-10-02_Daily_Review.md)
- [2026년 10월 01일](./TIL/2026-10-01_Daily_Review.md)
- [2026년 09월 30일](./TIL/2026-09-30_Daily_Review.md)
- [2026년 09월 29일](./TIL/2026-09-29_Daily_Review.md)
- [2026년 09월 28일](./TIL/2026-09-28_Daily_Review.md)
- [2026년 09월 27일](./TIL/2026-09-27_Daily_Review.md)
- [2026년 09월 22일](./TIL/2026-09-22_Daily_Review.md)
- [2026년 09월 20일](./TIL/2026-09-20_Daily_Review.md)
- [2026년 09월 19일](./TIL/2026-09-19_Daily_Review.md)
- [2026년 09월 18일](./TIL/2026-09-18_Daily_Review.md)
- [2026년 09월 17일](./TIL/2026-09-17_Daily_Review.md)
- [2026년 09월 16일](./TIL/2026-09-16_Daily_Review.md)
- [2026년 09월 15일](./TIL/2026-09-15_Daily_Review.md)
- [2026년 09월 14일](./TIL/2026-09-14_Daily_Review.md)
- [2026년 09월 13일](./TIL/2026-09-13_Daily_Review.md)
- [2026년 07월 30일](./Project/2026-07-30.md)
- [2026년 07월 14일](./Project/2026-07-14.md)
- [2026년 07월 13일](./Project/2026-07-13.md)
- [2026년 07월 12일](./Project/2026-07-12.md)
- [2026년 07월 10일](./Project/2026-07-10.md)
- [2026년 06월 26일](./Project/2026-06-26.md)
- [2026년 06월 25일](./Project/2026-06-25.md)
- [2026년 06월 23일](./Project/2026-06-23.md)
- [2026년 06월 22일](./Project/2026-06-22.md)
- [2026년 06월 19일](./Project/2026-06-19.md)
- [2026년 06월 17일](./Project/2026-06-17.md)
- [2026년 06월 14일](./Project/2026-06-14.md)
- [2026년 06월 13일](./Project/2026-06-13.md)
- [2026년 06월 12일](./Project/2026-06-12.md)
- [2026년 06월 09일](./Project/2026-06-09.md)
- [2026년 06월 08일](./Project/2026-06-08.md)
