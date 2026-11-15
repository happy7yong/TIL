# React.memo / useCallback / useMemo

## 정의


<ul>
<li>
React.memo : <b>컴포넌트의 참조값을 비교</b>하여 렌더링 여부를 결정한다. 

<ul>
<li>
컴포넌트(몸)에 여러 참조값(영혼)이 들어왔을때 하나라도 참조값이 이전 참조값과 동일하다면 렌더링 하지 않는다. 
</li>
<li>
<b><span color="red">이전 Props와 다음 props의 얕은 비교</span></b>
</li>
</ul>
</li>
<li>
useCallback : 의존성이 달라지지 않으면 함수 자체를 이전 <b><span color="red">참조</span></b><b>를 재사용</b>한다.
</li>
<li>
useMemo : 의존성이 달라지지 않으면 <span color="red">계산한 </span><b><span color="red">값</span></b><b>을 재사용</b>한다. 
</li>
</ul>

---

- <code>React.memo</code> → 컴포넌트 렌더링을 건너뛰는 최적화
- <code>useMemo</code> → 계산 결과 값을 재사용
- <code>useCallback</code> → 함수를 재사용
  <p>
  <b>의존성이 변경되지 않으면 → 이전 함수의 참조를 재사용한다</b>
  </p>

  <p>
  참조값이 달라진다는 의미는 이전과 다른 함수 또는 객체가 생성된다 라는 말과 같은거네요
  </p>

## 특징


- <b>React.memo는 모든 props를 비교한다.</b>
  <ul>
  <li>
  알아야하는 지식 1 : 부모 컴포넌트 즉, 함수를 감싸는 컴포넌트가 렌더링되면, 그 안에 있는 모든 컴포넌트, 함수들이 리렌더링에 참여한다. 

  - 이때 함수 객체 참조값을 재사용하고 싶다.(동일한 함수가 있을때 함수자체는 같은데 다른 참조값이 만들어지는 경우, 즉 렌더링 될 경우) → useCallback
  - 이때 값을 재사용하고 싶다. → useMemo
  </li>
  </ul>

1. <code>React.memo</code>를 전혀 사용하지 않는 컴포넌트에서도 <code>useMemo</code>가 성능 개선에 도움이 될 수 있을까?
   > <b>답</b><br />useMemo는 값을 재사용하는 최적화 기법이니까 그래도 개선될수잇을것같습니다 예를 들어 복잡한 계산을 하는 경우에 부모 컴포넌트가 렌더링하게 되면 다시 복잡한계산을 해야하는데, useMemo가 있으면 계산을 하지 않아도 되기 때문에 이런경우에 성능 개선에 도움될것같습니다.

   <toggle>
   피드백 미유키 선배한테 칭찬 \^\^/

   <image source="notion-file-block://690ee90a-967f-83b7-a270-81a15fd92fb4/8ca8ab29-0165-40d9-9b69-4ea9b7ff3150?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
   </toggle>

   ```javascript
   const filteredMessages = useMemo(() => {
     return messages
       .filter(message => !message.deleted)
       .sort((a, b) => a.createdAt - b.createdAt);
   }, [messages]);
   ```

## 실제 사용 예시(사례)


1. <b>ChatRoom이 렌더링되면 Message가 렌더링 될까요?</b>
   ```javascript
   const Message = React.memo(MessageItem);

   function ChatRoom({ message }) {
     const handleClick = () => {
       console.log(message.id);
     };

     return (
       <Message
         data={message}
         onClick={handleClick}
       />
     );
   }
   ```

   <p>
   리액트는 모든 props를 비교하기 때문에, chatRoom이 렌더링될 경우, handleClick은 매순간 다른 참조값을 만들고, Message props에 새로만들어진 함수를 전달하여서 Message는 chatRoom이 렌더링이 될때마다 함께 렌더링됩니다.
   </p>

> <b>이때 함수가 불필요하게 다른 참조값을 가진 함수를 생성하는 것을 막고 싶다 → useCallback</b>

