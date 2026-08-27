---
name: java-alibaba-dev-standard
description: 阿里《Java 开发手册（嵩山版）》编码规范强制遵循技能。当任务涉及编写、修改、评审 Java 代码（含 Spring/SpringBoot/MyBatis 等生态）、SQL 表结构/索引设计、接口设计、异常与日志处理、并发编程、单元测试、安全防护时，必须加载本技能并严格遵守其中的【强制】条款。触发词：Java 开发、写 Java 代码、代码评审、Review、建表、SQL 优化、MyBatis、Spring 编码、阿里规范、Java 开发手册、写单元测试、接口安全。本技能是 Java 编码任务的最高优先级规范来源，任何代码交付前必须对照自查清单检查。
agent_created: true
---

# Java Alibaba Dev Standard（阿里 Java 开发手册·嵩山版）

## Overview

本技能固化《Java 开发手册（嵩山版）》全部 **308 条**规约（**强制 181 / 推荐 91 / 参考 36**），
作为所有 Java 编码、评审、建表、接口设计任务的强制规范来源。写出的每一行代码都须符合【强制】条款，
【推荐】条款默认遵守（偏离需向用户说明理由）。

规范分两级加载：
- 本文件：内置 **核心强制条款**（高频易犯项，每次开发必读）+ 交付前自查清单
- `references/`：**全量 308 条**，遇到对应场景必须查阅对应文件对照执行

## 强制工作流（每次 Java 任务都必须走完）

### 第 1 步 · 开工前声明规范范围
动手写代码前，先根据任务内容列出本次涉及哪些规范领域，并**必须**打开对应 references 文件：
- 新建类/方法/变量 → `references/ref-01-naming-constants.md`（命名/常量/格式）
- 写业务逻辑/POJO/金额日期 → `references/ref-02-oop-datetime.md`
- 用集合/Stream → `references/ref-03-collections.md`
- 多线程/线程池/锁 → `references/ref-04-concurrency.md`
- 控制流/注释/接口/正则 → `references/ref-05-controls-comments.md`
- 异常处理/日志 → `references/ref-06-exception-logging.md`
- 单元测试/安全 → `references/ref-07-unit-test-security.md`
- 建表/索引/SQL/ORM → `references/ref-08-mysql.md`
- 工程分层/依赖/设计 → `references/ref-09-structure-design.md`

### 第 2 步 · 编码时对照核心条款
每写一段代码，对照下方「核心强制条款」逐项自查；涉及全量条款的场景打开对应 reference 全文核对。
**禁止**出现任何【强制】条款的反例。

### 第 3 步 · 交付前跑一遍自查清单
代码交付（提交/回复用户/评审输出）前，必须对照「交付前自查清单」逐项确认，并**明确告知用户已通过阿里规范自查**；发现违规必须先修正再交付。

## 核心强制条款（高频易犯，每次开发必读）

### 命名与格式
1. 类名 UpperCamelCase（DO/BO/DTO/VO/AO/PO/UID 例外）；方法/参数/变量 lowerCamelCase；常量全大写+下划线；包名全小写单数。
2. 命名禁止拼音与英文混合、禁止中文命名；杜绝随意缩写；数组用 `int[]` 而非 `int args[]`。
3. POJO 布尔属性禁止加 `is` 前缀（序列化陷阱：`Boolean isDeleted` 的 getter 会被解析成 `deleted`）。
4. 抽象类用 Abstract/Base 开头，异常类 Exception 结尾，测试类 xxxTest 结尾；Service/DAO 实现类用 Impl 后缀。
5. 代码格式：4 空格缩进禁 Tab、单行 ≤120 字符、`if/for/while` 与括号间有空格、运算符两侧空格、UTF-8 + Unix 换行。
6. 魔法值禁止直接出现：`String key = "Id#taobao_" + tradeId;` 是典型故障反例，必须预定义常量。
7. `long` 赋值用大写 `L`：`2l` 会被误读为 `21`。

