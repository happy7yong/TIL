# DOM이란 무엇인가요

### DOM이란 무엇인가요? : 문서 객체(트리) 모델

<image source="notion-file-block://3cfee90a-967f-80fd-9709-c4101830f6d1/55fdc857-3c51-4cb4-a19a-1fa9b09d14e2?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<callout icon="📌" color="gray_bg">
> The DOM connects web pages to scripts or programming languages”

웹 페이지를 스크립트/프로그래밍 언어와 연결한다
</callout>

<image source="notion-file-block://3cfee90a-967f-8021-aa04-f91b1c8f4e18/50baf9d1-1f20-4e12-8219-cd11d15ce6b5?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=%E1%84%86%E1%85%A7%E1%86%AB%E1%84%8C%E1%85%A5%E1%86%B8.jpeg" />

- <b>마크업 언어로 작성</b>된 문서를 <b>자바스크립트가 조작</b>할수있도록 하는 인터페이스
  <callout icon="❓" color="green_bg">
  <b>HTML이 아니라 마크업 언어인 이유</b>

  마크업 언어 : html, xml

  DOM자체가 html전용이 아님.

  DOM은 초기에 xml  문서를 조작하기 위한 인터페이스였음.

  ```xml
  <user>
    <name>Kim</name>
  </user>
  ```

  ```javascript
  xmlDoc.querySelector("name").textContent
  ```
  </callout>

  <callout icon="❓" color="green_bg">
  <b>html 의 추출물이 dom이 아닌가?</b>

  - dom은 <b>html,xml 등을 조작하기 위한 인터페이스</b>이다.
  - html → 브라우저가 분석 / 파싱 → dom 생성
  </callout>

  - DOM : 계층 구조를 가진 노드 트리

### DOM이 필요한 이유

<callout icon="📌" color="brown_bg">
<p>
마크업 언어에는 자바스크립트가 요소에 접근 가능한 인터페이스가 없기 때문
</p>
</callout>

- 동적인 <b>웹 페이지</b>를 구현하기 위해서는 자바스크립트 언어와 같은 프로그래밍 언어가 문서(html)를 조작할 수 있는 수단이 필요하다.
  - 마크업 언어에는 그런 수단이 없다.
  - 때문에 문서에 접근할 수 있는 dom이 필요하다.

```javascript
document.getElementById("title").textContent = "Hi";
```

이러한 js 는 htm이 아닌 dom을 향한 외침이다.

<b>전체 동작 방식</b>

1. html은 문자열 문서다. (=템플릿 리터럴 생각하면 쉬울 듯)
   ```javascript
   <h1 id="title">Hello</h1>
   ```
2. 브라우저가 파싱하고 / 객체 트리 형태로 메모리에 저장
   ```javascript
   {
     tagName: "H1",
     textContent: "Hello"
   }
   ```
3. JS는 수정하는 것.
   ```javascript
   document.getElementById("title").textContent = "Hi";
   ```

### DOM을 통해 어떤 동작을 할수있는지 예시

<ul>
<li>
요소 이벤트 핸들러 추가
</li>
<li>
요소를 추가 삭제 수정 할 수 있다.
</li>
</ul>

### DOM은 왜 계층적 구조(=트리)일까요?

<callout icon="📌" color="gray_bg">
<p>
노드 관계를 명확히 정의, 이벤트 처리에 유리한 구조이다.
</p>
</callout>

- 부모 자식 형제들간의 노드가 명확히 표현됨.
- 노드의 추가 삭제 수정을 쉽게 할 수 있다.
- 이벤트 처리 (이벤트 버블링, 이벤트 캡처링)은 계층적 구조에서 효율적으로 동작하기 때문에 계층적 구조로 표현
