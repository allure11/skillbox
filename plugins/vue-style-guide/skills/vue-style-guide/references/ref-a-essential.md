# A 级规则：Essential（防止错误 · 无条件强制）

> 这些规则帮助防止错误，任何场景都必须遵守。例外极少，且只应由精通 JavaScript 和 Vue 的专家做出。

## A-1 使用多词组件名（Use multi-word component names）

组件名应始终是多词的，根组件 `App` 除外。所有 HTML 元素都是单个单词，单词组件名会与现有及未来的 HTML 元素冲突。

```vue
<!-- Bad -->
<!-- in pre-compiled templates -->
<Item />
<!-- in in-DOM templates -->
<item></item>

<!-- Good -->
<!-- in pre-compiled templates -->
<TodoItem />
<!-- in in-DOM templates -->
<todo-item></todo-item>
```

## A-2 使用详细的 prop 定义（Use detailed prop definitions）

提交的代码中，prop 定义应始终尽量详细，至少指定类型。

详细 prop 定义的两大好处：文档化组件 API，一看就知道怎么用；开发时 Vue 会对格式错误的 props 发出警告。

```js
// Bad —— 仅原型期可用
props: ['status']

// Good
props: {
  status: String
}

// Even better
props: {
  status: {
    type: String,
    required: true,
    validator: value => {
      return ['syncing', 'synced', 'version-conflict', 'error'].includes(value)
    }
  }
}
```

`<script setup>` 写法同理：

```js
// Bad
const props = defineProps(['status'])

// Good
const props = defineProps({
  status: {
    type: String,
    required: true,
    validator: (value) => {
      return ['syncing', 'synced', 'version-conflict', 'error'].includes(value)
    }
  }
})
```

## A-3 为 v-for 设置 key（Use keyed v-for）

`v-for` 上的 `key` 在**组件上无条件必须**，以维持子树内部组件状态。元素上也应加，保持对象恒定性（如动画、焦点保持）等可预期行为。

不加 key 时 Vue 会执行最廉价的 DOM 变更（可能删掉首元素再在尾部补回），在 `<transition-group>` 动画、`<input>` 焦点保持等场景下出错。

```vue
<!-- Bad -->
<ul>
  <li v-for="todo in todos">
    {{ todo.text }}
  </li>
</ul>

<!-- Good -->
<ul>
  <li
    v-for="todo in todos"
    :key="todo.id"
  >
    {{ todo.text }}
  </li>
</ul>
```

## A-4 避免 v-if 与 v-for 同时使用（Avoid v-if with v-for）

**绝不**在 `v-for` 同一元素上使用 `v-if`。

两种常见误区及修正：
- 过滤列表项（`v-for="user in users" v-if="user.isActive"`）→ 改用返回过滤后列表的 computed
- 隐藏整个列表（`v-for="user in users" v-if="shouldShowUsers"`）→ 把 `v-if` 移到容器元素上

Vue 3 中 `v-if` 优先级高于 `v-for`，同元素时 `v-if` 先求值、迭代变量尚不存在，直接报错。

```vue
<!-- Bad -->
<ul>
  <li
    v-for="user in users"
    v-if="user.isActive"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>

<!-- Good: computed 过滤 -->
<script>
const activeUsers = computed(() => users.filter((user) => user.isActive))
</script>
<ul>
  <li
    v-for="user in activeUsers"
    :key="user.id"
  >
    {{ user.name }}
  </li>
</ul>

<!-- Good: template 包裹 + 容器级 v-if -->
<ul>
  <template v-for="user in users" :key="user.id">
    <li v-if="user.isActive">
      {{ user.name }}
    </li>
  </template>
</ul>
```

## A-5 使用组件作用域化的样式（Use component-scoped styling）

应用中，顶层 `App` 组件和布局组件的样式可以全局，**其余所有组件的样式应始终作用域化**。

作用域化不限于 `scoped` 属性——CSS Modules、BEM 等基于类名的策略均可。**组件库应优先用基于类名的策略**而非 `scoped` 属性：这样内部样式更容易被覆盖，类名可读且特异性不会过高。

```vue
<!-- Bad -->
<template>
  <button class="btn btn-close">×</button>
</template>

<style>
.btn-close {
  background-color: red;
}
</style>

<!-- Good: scoped -->
<template>
  <button class="button button-close">×</button>
</template>

<style scoped>
.button {
  border: none;
  border-radius: 2px;
}
.button-close {
  background-color: red;
}
</style>

<!-- Good: CSS Modules -->
<template>
  <button :class="[$style.button, $style.buttonClose]">×</button>
</template>

<style module>
.button {
  border: none;
  border-radius: 2px;
}
.buttonClose {
  background-color: red;
}
</style>

<!-- Good: BEM -->
<template>
  <button class="c-Button c-Button--close">×</button>
</template>

<style>
.c-Button {
  border: none;
  border-radius: 2px;
}
.c-Button--close {
  background-color: red;
}
</style>
```
