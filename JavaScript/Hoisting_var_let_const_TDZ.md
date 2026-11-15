# 호이스팅과 var / let / const TDZ

<callout icon="📌">
<p>
호이스팅의 동작 원리를 실행컨텍스트 생성단계와 연결하여 설명하고, var/let/const의 호스팅 차이와 TDZ에 대해 설명
</p>
</callout>

### 키워드

- <b>호이스팅</b>
- <b>TDZ</b>
- <b>실행 컨텍스트</b>
- <b>환경 레코드</b>

### 스코프( 범위 )

<callout icon="💡" color="gray_bg">
<b>변수나 함수의 유효 범위</b>

→ 렉시컬 스코프 규칙에 따른다
</callout>

<toggle color="gray_bg">
<b>렉시컬 스코프(=정적 스코프)</b>

<p>
<b><u>변수가 선언된 위치</u></b>에 따라 접근 가능 범위가 결정(달라지는)되는것
</p>
</toggle>

- 전역 스코프
  - <b>global scope : </b>전역 범위
- 로컬 스코프
  <ul>
  <li>
  <b>function scope(var) </b>: 함수 범위 - 함수 스코프

  <ul>
  <li>
  <b>범위 : 함수 안</b>에서만 변수를 지정
  </li>
  <li>
  <b>var은 중복선언</b>이 가능함
  </li>
  </ul>

  ```javascript
  function test() {
    var a = 10;
  }
  console.log(a); // ❌ 에러 (함수 밖이라서)
  ```
  </li>
  <li>
  <b>code block Scope (let, const ) :</b> 블록 범위 - 블록 스코프

  - 범위 : 함수가 아닌 블록 안에서만
  - <b>const, let은 중복선언</b>이 안됨 .

  ```javascript
  if (true) {
    var x = 5;
  }
  console.log(x); // ✅ 5 (블록 무시됨)
  ```
  </li>
  </ul>

---

## 실행 컨텍스트

<quote>
<b>실행 컨텍스트(=실행공간)</b>

코드를 실행시키기 위해 필요한 모든 정보를 담고 있는 실행 환경 (정보 묶음)
</quote>

1. <b><span color="blue">전역 실행 컨텍스트 (Global Execution Context)</span></b>
   - JS 파일을 처음 로드할 때 최초 1개 생성
   - 코드를 감싸는 최상위 컨텍스트
2. <b>함수 실행 컨텍스트 (Function Execution Context)</b>
   - <b><span color="red">함수</span></b>가 <b>호출될 때마다</b> 새로 생성
   - <span color="gray">매개변수, 지역 변수, 내부 함수, </span><span color="gray"><code>this</code></span><span color="gray"> </span>등이 여기에 포함됨

| 구분 | 전역 실행 컨텍스트 | 함수 실행 컨텍스트 |
| --- | --- | --- |
| 생성 시점 | JS 파일 실행 시 1번 | 함수 호출될 때마다 |
| 개수 | 1개 | 여러 개 가능 |
| 포함 내용 | 전역 변수, 함수 | 매개변수, 지역 변수 |
| 생명 주기 | 프로그램 끝날 때까지 | 함수 실행 끝나면 사라짐 |

<b>실행 컨텍스트(단위)</b>들은<span color="red"> </span><b><span color="red">콜 스택(Call Stack)</span></b><b>(</b><b><span color="green">자바스크립트의 메인/싱글 스레드 담당</span></b><b>)</b>에 쌓였다가, 맨 위의 컨텍스트가 끝나면 스택에서 빠지고, 그 아래 컨텍스트로 돌아가는 구조

<image source="notion-file-block://3cfee90a-967f-80e7-bb44-c1d4b204b376/63245582-9120-4304-baa8-0f5ab1238c67?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

---

<h2>
실행 컨텍스트(=코드 실행 환경) 객체 내부
</h2>

<ol>
<li color="green_bg">
<b>Lexical Environment (렉시컬 환경)</b>

- <code>let</code>, <code>const</code>, 함수 선언, <code>class</code> 등 <b>블록/함수 스코프 변수를 관리</b>하는 공간
- “이 이름이 어떤 값을 가리키지?” 할 때 찾아보는 일종의 환경 지도
- <b><span color="green">렉시컬 환경 : 정보 꾸러미</span></b><b><span color="green"><u> 메타데이터</u></span></b>

<p>
1-1. <b>Environment Record (환경 레코드)</b>

<b><span color="red">식별자 이름 / 값 상태가 저장됨. (호이스팅)</span></b>
</p>

<p color="blue_bg">
<b>1-2. Outer Environment Reference(외부 환경 참조)</b>

<ul>
<li>
“바깥 스코프에 대한 참조”

