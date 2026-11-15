# gcTime, staleTime

## 정의


<p>
gcTime : 사용하지 않는 데이터를 메모리에 얼마나 살려둘지 
</p>

<p>
staleTime : 데이터가 얼마나 오래 신선한지 
</p>

|  | <code>staleTime</code> | <code>gcTime</code> |
| --- | --- | --- |
| 의미 | 데이터를 신선하다고 판단하는 시간 | <b>비활성 캐시를 보관하는 시간</b> |
| 기준 시점 | 데이터가 갱신된 시점 | 마지막 구독자가 사라져 비활성화된 시점 |
| 시간이 지나면 | Fresh → Stale | 캐시 삭제 대상 |
| 데이터 삭제? | 아니요 | 네, 비활성 상태가 지속되면 |
| 기본값 (v5, 브라우저) | <code>0ms</code> | <code>5분</code> |

## 특징


<ul>
<li>
staleTime은 시간이 지나면 데이터는 남아있지만 오래된 stale 데이터라고 생각한다.
</li>
<li>
gcTime은 시간이 지나면 사용하지 않는 데이터일 경우 데이터가 삭제된다. 
</li>
</ul>

- <b>staleTime을 5분 설정해뒀을때 api가 아예 발생하지 않는건가요?</b>
  - Mutation이 발생했다고 자동으로 재요청되는 건 아닙니다. Mutation 성공 후 <code>invalidateQueries()</code>를 호출하거나 명시적으로 refetch하는 등의 처리가 필요합니다.
- stale 되었다고 바로 fetch 하나?
  - staleTime이 완료되었다는 사실만으로 api 를 요청하지 않는다
  - 보통 다음과 같은 상황에서 stale 데이터를 자동으로 다시 가져올 수 있다.
    - 컴포넌트가 새로 마운트될 때 (<code>refetchOnMount</code>)
    - 브라우저 창으로 다시 돌아올 때 (<code>refetchOnWindowFocus</code>)
    - 네트워크가 다시 연결될 때 (<code>refetchOnReconnect</code>)
- <code>invalidateQueries()</code>나 명시적인 <code>refetch()</code>를 사용하면 신선도와 별개로 재요청을 유도
  - 무효화(invalidate)와 refetch(재요청)

## 실제 사용 예시(사례)


```javascript
useQuery({
  queryKey: ['todos'],
  queryFn: fetchTodos,
  staleTime: 60_000,   // 1분
  gcTime: 300_000,     // 5분
});
```

## 보조 개념 정리


---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