```javascript
const Message = React.memo(MessageItem);

function ChatRoom({ message }) {
  const handleClick = useCallback(() => {
    console.log(message.id);
  }, [message.id]);

  return (
    <Message
      data={message}
      onClick={handleClick}
    />
  );
}
```

useCallback은 message.id가 달라지지 않으면, 이전 참조에 사용했던 함수를 사용한다.

<b>React.memo는 props를 얕게 비교하기 때문에, 값 또는 함수가 달라지면 함께 렌더링 될 수 있따. 따라서 기존 객체를 유지하고 싶을때는 useMemo, useCallback을 사용할수있다.</b>

|  | <code>useMemo</code> | <code>useCallback</code> |
| --- | --- | --- |
| 재사용 대상 | 계산한 값 | 함수 |
| 주요 용도 | 비싼 계산 재사용, 객체 참조 안정화 | 함수 prop 참조 안정화 |

---

```javascript
const filteredMessages = useMemo(
  () => messages.filter(m => !m.deleted),
  [messages]
);
```

- <code>messages</code> 참조 유지 → 이전 <code>filteredMessages</code> 결과 재사용
- <code>messages</code> 참조 변경 → <code>filter()</code> 다시 실행
- 주의: <code>useMemo</code>는 객체를 불변으로 만들지 않아. 같은 배열을 직접 수정해도 참조가 같으면 변경을 감지하지 못할 수 있어.

<image source="notion-file-block://22dee90a-967f-8340-8c1a-01974a0df4b1/127d3fc2-d940-4149-aa1f-c299f9977c41?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

### 실제 molip에서 사용한 react memo 패턴

```javascript
const MessageItem = React.memo(({ message }) => {
  return <div>{message.content}</div>;
});

{messages.map(message => (
  <MessageItem key={message.id} message={message} />
))}
```

개별 메세지 컴포넌트(몸) ← 안에 메세지 배열의 객체(영혼 : 참조값)를 꺼내서 넣음!! 왜냐하면 이전 props와 다음 props를 얕은 비교하기 때문, 그러니 개별 메세지 컴포넌트 입장에서는 이전에 들어온 props는 알고 있기 때문에, 해당 참조값(영혼)을 받는 컴포넌트는 해당 참조값을 알고있기 때문에 렌더링하지 않는다. 새로운 참조값이 들어온 경우, 즉 새로운 메세지가 들어온 컴포넌트만 리렌더링에 참여할수있도록 한다.

<b>주의 : </b><b><code>React.memo</code></b><b>는 기본적으로 각 prop을 </b><b><code>Object.is</code></b><b>로 얕게 비교합니다. 따라서 문자열이나 숫자처럼 원시값을 전달했다면 참조값보다는 값이 달라졌는지가 중요합니다.</b>

<b>새 메시지 컴포넌트는 기존 컴포넌트의 리렌더링이라기보다 새롭게 마운트되는 것</b>

## 보조 개념 정리


---

## 회고

- 리액트에서는 상위 컴포넌트가 리렌더링이 되면 하위 컴포넌트도 리렌더링이 되니까,하위의 불필요한 렌더링을 막기 위해서, 메모이제이션을 이용한 컴포넌트 렌더링 기법이 등장한것같다.
  - 그 메모이제이션을 이용한 렌더링 최적화 기법 중 하나로, React memo는 참조값이 같으면 컴포넌트를 재사용하기한다.
    <p>
    예를 들어, newArray = \[\] 안에 \{…oldArray\} 가 들어왔을때, 기존 oldArray는 새로운 참조값이 아니기 때문에 newArray에서 받은 새로운 객체만 렌더링 할것이다.
    </p>
  - 이때, 문제점은 모든 props를 비교하기 때문에, 부모 컴포넌트에서 렌더링될때마다 함수가 생성될때, 함수를 props로 받고있는 컴포넌트는 react memo가 반영되지 않는다. 이때, 이 불필요한 함수 객체의 재 생성을 막기 위해서, 의존성 여부를 기준으로 함수 재생성을 막는 useCallback이 등장
  - useCallback은 함수 대상이기 때문에 계산한 값을 대상으로 재사용할수있도록 useMemo등장

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

