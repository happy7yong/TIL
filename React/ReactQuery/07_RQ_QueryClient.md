# queryClient

## 정의


<p>
queryClient : 캐시를 저장할 수 있는 클라이언트 
</p>

## 특징


#### new QueryClient() vs useQuery()

|  | <code>new QueryClient()</code> | <code>useQuery()</code> |
| --- | --- | --- |
| 역할 | <b>캐시를 관리하는 클라이언트 생성</b> | <b>데이터 조회 및 구독</b> |
| 하는 일 | QueryCache 등 관리 | 캐시 확인, 필요 시 fetch, 상태 구독 |
| 사용 위치 | 보통 앱 설정 및 Provider | React 컴포넌트 또는 커스텀 Hook |

<ul>
<li>
<b>new QueryClient()</b>는 현재 실행 환경 메모리에 새로운 QueryClient 객체를 생성하는 코드이다.  

```javascript
'use client';

function makeQueryClient() {
  return new QueryClient();
}
```

<p>
use client이기 때문에 서버에서도 실행되고, 클라이언트에서도 실행된다. 
</p>

- <b>서버에서 실행될 경우 </b>→ 서버 메모리에 객체A 생성
- <b>브라우저에서 실행될 경우 </b>→ 브라우저 메모리에 객체B 생성
  <ul>
  <li>
  객체A와 B는 서로 다른 인스턴스이며 메모리를 공유하지 않는다. 
  </li>
  </ul>
</li>
</ul>

- <b>서버에서 </b><b><code>prefetchQuery</code></b><b>로 데이터를 캐싱했는데 </b><b><code>HydrationBoundary</code></b><b>를 사용하지 않았다면, 브라우저의 </b><b><code>useQuery</code></b><b>는 그 데이터를 바로 사용할 수 있을까?</b>
  - <code>dehydrate(queryClient)</code>: 서버 QueryClient에 저장된<b><span color="yellow_bg"> 캐시를</span></b> <b><span color="yellow_bg">전달 가능한 상태로 추출</span></b>해.
  - <code>HydrationBoundary</code>: 전달받은 캐시 상태를 클라이언트의 QueryClient에 <b><span color="yellow_bg">복원</span></b>해.
  - <code>QueryClientProvider</code>: <code>useQuery</code>가 사용할 QueryClient 인스턴스를 제공해.
    <p>
    → useQuery가 사용하는 인스턴스 ≠ 서버 queryClient 
    </p>

#### useQuery() 호출 시 순서

<ol>
<li>
QueryClient에 접근 → queryKey에 해당하는 캐시 확인 → 캐시상태와 설정에 따라 fetch → 컴포넌트가 쿼리 상태 구독 → 데이터 상태 변경 시 필요한 리렌더링 
</li>
</ol>

<h3>
refetchOnMount에 대해 
</h3>

| 설정 | 마운트 시 동작 |
| --- | --- |
| <code>refetchOnMount: true</code> | stale이면 재요청 |
| <code>refetchOnMount: false</code> | 마운트 때문에 재요청하지 않음 |
| <code>refetchOnMount: 'always'</code> | 일반적으로 신선도와 관계없이 재요청 |

## 실제 사용 예시(사례)


Next.js + TanStack Query

```javascript
// Server Component
export default async function Page() {
  const queryClient = new QueryClient();

  await queryClient.prefetchQuery({
    queryKey: ['todos'],
    queryFn: fetchTodos,
  });

  return (
    <HydrationBoundary state={dehydrate(queryClient)}>
      <TodoList />
    </HydrationBoundary>
  );
}
```

```javascript
'use client';

// Client Component
function TodoList() {
  const { data } = useQuery({
    queryKey: ['todos'],
    queryFn: fetchTodos,
  });

  return <div>{data?.length}개</div>;
}
```

서버의 queryClient와 브라우저의 useQuery가 사용하는 queryClient가 다른객체이다. 브라우저쪽(use client) 인스턴스는 QueryClientProvider에서 제공한다.

<p>
그래서, <b>서버의 캐시를 직렬화 해서 클라이언트로 전달하는 과정</b>이 필요하다. 거기서 dehydrate 가 직렬화, hydrationBoundary가 클라이언트로 전달한다. 
</p>

## 보조 개념 정리


<ul>
<li>
인스턴스 
</li>
</ul>

---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

