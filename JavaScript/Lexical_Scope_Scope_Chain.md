# 렉시컬 스코프와 스코프 체인

<callout icon="📌">
스코프 체인과 렉시컬 스코프의 개념
</callout>

### 키워드

<ul>
<li>
스코프 체인
</li>
<li>
OuterEnviroment
</li>
<li>
렉시컬 스코프
</li>
<li>
클로저
</li>
</ul>

# 변수가 참조되는 과정

현재 <b><span color="red">환경 레코드</span></b>에서 찾음(<b><span color="red">호이스팅</span></b><b>)</b> → 없으면<b> </b><b><span color="red">외부 렉시컬 환경</span></b><span color="red"> </span>참조를 통해 상위 스코프를 참조함

→이 과정을 <b><span color="blue">스코프 체인</span></b>이라고 함

### 렉시컬 스코프(=정적 스코프)

<ul>
<li>
변수를 선언한 위치에 따라 변수를 사용할 수 있는 범위가 달라지는 매커니즘

<p>
변수의 유효 범위가 달라짐
</p>
</li>
</ul>

> <b>특징</b>

- A내부에 선언된 변수를 B에서 참조할 수 없고, B 내부에서 선언된 변수를 A에서 참조할 수 없다.
- 함수가 중첩된 경우 내부 함수는 외부 함수의 변수를 참조할 수 있음.
- 외부함수는 내부 함수의 변수를 참조할 수없음.

---

### 스코프( 범위 )

<callout icon="💡" color="gray_bg">
<b>변수나 함수의 유효 범위</b>

→ 렉시컬 스코프 규칙에 따른다
</callout>

<toggle color="gray_bg">
<b>렉시컬 스코프(=정적 스코프)</b>

<p>
<b><u>변수가 선언된 위치</u></b>에 따라 접근 가능 범위가 결정되는것
</p>
</toggle>

- 전역 스코프
  - <b>global scope : </b>전역 범위
- 로컬 스코프
  <ul>
  <li>
  <b>function scope(var) </b>: 함수 범위 - 함수 스코프

  <b>함수 안</b>에서만 변수를 지정

  <p>
  <b>var은 중복선언</b>이 가능함
  </p>
  </li>
  <li>
  <b>code block Scope (let, const ) :</b> 블록 범위 - 블록 스코프

  함수가 아닌 블록 안에서만

  <b>const, let은 중복선언</b>이 안됨 .
  </li>
  </ul>

<h2>
실행 컨텍스트 내부
</h2>

<ol>
<li color="green_bg">
<b>Lexical Environment (렉시컬 환경)</b>

- <code>let</code>, <code>const</code>, 함수 선언, <code>class</code> 등 <b>블록/함수 스코프 변수</b>를 관리하는 공간
- “이 이름이 어떤 값을 가리키지?” 할 때 찾아보는 일종의 환경 지도
- 렉시컬 환경 : 정보 꾸러미 메타데이터

<p>
1-1. <b>Environment Record (환경 레코드)</b>

<b><span color="red">식별자 이름 / 값 상태가 저장됨. (호이스팅)</span></b>
</p>

<toggle color="gray_bg">
<b><span color="gray">Variable Environment (변수 환경)</span></b>

- <span color="gray">원래는 </span><span color="gray"><code>var</code></span><span color="gray"> 선언을 주로 관리하던 환경</span>
- <span color="gray">최신 엔진에서는 Lexical Env와 합쳐서 취급하지만, 명세상 </span><b><span color="gray">개념은 분리됨</span></b>
</toggle>
</li>
<li>
<b>this 바인딩</b>

- 그 컨텍스트에서 <code>this</code>가 무엇인지 (<code>window</code>, 어떤 객체 인스턴스 등)
</li>
<li>
<b>Outer Environment Reference</b>

<ul>
<li>
“바깥 스코프에 대한 참조”

- → <b>스코프 체인</b>의 원초적인 동작 및 <b>클로저 동작</b>의 근거가 되는 연결
</li>
</ul>
</li>
</ol>

---

## 실행 컨텍스트 생성 과정

1. <b>실행 컨텍스트 Creation Phase (생성 단계)</b>
   - <b>변수/함수 선언을 먼저 스캔</b>해서 <b><span color="blue">환경 레코드</span></b>에 등록 → 이때 호이스팅이 발생
   - OuterEnvironmentReference(외부환경참조) 설정 ← 이 시점에 결정됨
   - this 바인딩 결정

   <p>
   <b>→ 이후 콜스택에 Push(콜스택에 올라감)</b>
   </p>
2. <b>Execution Phase (실행 단계)</b>
   - 이제 실제로 한 줄씩 실행
   - <code>=</code> 할당, <code>함수 호출</code>, 연산 등 로직 수행

