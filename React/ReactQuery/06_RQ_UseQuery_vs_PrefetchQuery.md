# useQuery vs prefetchQuery

## 정의

- useQuery는 컴포넌트에서 데이터를 사용하는 tanstack query입니다.
- prefetchQuery는 데이터를 미리 준비하는 tanstaack query입니다.

## 특징

|  | <code>useQuery</code> | <code>prefetchQuery</code> |
| --- | --- | --- |
| 목적 | 컴포넌트에서 데이터 사용 | 데이터를 미리 준비 |
| 사용 위치 | React 컴포넌트 내부 | 서버 또는 클라이언트의 사전 준비 코드 |
| 데이터 요청 | 필요하면 요청 | 캐시 상태에 따라 미리 요청 |
| UI 갱신 | 데이터 상태를 구독해 리렌더링 | 직접 UI를 구독하거나 갱신하지 않음 |

1. <b>서버: prefetchQuery (데이터를 미리 가져와 서버 캐시에 저장)</b>
2. <b>HydrationBoundary (서버 캐시 데이터를 브라우저 캐시에 전달·복원)</b>
3. <b>브라우저: useQuery (준비된 캐시 데이터를 읽고 화면에 사용)</b>

useQuery는 데이터의 캐시를 확인하고 가져오는 역할이다.

→ prefetchQuery가 없으면, useQuery가 api 호출한다

<p>
→ prefetchQuery가 있으면, 서버에서 prefetchQuery로부터 미리 저장한 캐시에서 데이터를 hydrationBoundary를 통해 서버캐시를 브라우저캐시로 복원하고 useQuery로 가져온다.

- 같은 Query Key로 미리 가져온 데이터를 직렬화하고 브라우저 캐시에 복원
</p>

## 실제 사용 예시(사례)

- useQuery
  ```ts
  "use client";

  function Home() {
    const { data, isPending } = useQuery({
      queryKey: ["schedule"],
      queryFn: fetchSchedule,
    });

    if (isPending) return <p>로딩 중...</p>;

    return <p>{data.title}</p>;
  }
  ```

  <p>
  일반적인 TanStack Query v5의 useQuery 사용 방식에서는 서버가 초기 HTML을 만들 때 캐시에 데이터가 없다면 <b>로딩 상태를 렌더링</b>하고, 실제 데이터 요청은 브라우저에서 시작한다.
  </p>

  - 서버에서 : home()실행 → useQuery() 실행 → 쿼리키에 캐시 없음 → 로딩상태 렌더링
  - 브라우저 : home()실행/하이드레이션 → useQuery() 실행 → api 요청 시작 → 데이터 도착 → ui 갱신
    <quote>
    <b>왜? api 호출 코드가 useEffect에 있는것도 아닌데, fetch함수를 따로 뒀을텐데? </b>

    1. <b>함수 전달 코드가 다르다.</b>
       ```txt
       queryFn: fetchSchedule    // 함수를 전달
       queryFn: fetchSchedule()  // 함수를 즉시 실행
       ```

       <p>
       <code>fetchSchedule</code>이라는 함수를 TanStack Query에 넘겨준다. 실제로 언제 실행할지는 TanStack Query가 결정한다.
       </p>
    2. <b>TanStack Query는 왜 서버에서 요청하지 않을까?</b>
       <p>
       useQuery는 react의 컴포넌트 상태를 관찰(observer)하는 hook이다. 컴포넌트가 마운트되어 query observer(컴포넌트 상태 구독)가 구독하는 과정에서 필요한 요청을 하지만, 서버에는 <b>컴포넌트를 구독하고유지(query observer)</b>하는 과정이 없다.
       </p>

       - <b>서버 렌더링 </b>: home() 실행 → useQuery()실행 → 캐시확인(데이터없음) → 로딩실행
       - <b>브라우저 렌더링 </b>: Home()실행 → useQuery() 실행 → query observer 구독 → queryFn 실행 / api 요청 → 캐시 저장

       <p>
       <b><span color="red">서버 렌더링에서는 컴포넌트를 실행해 초기 HTML을 생성하지만, 브라우저처럼 DOM에 마운트하거나 Effect를 실행하고 구독을 유지하는 과정은 없습니다.</span></b>
       </p>

    <b>라이브러리 내부에서 </b><b><span color="blue">렌더링</span></b><b>과 </b><b><span color="blue">실제 요청 시작 시점을 분리</span></b><b>해 관리</b>
    </quote>

## 보조 개념 정리


---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

