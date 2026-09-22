# Apple HIG 官方全量主题索引（Catalog）

> 用于定位技能未展开的主题，再到官方页面获取完整规则。
> 官方入口：https://developer.apple.com/cn/design/human-interface-guidelines

## 一、设计基础（Design fundamentals）

| 主题 | 链接 |
|---|---|
| 入门指南 | `/getting-started` |
| 设计原则 | `/design-principles` |
| 为 iOS 设计 | `/designing-for-ios` |
| 为 macOS 设计 | `/designing-for-macos` |

## 二、基础（Foundations）

| 主题 | 链接 | 本技能覆盖 |
|---|---|---|
| 无障碍 | `/accessibility` | ✅ `ref-05-accessibility.md` |
| App 图标 | `/app-icons` | 部分（`ref-04`） |
| 品牌 | `/branding` | — |
| 颜色 | `/color` | ✅ `ref-04-color-dark-mode.md` |
| 深色模式 | `/dark-mode` | ✅ `ref-04-color-dark-mode.md` |
| 图标 | `/icons` | 部分（`ref-06`） |
| 图像 | `/images` | 部分（`ref-04`） |
| 沉浸式体验 | `/immersive-experiences` | 部分（`ref-07`） |
| 包容性 | `/inclusion` | 部分（`ref-01`、`ref-04`） |
| 布局 | `/layout` | ✅ `ref-02-layout.md` |
| 材质 | `/materials` | 部分（`ref-04`、`ref-06`） |
| 动态效果 | `/motion` | ✅ `ref-07-motion-feedback.md` |
| 隐私 | `/privacy` | 部分（`ref-01`） |
| 从右到左（RTL） | `/right-to-left` | 部分（`ref-02`） |
| SF 符号 | `/sf-symbols` | 部分（`ref-03`、`ref-06`） |
| 空间布局 | `/spatial-layout` | 部分（`ref-02`、`ref-07`） |
| 字体排印 | `/typography` | ✅ `ref-03-typography.md` |
| 编写（文案） | `/writing` | 部分（`ref-06`） |
| 旁白 | `/voiceover` | 部分（`ref-05`） |

## 三、模式（Patterns）

`/patterns` 下全部条目 → 见 `ref-08-patterns.md` 的模式主题索引表：
图表化数据、协作与共享、拖放、输入数据、反馈、文件管理、全屏显示、启动、实时查看类 App、
加载、账户管理、通知管理、模态化、多任务、提供帮助、引导与上手、播放音频、触感反馈、
播放视频、打印、评分与评论、搜索、设置、撤销与重做、体能训练

## 四、组件（Components）

`/components` 下按主题分组：

| 分组 | 链接 | 典型组件 |
|---|---|---|
| 内容 | `/content` | 图表、图像视图、文本视图、网页视图 |
| 布局和组织 | `/layout-and-organization` | 集合、列表、表格、分割视图、标签页栏、边栏、窗口、工具栏 |
| 菜单和操作 | `/menus-and-actions` | 按钮、菜单、上下文菜单、活动视图、工具栏项、下拉式按钮、弹出式按钮 |
| 导航和搜索 | `/navigation-and-search` | 导航栏、路径控制、搜索栏、搜索字段、页面控制 |
| 呈现 | `/presentation` | 提醒、表单、弹出窗口、操作表单、模态视图 |
| 选择和输入 | `/selection-and-input` | 选择器、切换、文本字段、滑块、步进器、分段控制、组合框 |
| 状态 | `/status` | 进度指示符、活动指示器、评分指示器 |
| 系统体验 | `/system-experiences` | 小组件、实时活动、通知、复杂功能、灵动岛 |

## 五、输入（Inputs）

`/inputs` — 各类输入方式的设计指南：触控（轻点/轻扫/长按）、指针与鼠标、键盘、
遥控器与焦点、游戏控制器、眼动与手势（visionOS）、语音、Apple Pencil、相机控制等。

## 六、技术（Technologies）

`/technologies` — 整合 Apple 具体技术时的设计指南：Apple Pay、App Clips、
CarPlay、Game Center、HealthKit、HomeKit、iCloud、In-App Purchase、Live Activities、
Mac Catalyst、MapKit、Messages、ShazamKit、Sign in with Apple、SharePlay、
ShazamKit、Siri、Tap to Pay、Wallet 等。

## 七、平台（Platforms）

| 平台 | 关注重点 |
|---|---|
| iOS | 触控、安全区（灵动岛）、横竖排、避免全宽按钮 |
| iPadOS | 窗口缩放、分屏多任务、可转换标签页栏、外接显示器 |
| macOS | 指针与键盘、窗口与菜单栏、避免底部关键控制、桌面着色 |
| Apple tvOS | 焦点与遥控器、大屏安全区（上下 60pt / 左右 80pt）、网格规范 |
| visionOS | 空间布局、深度与视场、眼动/手势、舒适性与眩晕控制、Liquid Glass |
| watchOS | 极简交互、胶囊按钮、全宽主要操作、避免加载指示符、自动旋转 |

## 八、使用建议

1. 本技能 `ref-01` ~ `ref-08` 覆盖了**高频、可量化、易踩坑**的规约，日常任务足够。
2. 遇到下列情况必须回到官方原文：
   - 需要**具体组件的完整规则**（如提醒、表单、菜单、侧边栏的细节）
   - 需要**平台专属数值**（新机型尺寸、tvOS 网格各列规格、visionOS 尺寸级别）
   - 需要**最新变更**（HIG 随系统版本更新，如 Liquid Glass 材质、新机型规格）
3. 抓取官方页面时注意区分**中文版与英文版**：
   - 中文版：`developer.apple.com/cn/design/human-interface-guidelines/<topic>`
   - 英文版：`developer.apple.com/design/human-interface-guidelines/<topic>`