환경 레코드에서 변수에 대한 정보를 찾아봄 → 변수가 없으면 외부 렉시컬 환경에서 찾음.

### 호이스팅

변수와 함수가 초기화 되기 이전에 <b>메모리 상으로 먼저 올라가있는 현상</b>

<b><u>→ 애플리케이션이 실행될 때 </u></b><b><span color="blue"><u>실행 컨텍스트 렉시컬 환경</u></span></b><b><u>의</u></b><b><span color="blue"><u> 환경 레코드</u></span></b><b><u>에 변수가 저장되는 단계</u></b>

- <b>생성 단계</b>는 3번째 처럼 모든 <b><span color="blue_bg">함수 및 변수들을 등록</span></b>해서 컨텍스트에 올려둔 상태를 만드는 것을 목표로 합니다

<image source="notion-file-block://3cfee90a-967f-8006-bed9-e97ed09fffee/63245582-9120-4304-baa8-0f5ab1238c67?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

## <b>⭐️ var, let/const, function 호이스팅 차이</b>

---

### ◻️ function

<b>💡 function 키워드 함수</b>는 <b><span color="yellow_bg">선언과 초기화, 할당 단계가 내부적으로 동시에 </span></b>진행

```javascript
foo(); // 여기서도 호출 가능 -> foo : 선언 및 초기화 동시에 진행

function foo() {
  console.log("hi");
}
```

- <b>생성단계(Creation Phase):</b>
  - <u><code>foo</code></u><u> 라는 식별자를 </u><b><u>환경 레코드에 등록(호이스팅)</u></b>
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
  - <u><code>num </code></u><u>라는 식별자를</u><b><u> 환경 레코드에 등록(호이스팅)</u></b>
  - num의 초기값을<b> </b><b><span color="red">undefined</span></b>를 넣어둠.<b><span color="red">(초기값 : undefined)</span></b>
- <b>실행단계(Execution Phase)</b>
  <ul>
  <li>
  console.log(num) 은 이미 num이 존재하지만 undefined인 상태
  </li>
  <li>
  이후 라인 3에서 num 값 할당
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

<image source="notion-file-block://3cfee90a-967f-80b8-9634-e0ae7433d91d/08b6e5fd-135e-44b8-bfb5-3e2f89bdbccb?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<p>
→ <b><span color="yellow_bg">호이스팅 현상으로 인해서 초기화되지 않은 상태의 변수를 참조할 수 없도록</span></b> 하기 위해 초기화 전에 접근할 수 없도록 막아둠
</p>

### ❓ 원래 선언하기 이전에 초기화 되는게 맞나..? 선언되기 이전에 찾는다면 오류 뜨는게 당연한거아닌가?

실제로 <b>var의 호이스팅 현상(undefined)</b>은 자바스크립트 개발과정에서 실수로 생긴 일종의 버그라고 합니다

<s>마인크래프트에서 지옥문 타고 지옥갈 때 발생하는 멀미효과 버그 같은 것</s>

<image source="notion-file-block://3cfee90a-967f-8065-8098-ecde2f90f5fe/b611be8f-0f76-48b9-9e43-6a8d3af16de1?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<callout icon="💡">
<b>실제 JS 개발자 \<브랜든 아이크> 왈</b>

var hoisting was thus unintended consequence of function hoisting, no block scope, JS as a 1995 rush job. ES6 'let' may help.<br /><br />

호이스팅은 <b><span color="yellow_bg">함수 호이스팅의 의도치 않은 결과물(unintended consequence)</span></b><b> </b>이었습니다.

블록 스코프(block scope)가 없던 1995년 급하게 만들어진(JS as a 1995 rush job) 자바스크립트에서는 어쩔 수 없었죠. ES6의 <code>let</code>이 이 문제를 해결해줄 수 있을 거예요.
</callout>

<callout icon="🙂" color="gray_bg">
<b>요약 : 버그니까 let 만 쓰쇼</b>
</callout>

---

## 스코프 체인

<callout icon="💡">
식별자의 유효범위 안에서 바깥으로 차례로 검색해 나가는 것

<p>
→<b>Outer Environment Reference 외부 환경 참조</b> 덕분
</p>
</callout>

실행 컨텍스트의 구조

<ol>
<li>
<b>Lexical Environment (렉시컬 환경)</b> : 현재 함수/블록의 변수 저장공간

- <b>Environment Record </b>: 실제로 변수 저장되는 곳
- <b>OuterEnvironmentReference</b> : 부모 스코프를 가리킴
</li>
<li>
<b>this 바인딩</b>
</li>
<li color="blue_bg">
<b>Outer Environment Reference</b>

<ul>
<li>
“바깥 스코프에 대한 참조”

- → <b>스코프 체인</b>의 원초적인 동작 및 <b>클로저 동작</b>의 근거가 되는 연결
</li>
</ul>
</li>
</ol>

