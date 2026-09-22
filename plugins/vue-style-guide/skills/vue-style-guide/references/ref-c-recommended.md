# C 级规则：Recommended（推荐 · 多个等价选项，项目内必须统一）

> 这些规则中存在多个同样好的选项，官方给出默认选择。你可以在自己的代码库中自由做出不同选择，只要保持一致且有充分理由。

## C-1 组件/实例选项的顺序

组件选项应按一致的顺序书写。官方推荐顺序（按类别分组，便于知道从插件来的新属性该加在哪）：

1. **全局感知**（要求组件以外的知识）：`name`
2. **模板编译器选项**：`compilerOptions`
3. **模板依赖**（模板中使用的资源）：`components`、`directives`
4. **组合**（向选项中合并属性）：`extends`、`mixins`、`provide`/`inject`
5. **接口**（组件的接口）：`inheritAttrs`、`props`、`emits`、`expose`
6. **组合式 API**（使用 Composition API 的入口）：`setup`
7. **本地状态**（本地的响应式属性）：`data`、`computed`
8. **事件**（由响应式事件触发的回调）：`watch`、生命周期钩子（按调用顺序：`beforeCreate`、`created`、`beforeMount`、`mounted`、`beforeUpdate`、`updated`、`activated`、`deactivated`、`beforeUnmount`、`unmounted`、`errorCaptured`、`renderTracked`、`renderTriggered`、`serverPrefetch`）
9. **非响应式的属性**（不依赖响应系统的实例属性）：`methods`
10. **渲染**（组件输出的声明式描述）：`template`/`render`

## C-2 元素 attribute 的顺序

元素（包括组件）的 attribute 应按一致的顺序书写。官方推荐顺序：

1. **定义**（提供组件选项）：`is`
2. **列表渲染**（创建相同元素的多个变体）：`v-for`
3. **条件渲染**（元素是否渲染/显示）：`v-if`、`v-else-if`、`v-else`、`v-show`、`v-cloak`
4. **渲染修饰符**（改变元素的渲染方式）：`v-pre`、`v-once`
5. **全局感知**（要求组件以外的知识）：`id`
6. **唯一性的 attribute**（需要唯一值的属性）：`ref`、`key`
7. **双向绑定**（结合绑定与事件）：`v-model`
8. **其他 attribute**（所有未指定的绑定与未绑定 attribute）
9. **事件**（组件事件监听器）：`v-on`
10. **内容**（覆写元素的内容）：`v-html`、`v-text`

## C-3 组件/实例选项中的空行

可以在多行属性之间添加一个空行，特别是在选项已经长到不滚动屏幕就放不下的时候；不添加空行也可以，只要组件仍易于阅读和导航。

```js
// Good（Options API：选项组之间适当留空行）
props: {
  value: {
    type: String,
    required: true
  },

  focused: {
    type: Boolean,
    default: false
  },

  label: String,
  icon: String
},

computed: {
  formattedValue() {
    // ...
  },

  inputClasses() {
    // ...
  }
}
```

```js
// Good（script setup：声明块之间留空行）
defineProps({
  value: {
    type: String,
    required: true
  },

  focused: {
    type: Boolean,
    default: false
  },

  label: String,
  icon: String
})

const formattedValue = computed(() => {
  // ...
})

const inputClasses = computed(() => {
  // ...
})
```

## C-4 单文件组件顶层元素的顺序

SFC 应始终按一致的顺序放置 `<script>`、`<template>` 和 `<style>` 标签，且 **`<style>` 恒在最后**——因为前两者中至少有一个总是必要的。

```vue
<!-- Good -->
<script>/* ... */</script>
<template>...</template>
<style>/* ... */</style>

<!-- Good（template 在前也可以，项目统一即可） -->
<template>...</template>
<script>/* ... */</script>
<style>/* ... */</style>

<!-- Bad：style 不在最后 / 各文件顺序不一致 -->
<style>/* ... */</style>
<script>/* ... */</script>
<template>...</template>
```