- → <b>스코프 체인</b>의 원초적인 동작 및 <b>클로저 동작</b>의 근거가 되는 연결
</li>
</ul>
</p>
</li>
<li color="gray_bg">
<b><span color="gray">Variable Environment (변수 환경)</span></b>

- <span color="gray">원래는 </span><span color="gray"><code>var</code></span><span color="gray"> 선언을 주로 관리하던 환경</span>
- <span color="gray">최신 엔진에서는 Lexical Env와 합쳐서 취급하지만, 명세상 </span><b><span color="gray">개념은 분리됨</span></b>
</li>
<li color="purple_bg">
<b>this 바인딩</b>

- 그 컨텍스트에서 <code>this</code>가 무엇인지 (<code>window</code>, 어떤 객체 인스턴스 등)
</li>
</ol>

> <b>실행컨텍스트 내부 구조</b>

```javascript
실행 컨텍스트
├── Lexical Environment
│   ├── Environment Record       ← 변수/함수 식별자 저장
│   └── Outer Environment Reference  ← 바깥 스코프 참조
├── Variable Environment
│   ├── Environment Record
│   └── Outer Environment Reference
└── This Binding
```

---

## 실행 컨텍스트 생성 과정

1. <b>Creation Phase (생성 단계) : </b><b><u>실행 전, 준비단계</u></b>
   - 실행 컨텍스트를 만들고
   - <b>변수/함수 선언을 먼저 스캔</b>해서 <b><span color="blue">환경 레코드</span></b>에 등록 → 이때 <b><span color="red">호이스팅</span></b>이 발생
   - <b>전역 컨텍스트 안에 들어가는 과정 \<\< </b>

   2. <b>Execution Phase (실행 단계)</b>
   - 이제 실제로 한 줄씩 실행
   - <code>=</code> 할당, <code>함수 호출</code>, 연산 등 로직 수행

<b>\[ 변수에 대한 정보를 찾는 구조적 단계 \]</b>

<b>1. 현재 Lexical Environment(렉시컬 환경) 안의 Environment Record(환경 레코드)에서 찾음 </b><span color="red">→ 없으면</span>

<b>2. Outer Lexical Environment (바깥 환경)으로 이동해서 다시 찾음</b>

### 호이스팅

변수와 함수가 초기화 되기 이전에 <b>메모리 상으로 먼저 올라가있는 현상</b>

<b><u>→ 애플리케이션이 실행될 때 </u></b><b><span color="blue"><u>실행 컨텍스트 렉시컬 환경</u></span></b><b><u>의</u></b><b><span color="blue"><u> 환경 레코드</u></span></b><b><u>에 변수가 저장되는 단계</u></b>

## <b>⭐️ var, let/const, function 호이스팅 차이</b>

---

### ◻️ function

<b>💡 function 키워드 함수</b>는 <b><span color="orange">선언</span></b><b><span color="yellow_bg">과 </span></b><b><span color="orange">초기화</span></b><b><span color="yellow_bg">, </span></b><b><span color="orange">할당 단계</span></b><b><span color="yellow_bg">가 내부적으로 동시에 </span></b>진행

```javascript
foo(); // 여기서도 호출 가능 -> foo : 선언 및 초기화 동시에 진행

function foo() {
  console.log("hi");
}
```

- <b>생성단계(Creation Phase):</b>
  - <u><code>foo</code></u><u> 라는 식별자를 </u><b><span color="blue"><u>환경 레코드</u></span></b><b><u>에 등록(호이스팅)</u></b>
  - <code>foo</code> 에 <b>함수 </b><b><span color="red">객체 자체를 바로 할당(초기값 : 객체 할당)</span></b>
    <p>
    → 그래서 실행단계(Execution Phase) 들어가기 전부터 <code>foo</code>는 “완전히 초기화된 함수”
    </p>

function는 <b><u>선언과 초기화 모두 호이스팅</u></b>이 된다.

때문에, 함수는 초기화 전에 호출해도 정상적으로 호출이 가능하다.

---

### ◻️ var

<b>💡 var은 변수 선언은 하지만</b><b><span color="yellow_bg"> undefined를 초기값으로 갖는다.</span></b>

```javascript
console.log(num); //undefined
var num = 10;
console.log(num); //10
```

- <b>생성단계(Creation Phase):</b>
  - <u><code>num </code></u><u>라는 식별자를</u><b><u> </u></b><b><span color="blue"><u>환경 레코드</u></span></b><b><u>에 등록(호이스팅)</u></b>
  - num의 초기값을<b> </b><b><span color="red">undefined</span></b>를 넣어둠.<b><span color="red">(초기값 : undefined)</span></b>
- <b>실행단계(Execution Phase)</b>
  <ul>
  <li>
  console.log(num) 은 이미 num이 존재하지만 undefined인 상태
  </li>
  <li>
  이후 라인 2에서 num 값 할당
  </li>
  </ul>

> <b>동작 과정</b>

