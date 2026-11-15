# FE 단위 테스트: Vitest + React Testing Library

# Intro

<p>
최근 단위테스트에 궁금해졌다. E2E playwright만 사용해봤고 단위테스트는 작성해보지 않아서, 단위테스트를 어떻게 사용하면 좋을지 학습해보고자 하였다. 또한 과제테스트에서 테스트의 작성 여부가 프론트에서도 많이 갈린다고 하였다. 단위 테스트 도구를 조사하던중 Vitest + RTL을 많이 사용한다고 한다는 것을 발견했다.
</p>

---

### Vitest - 테스트 러너

테스트 코드를 실행시켜주는 프로그램

```javascript
expect(1+1).toBe(2)
```

라는 코드를 작성했을때 JS는 이런 예약어는 모른다. → Vitest같은 테스트 러너들이 실행시켜줘야됨.

1. <b>테스트 파일을 찾아줌</b> (<code>.test.ts</code>, <code>.spec.ts</code> 같은 이름 찾음)
2. <b><code>describe</code></b><b>, </b><b><code>it</code></b><b>, </b><b><code>test</code></b><b>, </b><b><code>expect</code></b><b> 같은 함수를 제공</b>
3. <b>테스트 하나씩 실행</b>
4. <b>결과 판정</b> (통과/실패)
5. <b>터미널에 예쁘게 출력</b>

<b>→ 테스트 전용 JavaScript 실행 환경</b>

비슷한 도구로서 Jest가 있지만, 대부분의 프레임워크는 Vite를 쓰기 때문에 Vitest를 사용한다고 한다. 문법은 거의 똑같음.

---

### RTL — React 컴포넌트 조작 도구

<p>
Vitest만으로는 <b>순수 JavaScript 로직</b>만 테스트할 수 있다.
</p>

예를 들어 <code>formatPrice(1000) === '1,000원'</code> 같은 것.

근데 React 컴포넌트는 <b>화면에 그려지는 것이기때문에 테스트를 하기 위해서는 </b>

1. 컴포넌트를 <b>가상의 화면에 그려야 하고</b>
2. 그려진 결과에서 <b>특정 요소를 찾아야 하고</b>
3. <b>클릭하거나 입력하는 동작</b>을 시뮬레이션해야 하고
4. <b>결과가 맞는지</b> 확인해야 해

이걸 가능하게 해주는 도구가 RTL이다.

- <code>render(<Button />)</code> — 컴포넌트를 가상 화면에 그림
- <code>screen.getByText('클릭')</code> — 그려진 화면에서 "클릭"이라는 텍스트 찾음
- <code>screen.getByRole('button')</code> — button 역할을 하는 요소 찾음

<b>왜 별도의 도구가 필요하냐</b>: React 컴포넌트 테스트는 <b>DOM 조작 </b>이 핵심

매번 코드를 손으로 쓰면 너무 번거로워서, RTL이 이 과정을 편하게 만들어주는 도구를 모아둠

결론, 둘의 역할이 다르기 때문에 둘 다 있어야 React 테스트가 돌아감.<b> Vitest는 실행기, RTL은 조작 도구</b>

```javascript
import { describe, it, expect } from 'vitest'        // ← Vitest에서 가져옴
import { render, screen } from '@testing-library/react'  // ← RTL에서 가져옴
import userEvent from '@testing-library/user-event'   // ← user-event에서 가져옴
import { Counter } from './Counter'

describe('Counter 컴포넌트', () => {                  // ← Vitest 함수
  it('버튼 클릭 시 카운트 증가', async () => {         // ← Vitest 함수
    const user = userEvent.setup()                    // ← user-event 함수

    render(<Counter />)                               // ← RTL 함수

    const button = screen.getByRole('button')         // ← RTL 함수
    await user.click(button)                          // ← user-event 함수

    expect(screen.getByText('1')).toBeInTheDocument() // ← Vitest(expect) + RTL(screen)
  })
})
```

### 예약어 파헤치기