> 동작과정 요약

현재 스코프를 시작으로 참조가 링크드리스트처럼 연결되어있어, 참조를 따라 상위 스코프를 탐색

```javascript
[내 변수 테이블](현재 스코프) — (부모) → [부모 변수 테이블] — (글로벌) → [전역 테이블]
```

### 렉시컬 스코프 기반

“어떤 OuterEnvironment를 참조할지”는 <b>함수를 </b><i><b><u>어디서 정의했는지</u></b></i><b>로 이미 결정 </b>됨.

> <span color="gray">해당 코드의 콘솔 로그의 출력은 어떻게 이루어질까요?</span>

```javascript
var a = 1;  // 🔴

function outer() {  //🟡
  function inner() { //🟢
    console.log(a); //해당 콘솔 로그에서는 어떤 로그가 찍힐까요?
    var a = 3;
    console.log(a);
  }
  inner();
  console.log(a);
}

outer();
console.log(a);

```

> 🔴<b> 전역 컨텍스트 생성시</b>

- <b>전역 렉시컬 환경 안에 a와 outer가 존재</b>
- <b>outer</b>의 환경은<u> </u><b><u>전역 렉시컬 환경</u></b>을 부모로 가진다.
- <span color="gray">부모는 현재 감싸고 있는 객체.</span>

```javascript
//부모 : global
global LexicalEnvironment = {
   a: undefined
   outer → null
}
```

> 🟡<b> outer 함수가 선언</b>

- outerEnvironmentReference로 확장.

```lua
outer.[[Environment]] = global LexicalEnvironment
```

- <b>inner</b>의 환경은 <b><u>outer 렉시컬 환경</u></b>을 부모로 갖는다.
- <span color="gray">부모는 현재 감싸고 있는 객체.</span>

```javascript
//부모
outer LexicalEnvironment = {
		a: undefined
   inner → null
}
```

> 🟢<b> inner 함수가 선언</b>

- inner의 환경은 outer 렉시컬 환경을 부모로 가진다.

```lua
inner.[[Environment]] = outer LexicalEnvironment
```

---

### 실행 컨텍스트가 만들어지면

- 링크드리스트 처럼 연결되어있다.
- innera

```javascript
inner LE(LexicalEnvironment) {
    a: undefined
    outer → outer LE
}
```

```javascript
outer LE {
    a: undefined
    outer → global LE
}
```

```javascript
global LE {
    a: 1
}
```

```javascript
inner LE {
    a → 3
    outer → outer LE {
           a
           outer → global LE {
                  a
           }
    }
}

```

---

### 스코프 체인 ; 전체 흐름 파악하기

선언한다 라는 행위가 일어날 수 있는 것은 <b>실행 단계</b>인, 콜 스택상 <b><span color="yellow_bg"><u>실행 컨텍스트가 활성화 된 상태</u></span></b>일때만 가능.

```javascript
var a = 1;  // (1) 선언 → 생성 단계 호이스팅

function outer() {
  function inner() {
    console.log(a); // (2) 실행 → undefined //1일 줄 알았지만 아니었습니다~
    var a = 3; // (3) 실행 → 값 대입
    console.log(a); // (4) 실행 → 3
  }
  inner();
  console.log(a); //(5) 실행 -> outer 내부에 a 선언이 없기 때문에, 부모 a를 찾아봅니다: 1
}

outer();
console.log(a);  //(6) 실행 -> global a 선언 : 1

```

- 콘솔로 확인
  <p>
  undefined / 3 / 1 / 1
  </p>

  <image source="notion-file-block://3cfee90a-967f-80c2-bacc-d30897ce5b92/c932f028-e57c-45b7-8396-12b219189075?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

  ```javascript
  console.log(a); // (2) 실행 → undefined //1일 줄 알았지만 아니었습니다~
  ```

  - <code>inner</code> 함수 내부에 <code>var a</code>가 선언되어 있기 때문에, 스코프 체인으로 외부로 나가기 전에 이미 내부에서 <code>a</code>를 찾았고, 생성 단계에서 호이스팅이 되어서 undefined가 된 것!
  - <b>호이스팅 발생 (Creation Phase)</b>
    ```javascript
    functioninner() {
     var a;// 선언만 위로 끌어올려짐 (초기값 undefined)
     console.log(a);
     a=3;
     console.log(a);
    }
    ```

---

[프론트엔드 개발자 면접 단골 질문 10 \| 렉시컬 스코프](https://youtu.be/GO2KvOjMjZY?si=jzo6lJ0H1WpdobTJ)

[자바스크립트 실행 컨텍스트](https://junilhwang.github.io/TIL/Javascript/Domain/Execution-Context/#_1-%E1%84%80%E1%85%A2%E1%84%82%E1%85%A7%E1%86%B7)