### OOP 与类型
8. 整型包装类（Integer 等）之间用 `equals` 比较，勿用 `==`（-128~127 缓存区外必错）。
9. 浮点等值判断禁止用 `==`/`equals`，用误差范围或 `BigDecimal.compareTo()`；**禁止** `new BigDecimal(double)`，用 `BigDecimal.valueOf(double)`。
10. 金额一律以最小货币单位整数（分）存储，禁止浮点存钱。
11. `equals` 由常量/确定值对象调用：`Objects.equals(a, b)` 或 `"ok".equals(str)`，勿写 `str.equals("ok")`。
12. 所有覆写方法必须加 `@Override`；不能使用过时（Deprecated）类/方法；构造方法禁止业务逻辑。
13. POJO 必须写 `toString`；禁止同时存在 `isXxx()` 与 `getXxx()`；DO 属性类型与数据库字段类型匹配。
14. 序列化类新增属性不要改 `serialVersionUID`；外部/二方接口禁止改方法签名。
15. 循环内字符串拼接用 `StringBuilder.append`。

### 日期时间
16. 日期 pattern 年份用小写 `yyyy`；区分 `M`（月）/`m`（分）、`H`（24h）/`h`（12h）。
17. 获取当前毫秒用 `System.currentTimeMillis()`，不用 `new Date().getTime()`。
18. 禁止使用 `java.sql.Date`/`java.sql.Time`；不写死一年 365 天。

### 集合处理
19. 集合判空用 `isEmpty()`，不用 `size()==0`。
20. 禁止在 foreach 中 `remove`/`add` 元素，用 Iterator 的 remove。
21. `Arrays.asList()` 返回的集合不能增删（不可变）；`ArrayList.subList` 结果不能强转 ArrayList、且父集合增删会导致子列表遍历异常。
22. `Collectors.toMap()` 注意 value 不能为 null（会 NPE）、key 重复会抛 IllegalStateException。
23. `Collections.emptyList()/singletonList()` 等返回 immutable 集合，不能增删。
24. `keySet()/values()/entrySet()` 返回的集合视图不能增删；`addAll()` 前先判空；集合转数组用 `toArray(T[])`。

### 并发处理
25. 线程池**禁止**用 `Executors` 创建，必须 `new ThreadPoolExecutor(...)` 显式指定参数；线程必须有意义命名；禁止直接 `new Thread`。
26. `SimpleDateFormat` 线程不安全，禁止 static 共享；用 `DateTimeFormatter` 或局部实例。
27. `ThreadLocal` 必须回收（`remove()`），尤其线程池复用场景；`ThreadLocal` 用 static 修饰。
28. 多资源/多表加锁保持一致的加锁顺序；锁内代码块小、锁外处理耗时逻辑；用锁的 try-finally 保证解锁，`lock.lock()` 在 try 外、`unlock()` 在 finally。
29. 高并发避免用「等于」判断做中断/退出条件；`volatile` 解决可见性但不保证原子性。

### 控制语句与注释
30. `if/else/for/while/do` 必须加大括号；switch 的每个 case 必须 break/return 终止（或注释说明）。
31. 三目运算符两分支类型对齐，避免 NPE（自动拆箱陷阱）。
32. 类/属性/方法用 Javadoc（`/** */`）；所有类必须有创建者与创建日期；抽象方法必须 Javadoc；枚举字段必须有注释。

### 异常与日志
33. 禁止 catch 后不处理（至少 `log.error("...", e)` 并给出原因）；不用异常做流程控制。
34. 资源/流对象在 finally 中关闭（或 try-with-resources）；**finally 中禁止 return**（吞掉异常）。
35. 事务场景 catch 到异常需回滚时必须手动回滚（`TransactionAspectSupport.currentTransactionStatus().setRollbackOnly()` 或显式 rollback）。
36. 调用 RPC/二方包/动态代理方法，catch 用 `Throwable`（或 Exception+Error 分类处理），勿只 catch RuntimeException。
37. 日志用 SLF4J 占位符 `log.info("name={}", name)`，禁止字符串拼接；禁止 `System.out` 打日志；trace/debug/info 前做级别开关判断；日志禁止直接 JSON 序列化整个对象；配置 `additivity=false` 防重复打印；异常日志必须含案发现场信息+堆栈。