- <b>describe</b> : <b>"테스트들을 그룹으로 묶는 함수"</b>
  ```javascript
  describe(그룹_이름, () => {
    // 이 안에 관련된 테스트들 묶음
  })
  ```

  <p>
  활용법 : <code>describe</code>로 묶으면 "카운터 컴포넌트 관련 테스트들" / "폼 컴포넌트 관련 테스트들" 처럼 분류 가능
  </p>
- <b>it</b> : <b>"하나의 테스트를 정의하는 함수”</b>
  ```javascript
  it(테스트_설명, () => {
    // 이 안에 "무엇이 어떻게 동작해야 하는지" 검증
  })
  ```

  <ul>
  <li>
  test도 동일하게 작동한다. → 취향에 따라 it/test 선택
  </li>
  </ul>

  ```javascript
  test("1 + 1은 2", () => { ... })
  ```

  <callout icon="💡" color="green_bg">
  왜 it인가요?

  테스트 설명을 자연어처럼 읽히게 만들려는 의도

  ```javascript
  it("1 + 1은 2", ...)
  // 읽을 때: "it(그것이) '1 + 1은 2'"
  // 즉 "이 코드는 '1+1은 2'여야 한다"
  ```

  영어일때 더 자연스러움

  ```javascript
  it("returns 2 when adding 1 and 1", ...)
  // "It returns 2 when adding 1 and 1"
  // "그것은 1과 1을 더할 때 2를 반환한다"
  ```
  </callout>
- <b>expect(1 + 1).toBe(2)</b> : 실제 검증하는 줄
  <p>
  : (실제값)이 (기대값)이기를 바란다.
  </p>

  ```javascript
  expect(실제_값).toBe(기대_값)
  ```

  - <b>toBe : “matcher”라는 검증 방법</b>
    <p>
    expect(...)가 반환하는 객체는 수많은 matcher 메서드가 붙어있다.
    </p>

### Playwright와 비교

```javascript
await page.goto('https://myapp.com')
await page.getByRole('button').click()
await expect(page.getByText('1')).toBeVisible()
```

Playwright는 <b>위 모든 단계를 혼자 다 함</b>. 왜냐면 E2E는 <b>실제 브라우저</b>를 띄워서 거기다 다 맡기기 때문 (브라우저 자체가 렌더링·이벤트 처리·DOM 탐색을 다 함)

<b>Vitest + RTL (단위·통합)</b>

- 브라우저가 없음
- node 위에서 돌아감
- 그래서 브라우저가 해주던 일들을 <b>여러 도구로 나눠서</b> 직접 처리해야 함
- 결과: <b>Vitest(실행) + jsdom(DOM 환경) + RTL(렌더·탐색) + user-event(이벤트) 조합</b>

<p>
Playwright는 사용해보시면 아시겠지만 굉장히 무겁습니다. 실제로 브라우저로 테스트를 돌리는 것이기 때문에, GUI로 돌리면 정상적일경우 성공되는 것들도 사양 부족으로 실패하는것이 playwright이지만, Vitest+RTL은 가볍고 빠르다고 합니ㅏㄷ.
</p>

---

# 사용해보기

<h3>
임시 테스트
</h3>

```javascript
import { describe, it, expect } from "vitest";

describe("세팅 확인", () => {
  it("1 + 1은 2", () => {
    expect(1 + 1).toBe(2);
  });

  it("문자열 비교", () => {
    expect("hello").toBe("hello");
  });
});
```

<image source="notion-file-block://3cfee90a-967f-80bc-aa82-ec89adb60d2b/c4370a55-777a-4fe8-a3aa-e1607d433cdd?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

<b><code>transform 20ms</code></b>

- esbuild가 TypeScript → JavaScript로 변환하는 데 걸린 시간
- Vitest는 esbuild 기반이라 빠르다
- 20ms = 0.02초. 엄청 빠름

<b><code>setup 77ms</code></b>

- 우리가 만든 <code>src/test/setup.ts</code> 실행 시간
- <code>import '@testing-library/jest-dom'</code> 한 줄이 여기서 실행되면서 matcher들이 expect에 추가됨

<b><code>import 10ms</code></b>

- 테스트 파일에서 import한 것들(vitest 등) 로드 시간

