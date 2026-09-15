# Test

## plugin@register-components

### MyComponent

<MyComponent/>

## plugin@md-enhance

### TaskList

- [ ] Plan A
- [x] Plan B

### Mermaid

```er Er Example
CAR ||--o{ NAMED-DRIVER : allows
CAR {
    string registrationNumber
    string make
    string model
}
PERSON ||--o{ NAMED-DRIVER : is
PERSON {
    string firstName
    string lastName
    int age
}
```

### Demo

::: normal-demo Normal demo

```md
# Title

is very powerful!
```

```ts
const message: string = "VuePress Theme Hope";

document.querySelector("h1").innerHTML = message;
```

```scss
h1 {
  font-style: italic;

  + p {
    color: red;
  }
}
```

:::

### Include

---

<!-- @include: draft.md -->
