---
name: vue-style-guide
description: Vue 官方风格指南（Vue 3 Style Guide）强制遵循技能。当任务涉及编写、修改、评审 Vue 代码（含 SFC 单文件组件、script setup、Composition API、组件设计、props/events 通信、模板指令 v-for/v-if/v-model、样式作用域）时，必须加载本技能并严格遵守 A 级（Essential）规则，默认遵守 B/C 级规则。触发词：Vue 开发、写 Vue 组件、Vue 代码评审、Review、SFC、script setup、Composition API、组件命名、props、v-for、v-if、v-model、scoped 样式、Vue 风格指南。本技能是 Vue 编码任务的最高优先级规范来源，任何代码交付前必须对照自查清单检查。
version: 1.0.0
---

# Vue Style Guide（Vue 官方风格指南）

## Overview

本技能固化 Vue 官方风格指南全部 **26 条**规则（**A Essential 5 / B Strongly Recommended 15 / C Recommended 4 / D Use with Caution 2**），
作为所有 Vue 编码、评审、组件设计任务的规范来源。

分级执行策略（对标 A/B/C/D 四级优先级）：
- **A 级（Essential）**：防错规则，**无条件强制**，任何场景不得违反
- **B 级（Strongly Recommended）**：默认遵守，偏离需向用户说明理由
- **C 级（Recommended）**：存在多个等价选项，项目内**必须保持一致**（默认采用官方推荐选项）
- **D 级（Use with Caution）**：风险特性，使用前必须说明必要性和边界

规范分两级加载：
- 本文件：内置 **A 级全部规则 + B/C/D 高频条款**（每次开发必读）+ 交付前自查清单
- `references/`：**全量 26 条**（含正反例代码），遇到对应场景必须查阅对应文件对照执行

## 强制工作流（每次 Vue 任务都必须走完）

### 第 1 步 · 开工前声明规范范围
动手写代码前，先根据任务内容列出本次涉及哪些规范领域，并**必须**打开对应 references 文件：
- 新建组件/命名 → `references/ref-b-strongly-recommended.md`（组件文件、命名、大小写、完整单词）
- props/事件/父子通信 → `references/ref-a-essential.md` + `references/ref-d-use-with-caution.md`
- 列表渲染/条件渲染 → `references/ref-a-essential.md`（key、v-if 与 v-for）
- 模板表达式/计算属性 → `references/ref-b-strongly-recommended.md`
- 样式 → `references/ref-a-essential.md`（scoped）+ `references/ref-d-use-with-caution.md`（选择器性能）
- 组件选项顺序/SFC 块顺序/attribute 顺序 → `references/ref-c-recommended.md`

### 第 2 步 · 编码时对照核心条款
每写一段代码，对照下方「核心强制条款」逐项自查；涉及全量条款的场景打开对应 reference 全文核对。
**禁止**出现任何 A 级规则的反例。

### 第 3 步 · 交付前跑一遍自查清单
代码交付（提交/回复用户/评审输出）前，必须对照「交付前自查清单」逐项确认，并**明确告知用户已按 Vue 官方风格指南自查**；发现违规必须先修正再交付。

## 核心强制条款（A 级 Essential · 每次开发必读）

### 组件与命名
1. **组件名必须多词**：单 word 组件名会与现有及未来的 HTML 元素冲突。根组件 `App` 除外。✅ `TodoItem` ❌ `Item`
2. **基础组件加前缀**：展示型/哑组件以 `Base`、`App` 或 `V` 开头（如 `BaseButton`、`BaseIcon`）；基础组件**绝不**包含全局状态（Pinia store 等）。
3. **紧耦合子组件以父组件名为前缀**：`TodoList` → `TodoListItem` → `TodoListItemButton`；**不要**用嵌套子目录解决耦合。
4. **组件名单词顺序：最宽泛的词开头**：`SearchButtonClear`、`SearchButtonRun`，而不是 `ClearSearchButton`。
5. **组件名用完整单词**，禁用不常见缩写：`StudentDashboardSettings` ✅，`SdSettings` ❌。
6. **SFC 文件名统一 PascalCase**（或项目内统一 kebab-case，二选一不得混用）；模板中组件名用 PascalCase，DOM 内模板用 kebab-case。
7. **自闭合**：SFC/字符串模板/JSX 中无内容组件自闭合 `<MyComponent />`；DOM 内模板**绝不**自闭合。
8. **prop 声明用 camelCase**（`greetingText`），DOM 内模板传参用 kebab-case（`greeting-text="hi"`）；SFC 内两种风格选一，全项目统一。