```javascript
console.log(num);
var num = 10;
```

내부적으로 아래와 같은 경우로 진행딤.

```javascript
var num; //<- 환경 레코드에 식별자 저장 및 undefined
console.log(num)
num=10;
```

---

<h3>
◻️ let / const
</h3>

<b>💡let/const는 변수 선언은 하지만 </b><b><span color="yellow_bg">초기화되지 않은 상태를 갖는다.</span></b>

```javascript
console.log(num); //ReferenceError
let num = 10;
```

- <b>생성단계(Creation Phase):</b>
  - <u><code>num </code></u><u>라는 식별자를</u><b><u> 환경 레코드에 등록(호이스팅)</u></b>
  - num의 초기값을<b> </b><b><span color="red">uninitialized(초기화되지 않은 상태)</span></b>
    - <b><span color="red">TDZ(Temporal Dead Zone) : 일시적 사각지대</span></b><b> </b>
      - <b>일시적 사각지대에 포함되어있는 변수를 사용하지 못하도록 막았다고 함.</b>
        <p>
        → <b>코드의 예측 가능성</b>을 높이기 위해<b> TDZ라는 개념을 도입</b> : var 때문
        </p>
- <b>실행단계(Execution Phase)</b>
  <ul>
  <li>
  let num = 10; 도달 시 값 할당 이 된다. num : 10
  </li>
  </ul>

  <p>
  → 값이 할당되기이전에 접근 시 referenceError : TDZ 발생
  </p>

> <b>테스트</b>

```javascript
console.log(num);
let num = 10;
console.log(num);
```

<image source="notion-file-block://3cfee90a-967f-80fb-8180-cdd7291efe94/08b6e5fd-135e-44b8-bfb5-3e2f89bdbccb?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<s><i><span color="gray">TMI : vanila JS 과제하면서 TDZ 진짜 많이 만났습니다..\^\^이제는 안만나면 서운해요 </span></i></s>

호이스팅은 무조건 적으로 처음 진행됨!

<p>
→ <b><span color="yellow_bg">호이스팅 현상으로 인해서 초기화되지 않은 상태의 변수를 참조할 수 없도록</span></b> 하기 위해 초기화 전에 접근할 수 없도록 막아둠
</p>

→ 초기화 되기 이전에 접근할 수 있는 것 자체가 이상함

실제로 <b>var의 호이스팅 현상(undefined)</b>은 자바스크립트 개발과정에서 실수로 생긴 일종의 버그라고 합니다

<s>마인크래프트에서 지옥문 타고 지옥갈 때 발생하는 멀미효과 버그 같은 것</s>

<image source="notion-file-block://3cfee90a-967f-8009-9e3a-fabee6d88bb3/b611be8f-0f76-48b9-9e43-6a8d3af16de1?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<callout icon="💡">
<b>실제 JS 개발자 \<브랜든 아이크> 왈</b>

var hoisting was thus unintended consequence of function hoisting, no block scope, JS as a 1995 rush job. ES6 'let' may help.<br /><br />

호이스팅은 <b><span color="yellow_bg">함수 호이스팅의 의도치 않은 결과물(unintended consequence)</span></b><b> </b>이었습니다.

블록 스코프(block scope)가 없던 1995년 급하게 만들어진(JS as a 1995 rush job) 자바스크립트에서는 어쩔 수 없었죠. ES6의 <code>let</code>이 이 문제를 해결해줄 수 있을 거예요.
</callout>

<callout icon="🙂" color="gray_bg">
<b>요약 : 버그니까 let 만 쓰쇼</b>
</callout>

<h3>
🎉 function , var , let/const 정리
</h3>

| 구분 | <b>function 선언문</b> | <b>var</b> | <b>let / const</b> |
| --- | --- | --- | --- |
| <b>호이스팅 종류</b> | 선언 + 초기화(함수 객체까지) | 선언 +<b><span color="red"> undefined 초기화</span></b> | 선언만 |
| <b>초기값</b> | 함수 객체 | <b><span color="red">undefined </span></b> | 초기화 전: <b><span color="red">uninitialized </span></b>(TDZ)  초기화 후: 개발자 할당 값 |
| <b>호출/참조 가능 시점</b> | 선언 이전에도 호출 가능 | 선언 이전에도 참조 가능(단, 값은 undefined) | 선언 이전 <b>참조 불가 → </b><b><span color="red"><u>ReferenceError (TDZ)</u></span></b> |
| <b>스코프</b> | 함수 스코프 | 함수 스코프 | <b><span color="blue">블록 스코프</span></b> |
| <b>중복 선언</b> | 허용 안 됨(같은 스코프에서 중복 선언 시 SyntaxError) | <b>허용됨</b> | 허용 안 됨 |
| <b>재할당</b> | 함수 자체 재할당 가능 | 재할당 가능 | <b>let: 가능 / const: 불가능</b> |

