# B 级规则：Strongly Recommended（强烈推荐 · 默认遵守）

> 违反这些规则代码仍可运行，但会损害可读性/开发体验。默认遵守，偏离需向用户说明理由。

## B-1 组件文件（Single-file components）

只要构建系统可用，每个组件都应放在**单独的文件**中，便于快速定位和查阅。

```bash
# Bad
Vue.component('TodoList', { /* ... */ })
Vue.component('TodoItem', { /* ... */ })

# Good
components/
├── TodoList.vue
└── TodoItem.vue
```

## B-2 单文件组件文件名的大小写

SFC 文件名应**统一**使用 PascalCase，或**统一**使用 kebab-case。

PascalCase 优势：编辑器自动补全、与 JS(X)/模板引用一致。但大小写不敏感的文件系统上混用大小写可能出问题，因此统一 kebab-case 也可接受。**关键是项目内统一。**

```bash
# Bad
mycomponent.vue
myComponent.vue

# Good
MyComponent.vue   # 或统一
my-component.vue
```

## B-3 基础组件名

应用特定样式和规范的基础组件（展示型、哑组件、纯组件）应以 `Base`、`App` 或 `V` 开头。

基础组件**只能**包含：HTML 元素、其他基础组件、第三方 UI 组件；**绝不**包含全局状态（如 Pinia store）。

好处：字母排序时基础组件聚集；避免随意前缀（如 `MyButton`）；配合 Vite 的 `import.meta.glob` 可轻松全局注册。

```bash
# Good
components/
├── BaseButton.vue
├── BaseTable.vue
└── BaseIcon.vue
```

## B-4 紧耦合的组件名

与父组件紧密耦合的子组件，应以父组件名作为**前缀**。编辑器按字母排列文件时相关文件自然相邻。

不推荐用嵌套目录解决（会导致大量相似文件名、过多嵌套）。

```bash
# Bad
components/
├── TodoList.vue
├── TodoButton.vue    # 与 TodoList 耦合但看不出
└── TodoDeleteButton.vue

# Good
components/
├── TodoList.vue
├── TodoListItem.vue
└── TodoListItemButton.vue
```

## B-5 组件名中的单词顺序

组件名应以**最高层级**（通常最宽泛）的单词开头，以描述性的修饰词结尾。字母排序时相关组件一目了然。

```bash
# Bad
components/
├── ClearSearchButton.vue
└── RunSearchButton.vue

# Good
components/
├── SearchButtonClear.vue
├── SearchButtonRun.vue
└── SettingsCheckboxTerms.vue
```

仅在超大型应用（100+ 组件）中才考虑用目录嵌套替代。

## B-6 自闭合组件

无内容的组件在 SFC、字符串模板和 JSX 中应**自闭合**，但在 DOM 内模板中**绝不**自闭合（HTML 不允许自定义元素自闭合）。

```vue
<!-- Good: SFC / 字符串模板 / JSX -->
<MyComponent />

<!-- Good: DOM 内模板 -->
<my-component></my-component>
```

## B-7 模板中的组件名大小写

SFC 和字符串模板中的组件名应始终用 **PascalCase**；DOM 内模板则用 **kebab-case**（HTML 大小写不敏感）。

PascalCase 优势：编辑器可自动补全；与单字 HTML 元素视觉区分度更高；可与非 Vue 自定义元素（Web Components）明确区分。若项目已深度投入 kebab-case，全程统一使用也可接受。

```vue
<!-- Good -->
<TodoItem />        <!-- SFC -->
<todo-item></todo-item>  <!-- DOM 内模板 -->
```

## B-8 JS/JSX 中的组件名大小写

JS/JSX 中的组件名应始终用 **PascalCase**；仅在通过 `app.component` 全局注册的简单应用中，字符串形式可用 kebab-case。

```js
// Good
app.component('MyComponent', { /* ... */ })
import MyComponent from './MyComponent.vue'
```

## B-9 完整单词的组件名

组件名应优先使用**完整单词**而非缩写。编辑器自动补全让长名字的书写成本很低，但清晰性无可估量。尤其应避免不常见的缩写。

```bash
# Bad
SdSettings.vue
UProfOpts.vue

# Good
StudentDashboardSettings.vue
UserProfileOptions.vue
```

## B-10 Prop 名大小写

声明 prop 时**始终用 camelCase**；在 DOM 内模板中使用时应为 **kebab-case**；SFC 模板和 JSX 中两者皆可，但**整个项目中风格必须一致**，不可混用。

```js
// Bad
props: { 'greeting-text': String }

// Good
props: { greetingText: String }
```

```vue
<!-- Good: SFC 内统一一种 -->
<MyComponent greeting-text="hi" />
<!-- 或统一 -->
<MyComponent greetingText="hi" />

<!-- Good: DOM 内模板 -->
<my-component greeting-text="hi"></my-component>
```

## B-11 多 attribute 的元素

拥有多个 attribute 的元素应**拆分为多行**，每行一个 attribute。

```vue
<!-- Good -->
<img
  src="https://vuejs.org/images/logo.png"
  alt="Vue logo"
>

<MyComponent
  foo="a"
  bar="b"
  baz="c"
/>
```

## B-12 模板中的简单表达式

组件模板应只包含**简单表达式**，复杂表达式应重构为计算属性或方法。模板描述"显示什么"而非"如何计算"。

```vue
<!-- Bad -->
{{
  fullName.split(' ').map((word) => {
    return word[0].toUpperCase() + word.slice(1)
  }).join(' ')
}}

<!-- Good -->
{{ normalizedFullName }}

<script>
const normalizedFullName = computed(() =>
  fullName.split(' ')
    .map((word) => word[0].toUpperCase() + word.slice(1))
    .join(' ')
)
</script>
```

## B-13 简单的计算属性

复杂的计算属性应拆分成**尽可能多**的更简单的属性。拆分后更易测试、更易阅读（每个值有描述性名称）、更适应需求变化。

```js
// Bad
const price = computed(() => {
  const basePrice = manufactureCost / (1 - profitMargin)
  return basePrice - basePrice * (discountPercent || 0)
})

// Good
const basePrice = computed(() => manufactureCost / (1 - profitMargin))
const discount = computed(() => basePrice.value * (discountPercent || 0))
const finalPrice = computed(() => basePrice.value - discount.value)
```

## B-14 带引号的 attribute 值

非空的 HTML attribute 值应**始终**置于引号内（单引号或双引号，选与 JS 中不冲突的那种）。

```vue
<!-- Bad -->
<input type=text>

<!-- Good -->
<input type="text">
```

## B-15 指令缩写

指令缩写（`:` 对应 `v-bind:`、`@` 对应 `v-on:`、`#` 对应 `v-slot:`）要么**始终使用**，要么**一律不用**。同一项目中不可混用完整形式与缩写形式。

```vue
<!-- Good: 全用缩写 -->
<input :value="newTodoText" @input="onInput">
<template #header>
  <h1>{{ title }}</h1>
</template>

<!-- Good: 全用完整形式 -->
<input v-bind:value="newTodoText" v-on:input="onInput">
<template v-slot:header>
  <h1>{{ title }}</h1>
</template>
```