### 安全规约
38. SQL 参数严格使用预编译绑定（`#{}`），禁止 `String` 拼接 SQL 或 `${}`；用户输入必须参数校验。
39. 用户敏感数据展示必须脱敏；个人页面/功能必须权限校验；输出到 HTML 前转义防 XSS；表单/AJAX 必须 CSRF 校验；URL 外部重定向必须白名单。
40. 短信/邮件/支付/下单等平台资源必须防重放（幂等/令牌）。

### MySQL 与 ORM
41. 表名、字段名小写，禁数字开头、禁双下划线中间只含数字、表名不用复数、禁用保留字；必备字段 `id`/`create_time`/`update_time`。
42. 布尔字段用 `is_xxx` + `unsigned tinyint`（POJO 侧去 is，resultMap 映射）；小数用 `decimal` 禁 float/double；varchar 超 5000 用 text 拆分。
43. 索引命名：主键 `pk_字段`、唯一 `uk_字段`、普通 `idx_字段`；唯一特性字段必须建唯一索引；varchar 索引必须指定长度；禁止左模糊/全模糊搜索（`like '%x'`）。
44. 超过三张表禁止 join；多表查询列名前必须加表别名（t1/t2...）；**禁止 select \***（明确字段列表）；用 `count(*)` 不用 `count(列名)`；禁止外键与级联（应用层解决）；禁止存储过程。
45. ORM 参数用 `#{}` 禁 `${}`；禁止 HashMap/Hashtable 直接作查询结果输出；更新记录必须同步更新 `update_time`；不用 `resultClass` 当返回参数。

### 设计规约
46. 存储方案与数据结构设计须评审通过并沉淀文档；业务状态 >3 个用状态图、调用链对象 >3 个用时序图、模型 >5 个用类图表达。

## 交付前自查清单（必须逐项确认后才能交付）

逐条自问，任一为「否」都不得交付，先修正：
1. 命名是否符合 UpperCamel/lowerCamel/全大写下划线，无拼音、无中文、无魔法值？
2. 集合/Map 操作有无 foreach 增删、subList 强转、toMap 空值、asList 修改等违规？
3. 并发代码是否用 ThreadPoolExecutor、线程命名、SimpleDateFormat/ThreadLocal 是否线程安全？
4. 金额是否整数最小单位存储？浮点/BigDecimal 比较是否正确？
5. 异常是否被捕获且处理、finally 有无 return、资源是否关闭、事务是否回滚？
6. 日志是否 SLF4J 占位符、无 System.out、有级别开关、无整对象 JSON？
7. SQL 是否 `#{}` 绑定、无 `select *`、无左模糊、表别名、count(*)、update_time 同步？
8. 安全：参数校验、脱敏、权限、XSS 转义、CSRF、防重放是否覆盖？
9. 是否按场景查阅了对应的 references 全量文件，而非只凭本文件核心条款？
10. 若违反了任何【推荐】条款，是否已向用户说明理由？

## 用户交付说明

完成任务时向用户说明：「本次代码已按阿里《Java 开发手册（嵩山版）》规范自查，违反【强制】条款 0 处，偏离【推荐】条款 X 处（原因：...）」。

## Resources

- `references/ref-01-naming-constants.md` — 命名风格 / 常量定义 / 代码格式（36 条）
- `references/ref-02-oop-datetime.md` — OOP 规约 / 日期时间（32 条）
- `references/ref-03-collections.md` — 集合处理（21 条）
- `references/ref-04-concurrency.md` — 并发处理（19 条）
- `references/ref-05-controls-comments.md` — 控制语句 / 注释 / 前后端 / 其他（48 条）
- `references/ref-06-exception-logging.md` — 错误码 / 异常处理 / 日志规约（39 条）
- `references/ref-07-unit-test-security.md` — 单元测试 / 安全规约（25 条）
- `references/ref-08-mysql.md` — 建表 / 索引 / SQL / ORM（49 条）
- `references/ref-09-structure-design.md` — 工程结构 / 设计规约（39 条）
