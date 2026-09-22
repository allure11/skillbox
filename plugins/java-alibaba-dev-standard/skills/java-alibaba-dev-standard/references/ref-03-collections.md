# 一、编程规约

> 级别含义：**【强制】** 必须遵守，违反构成代码缺陷；**【推荐】** 默认遵守，特殊情况需说明理由；**【参考】** 酌情参考。
> 来源：《Java 开发手册（嵩山版）》一、编程规约。开发涉及本章领域时必须查阅并对照执行。


## 集合处理

1. 【强制】 关于 hashCode 和 equals 的处理，遵循如下规则：

2. 【强制】 判断所有集合内部的元素是否为空，使用 isEmpty()方法，而不是 size()==0 的方式。

3. 【强制】 在使用 java.util.stream.Collectors 类的 toMap()方法转为 Map 集合时，一定要使

4. 【强制】 在使用 java.util.stream.Collectors 类的 toMap()方法转为 Map 集合时，一定要注

5. 【强制】 ArrayList 的 subList 结果不可强转成 ArrayList，否则会抛出 ClassCastException 异

6. 【强制】 使用 Map 的方法 keySet()/values()/entrySet()返回集合对象时，不可以对其进行添

7. 【强制】 Collections 类返回的对象，如：emptyList()/singletonList()等都是 immutable list，

8. 【强制】 在 subList 场景中，高度注意对父集合元素的增加或删除，均会导致子列表的遍历、

9. 【强制】 使用集合转数组的方法，必须使用集合的 toArray(T[] array)，传入的是类型完全一

10. 【强制】 在使用 Collection 接口任何实现类的 addAll()方法时，都要对输入的集合参数进行

11. 【强制】 使用工具类 Arrays.asList()把数组转换成集合时，不能使用其修改集合相关的方法，

12. 【强制】 泛型通配符<? extends T>来接收返回的数据，此写法的泛型集合不能使用 add 方法，

13. 【强制】 在无泛型限制定义的集合赋值给泛型限制的集合时，在使用集合元素时，需要进行

14. 【强制】 不要在 foreach 循环里进行元素的 remove/add 操作。remove 元素请使用 Iterator

15. 【强制】 在 JDK7 版本及以上，Comparator 实现类要满足如下三个条件，不然 Arrays.sort，

16. 【推荐】 集合泛型定义时，在 JDK7 及以上，使用 diamond 语法或全省略。

17. 【推荐】 集合初始化时，指定集合初始值大小。

18. 【推荐】 使用 entrySet 遍历 Map 类集合 KV，而不是 keySet 方式进行遍历。

19. 【推荐】 高度注意 Map 类集合 K/V 能不能存储 null 值的情况，如下表格：

20. 【参考】 合理利用好集合的有序性(sort)和稳定性(order)，避免集合的无序性(unsort)和不稳

21. 【参考】 利用 Set 元素唯一的特性，可以快速对一个集合进行去重操作，避免使用 List 的

