# Object.is

## 정의


- object.is란?
  <ul>
  <li>
  객체의 참조가 동일한지 비교하는 함수입니다. 
  </li>
  </ul>

  <p> </p>

## 특징


- [object.is](http://object.is) 는 같은 객체를 참조하고 있는지 확인하는 함수이다.

```javascript
// 원시값 비교
Object.is(10, 10); // true
Object.is("A", "A"); // true

// 객체 비교
const a = { id: 1 };
const b = { id: 1 };
const c = a;

Object.is(a, b); // false
Object.is(a, c); // true
```

<ul>
<li>
a와 b가 다른 이유 : 객체의 참조값이 다르기 때문이다. 
</li>
<li>
a와 c가 같은 이유 : 동일한 객체를 참조하고 있기 때문이다. 

<ul>
<li>
참조라는 건 가리키다. 
</li>
<li>
객체는 힙에 저장되고, 주솟값은 스택에서 가리킨다. 
</li>
</ul>
</li>
</ul>

## 실제 사용 예시(사례)


```javascript
const a = { roomId: "A" };
const b = a;

b.roomId = "B";

console.log(Object.is(a, b)); // ?
```

<ul>
<li>
true 이다. 

<ul>
<li>
이유 : 같은 객체를 참조하고 있기 때문이다. 
</li>
</ul>
</li>
</ul>

## 보조 개념 정리


---

## 회고

## 궁금한 내용

## 피드백

<ol>
<li></li>
</ol>