<b><code>tests 2ms</code></b>

- 실제 테스트 로직 실행 시간
- 두 테스트 합쳐서 2ms. 순수 JS 실행이라 빠를 수밖에

<b><code>environment 709ms</code></b>

- <b>jsdom 환경 시작 시간</b> ← 여기가 가장 무거움
- document·window 객체를 메모리에 생성하는 데 걸리는 시간
- 전체 시간의 77% 차지

<callout icon="💡" color="gray_bg">
<b>Q: "Vitest가 어떻게 빠른 건가요?"</b>

> "Vitest는 esbuild로 TypeScript를 변환하는데, Go 기반이라 Babel보다 훨씬 빠릅니다. 제가 실제로 간단한 테스트 2개를 돌렸을 때 transform이 20ms, tests 실행이 2ms였습니다. 무거운 건 jsdom 환경 초기화(709ms)였는데, 이건 한 번만 걸리는 고정 비용이라 테스트 파일이 많아질수록 희석됩니다."
</callout>

---

<h3>
 React 컴포넌트 테스트
</h3>

<p>
Vitest + RTL + jsdom + user-event를 모두 한번에 쓰는 상황
</p>

```javascript
import { useState } from "react";

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>현재 카운트: {count}</p>
      <button onClick={() => setCount(count + 1)}>증가</button>
      <button onClick={() => setCount(count - 1)}>감소</button>
      <button onClick={() => setCount(0)}>리셋</button>
    </div>
  );
}

```

- 컴포넌트 코드 바로 옆에 테스트 코드를 만들어두는 것 : 한쌍으로 관리하는 것이 편하다고 함.
  <image source="notion-file-block://3cfee90a-967f-8023-aa37-f4b55dcff2a3/2083484a-a1f4-44fd-bca8-96003fc11e3b?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />

1. <b>카운터 컴포넌트 테스트 코드</b>

```javascript
import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";
import { Counter } from "./Counter";

describe("Counter 컴포넌트", () => {
  it("초기 카운트는 0이다", () => {
    render(<Counter />); //<= 이 부분 중요
    expect(screen.getByText("현재 카운트: 0")).toBeInTheDocument();
  });
});

```

<image source="notion-file-block://3cfee90a-967f-8040-80d6-e67dc48cd429/8d22ec35-0324-49b6-bf85-1378c102a38a?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png">
테스트 출력 결과
</image>

```javascript
render(<Counter />); //RTL 첫 등장
```

- RTL : React 컴포넌트 조작 도구이고, 가상 화면에 붙인다.

> <b>RTL render의 동작 방식</b>

<ol>
<li>
<code><Counter /></code> 라는 JSX를 React가<b> VirtualDOM</b>으로 변환
</li>
<li>
RTL의 <code>render</code>가 그걸 <b>jsdom이 만든 가짜 document</b>에 붙임
</li>
<li>
결과적으로 <b>jsdom 안에 Counter 컴포넌트가 실제로 그려짐 </b>(브라우저 환경에서 동작이 아닌 node : 자바스크립트 환경에서 동작하는 것이기 때문이다.)
</li>
<li>
이후로 <code>screen</code>으로 그 DOM에 접근 가능
</li>
</ol>

2. <b>증가 버튼</b>

<p>
증가 버튼을 클릭하면 카운트가 1 증가하는 테스트 코드
</p>

```javascript
it("증가 버튼을 클릭하면 카운트가 1 증가한다", async () => {
  const user = userEvent.setup();
  render(<Counter />);

  const increaseButton = screen.getByRole("button", { name: "증가" });
  await user.click(increaseButton);

  expect(screen.getByText("현재 카운트: 1")).toBeInTheDocument();
});
```

- userEvent : 버튼 클릭이라는 <b>사용자 동작을 흉내내는 도구</b>

```javascript
const user = userEvent.setup();
```

<image source="notion-file-block://3cfee90a-967f-8007-9b15-cffc5cfdc3c5/e4db0874-45bc-4c29-abd0-4b961eb6b5fe?space_id=0c13a87e-ef61-4fd0-af8a-e953a2e82e45&name=image.png" />
