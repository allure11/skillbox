# D 级规则：Use with Caution（谨慎使用 · 使用前必须说明必要性和边界）

> 这些特性为罕见边界情况或遗留代码库迁移而存在，过度使用会损害可维护性甚至引入 bug。

## D-1 scoped 中的元素选择器（Element selectors with scoped）

**在 `scoped` 样式中应避免使用元素选择器。** 优先使用 class 选择器，因为大量元素选择器很慢。

原理：为作用域化样式，Vue 给组件元素添加唯一 attribute（如 `data-v-f3f3eg9`），选择器被改写为 `button[data-v-f3f3eg9]` 这类"元素-属性"选择器——它比类-属性选择器 `.btn-close[data-v-f3f3eg9]` **慢得多**。

```vue
<!-- Bad -->
<template>
  <button>×</button>
</template>

<style scoped>
button {
  background-color: red;
}
</style>

<!-- Good -->
<template>
  <button class="btn btn-close">×</button>
</template>

<style scoped>
.btn-close {
  background-color: red;
}
</style>
```

## D-2 隐式的父子组件通信（Implicit parent-child communication）

**父子组件通信应优先使用 props 和 events，而不是 `this.$parent` 或修改 props。**

理想的 Vue 应用是 **props down, events up**。坚持这一约定让组件更容易理解。不要为了少写代码的短期便利，牺牲"能理解状态流向"的简单性。

```js
// Bad：通过 v-model 直接修改 prop 对象
app.component('TodoItem', {
  props: { todo: { type: Object, required: true } },
  template: '<input v-model="todo.text">'
})

// Bad：直接改 $parent 的状态
app.component('TodoItem', {
  props: { todo: { type: Object, required: true } },
  methods: {
    removeTodo() {
      this.$parent.todos = this.$parent.todos.filter(
        (todo) => todo.id !== this.todo.id
      )
    }
  },
  template: `
    <span>
      {{ todo.text }}
      <button @click="removeTodo">×</button>
    </span>
  `
})

// Good：props + events
app.component('TodoItem', {
  props: { todo: { type: Object, required: true } },
  emits: ['delete'],
  template: `
    <span>
      {{ todo.text }}
      <button @click="$emit('delete')">×</button>
    </span>
  `
})
```

`<script setup>` 同理——**禁止在子组件中修改 props 引用的父级响应式对象**（等于子组件伸手改父组件拥有的状态）：

```vue
<!-- Bad -->
<script setup>
const props = defineProps({
  todo: { type: Object, required: true }
})

function renameTodo() {
  props.todo.text = 'renamed by child'   // 子组件越权改父级状态
}
</script>

<!-- Good：emit 一个新对象，更新权在父组件 -->
<script setup>
const props = defineProps({
  todo: { type: Object, required: true }
})

const emit = defineEmits(['update:todo'])

function renameTodo() {
  emit('update:todo', { ...props.todo, text: 'renamed by parent' })
}
</script>

<template>
  <input :value="todo.text" @input="emit('input', $event.target.value)" />
</template>
```