### 模板与指令
9. **prop 定义必须详细**：至少声明类型；数组形式 `props: ['status']` 只允许原型期使用。最佳实践含 `type` + `required` + `validator`。
10. **v-for 必须带 key**：组件上**无条件必须**，元素上也应加（对象恒定性、过渡动画、焦点保持）。`:key="todo.id"`，禁用索引做 key（列表会重排/增删时）。
11. **v-if 与 v-for 禁止同元素**：过滤列表 → 改用 computed 过滤后的新数组；隐藏整个列表 → v-if 移到容器元素上。Vue 3 中 v-if 优先级高于 v-for，同元素直接报错。
12. **模板只放简单表达式**：复杂逻辑（链式 map/filter/split）移入 computed 或方法；模板描述"显示什么"而非"如何计算"。
13. **多 attribute 元素拆多行**，每行一个 attribute。
14. **非空 attribute 值始终加引号**；指令缩写（`:` `@` `#`）要么始终用要么一律不用，不得混用。

### 通信与状态
15. **父子组件通信用 props + events**（props down, events up）：禁止 `this.$parent` 直接改父状态；禁止子组件修改 props 引用的父级响应式对象。需要双向 → `emit('update:todo', {...})` + `v-model:todo`。
16. **复杂 computed 拆分为多个简单 computed**：`price` → `basePrice` + `discount` + `finalPrice`，更易测试、易读、适应变更。

### 样式
17. **组件样式必须作用域化**：顶层 `App` 与布局组件可全局，其余组件一律 scoped / CSS Modules / BEM 类名策略。**组件库应优先用类名策略而非 `scoped` 属性**（便于覆盖内部样式）。
18. **scoped 样式中禁用元素选择器**：`button[data-v-xxx]` 远慢于 `.btn-close[data-v-xxx]`，一律用 class 选择器。

### 结构顺序（C 级默认选项）
19. **SFC 顶层块顺序统一**：`<script>` → `<template>` → `<style>`（或 template 在前，项目统一即可），`<style>` 恒最后。
20. **组件选项推荐顺序**（Options API）：name → components/directives → extends/mixins/provide/inject → props/emits/expose → setup → data/computed → watch → 生命周期（按调用顺序）→ methods → template/render。
21. **元素 attribute 推荐顺序**：is → v-for → v-if/v-else-if/v-else/v-show → v-pre/v-once → id → ref/key → v-model → 其他 attribute → v-on 事件 → v-html/v-text。

## 交付前自查清单（逐项确认，违规先修再交付）

1. 所有组件名是否多词（App 除外）、完整单词、以最宽泛词开头？
2. 所有 prop 是否有详细定义（类型/必填/校验器），无数组式声明？
3. 所有 v-for 是否带唯一 key，且未用数组索引做 key（可重排列表）？
4. 是否存在 v-if 与 v-for 同元素？已改为 computed 过滤或容器 v-if？
5. 子组件是否只通过 props 接收、events 上报，无 $parent、无改 props 内对象？
6. 所有非根/非布局组件样式是否 scoped/模块化，且 scoped 内无元素选择器？
7. 模板中是否只有简单表达式，复杂逻辑已移入 computed/methods？
8. 模板组件名 PascalCase、prop 传参风格、指令缩写是否全项目统一？
9. SFC 顶层块顺序、组件选项顺序是否符合推荐顺序？
10. D 级特性（如 v-html、$parent）若使用，是否已说明必要性？

## 维护说明

- 规则来源：Vue 官方风格指南（https://cn.vuejs.org/style-guide/ ，对应 Vue 3）
- 分级口径：本技能把 A 级视为【强制】、B/C 级视为【推荐默认遵守】、D 级视为【谨慎使用】——声明"已按 Vue 官方风格指南自查"时按此口径计数（A 5 / B 15 / C 4 / D 2，共 26 条）。
