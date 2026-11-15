# Commit 단계

## 정의


## 특징


<ul>
<li>
<b>리액트의 렌더링 큰 핵심 3단계 : Trigger → Render →</b><b><span color="red"> Commit </span></b>
</li>
<li>
<b>Commit : </b>계산한 결과를 실제 화면에 반영하기

- 핵심 키워드 : DOM 변경 / useLayoutEffect / useEffect 의 실행 시점과 역할을 구분하는 것
</li>
<li>
<b>리액트는 필요한 dom만 변경한다.</b>
</li>
<li>
Commit은 리액트에서 수정할 dom을 반영하는 역할, Paint에서 사용자가 볼수있도록 브라우저에서 dom을 그리는 역할 
</li>
</ul>

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>
        증가
      </button>
    </div>
  );
}
```

<ul>
<li>
Trigger : setCount로 업데이트 한번 요청 
</li>
<li>
Render : 다음 UI를 계산하고 p태그 안의 텍스트가 바뀌어야 한다고 판단.
</li>
<li>
Commit : 기존 p dom노드를 재사용하면서 텍스트를 1로 수정
</li>
<li>
Paint : 브라우저가 갱신된 화면을 그린다.
</li>
</ul>

#### Effect 실행 시점

<ol>
<li>
Render : 컴포넌트 실행 / 다음 UI 계산
</li>
<li>
Commit : DOM 변경, 필요한 DOM노드 수정, 제거, 삽입
</li>
<li>
useLayoutEffect : DOM변경후 동기적으로 실행
</li>
<li>
(Paint)Browser Paint : 브라우저가 갱신된 UI를 화면에 그림 
</li>
<li>
useEffect : 일반적으로 Paint 이후 실행.
</li>
</ol>

<ul>
<li>
useLayoutEffect : dom요소의 크기를 측정하고 위치를 조정하는 작업 

<ul>
<li>
예시 : 버튼의 툴팁이 화면에 그려지기 전에, 툴팁의 위치를 계산해야 화면 밖으로 나가지 않도록할수있다. 그 과정을 useLayoutEffect에서 그린다. 
</li>
</ul>
</li>
<li>
useEffect : 외부시스템과 동기화하는 작업, 
</li>
</ul>

## 실제 사용 예시(사례)


## 보조 개념 정리


---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