---

## 실행 컨텍스트와 호이스팅 전체 흐름

```javascript
var a = 1;

function foo() { //
  console.log(a, b); // ?
  var a = 2;
  let b = 3;
}

foo();

```

<image source="notion-file-block://3cfee90a-967f-80b4-ab58-d1eb8a3fd2e2/3e426883-8985-493d-9a8c-5fa7b77ddef4?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=IMG_3E7B5DA43AD2-1.jpeg" />

<b>가장 먼저 root 스코프를 확인한다.</b>

1. <b>전역 실행 컨텍스트를 </b><b><span color="blue_bg">(1) call stack 에 push</span></b>
   1. 생성 단계
      <p>
      1\. 전역 <b>환경 레코드에 등록(호이스팅)</b>

      - <code>var a</code> → \{ name: "a", value: <code>undefined</code> \}
      - <code>function foo</code> → \{ name: "foo", value: \[함수 객체\] \}
      </p>
   <ol type="a" start="2">
   <li>
   실행 단계

   1\. a = 1;

   2. <b><span color="blue">foo() 호출 : </span></b><b>새로운 함수 실행 컨텍스트 생성하여</b><b><span color="blue_bg"> (2) call stack에 push</span></b>
   </li>
   </ol>

2. <b><span color="blue">foo() 함수</span></b> 실행 컨텍스트
   ```javascript
   function foo() {
     console.log(a, b);
     var a = 2;
     let b = 3;
   }
   ```

   <ol type="a">
   <li>
   <b>생성 단계</b>

   <p>
   1.var a → 함수 환경 레코드에 생성 (호이스팅)

   \{ name: "a", value: <code>undefined</code> \} 로 등록
   </p>

   2.let b → 함수 환경 레코드에 생성 (호이스팅)

   - \{ name: "b", 상태: <code>uninitialized</code> \} 로 등록<b><span color="red"> (TDZ)</span></b>
   </li>
   </ol>
   2. <b>실행 단계</b>
      <p>
      함수를 한 줄씩 실행
      </p>

      1. <code>console.log(a, b);</code>
         - <code>a</code> : 이 <b>컨텍스트에</b> 이미 있음, 값은 <code>undefined</code>
         - <code>b</code> : 선언은 되어 있지만 <b><span color="red">TDZ(uninitialized)</span></b><b>라서 아직 초기화 전</b>

         <p>
         → <code>b</code>를 읽는 순간 <b><span color="red"><u>ReferenceError(TDZ)</u></span></b>
         </p>


   ### 구조도로 이해하기

---

<h1>
결론
</h1>

<h3>
호이스팅과 TDZ 의 관계
</h3>

- <b><span color="blue">호이스팅</span></b>은 실행 컨텍스트에 환경 레코드에 필수적으로 변수를 저장하는 특징 때문에 <b><span color="blue">자연스럽게 </span></b>발생하는 현상
- 하지만 <code>var</code> 키워드는 <b>호이스팅 + 즉시 undefined 초기화</b> 때문에 “선언 전에 접근해도 에러가 안 나는” <b><span color="blue">비직관적인 동작</span></b><b>이 존재</b>

```javascript
console.log(x); // undefined //이딴게 에러가 안뜬다고?
var x = 10;
```

<image source="notion-file-block://3cfee90a-967f-8048-ba7c-e7e7c4e01dc7/e683a890-dd29-4535-b358-514b207907bf?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

- ES6에서 let과 const가 등장할 때, <span color="blue">“</span><b><span color="blue">호이스팅은 언어 스펙상 없앨 수 없지만, 버그성 동작은 막자.</span></b>” 라는 철학으로 →<span color="red"> </span><i><b><span color="red"><u>TDZ(Temporal Dead Zone)</u></span></b></i>가 등장

<callout icon="🙂" color="gray_bg">
TDZ는 <b><span color="red">var 호이스팅의 부작용을 막기 위한 안전장치</span></b>
</callout>

---

# 레퍼런스

[프론트엔드 개발자 면접 단골 질문 8 \| 자바스크립트 호이스팅](https://youtu.be/9I1dzg20r1g?si=HaxggK9FtolsCGs4)

[프론트엔드 개발자 면접 단골 질문 9 \| 화살표 함수와 function 키워드의 차이점](https://www.youtube.com/watch?v=eDcaBeaOrqI)

[자바스크립트 - Var Let Const 차이 완벽정리 (스코프, 호이스팅)](https://youtu.be/_zMVlKxmWHg?si=hAMBfYb76_wvQVZe)

[자바스크립트 실행 컨텍스트](https://junilhwang.github.io/TIL/Javascript/Domain/Execution-Context/#_1-%E1%84%80%E1%85%A2%E1%84%82%E1%85%A7%E1%86%B7)
