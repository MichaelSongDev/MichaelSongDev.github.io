+++
date = '2025-11-19T12:57:21+08:00'
draft = false
title = 'BUAA OOpre 2025课程总结'
categories = ["OO"]
tags = ["Java", "OO"]
[toc]
  enable = true
+++
<!--more-->
## 架构设计
### 最终架构设计
**架构设计如下**  
![整体架构设计](https://gitee.com/michsong/blog-images/raw/master/src-1.png)
**依赖关系如下**  
![依赖关系](https://gitee.com/michsong/blog-images/raw/master/src_dependence.png)
**各类所实现方法如下**  
![方法](https://gitee.com/michsong/blog-images/raw/master/src_function-1.png)
**架构详解**
- `adventurer`
    - `Adventurer`:核心类，存储冒险者属性值，存活状态，拥有与携带的物品/学习的魔法，金钱系统，上下级关系，实现冒险者可进行的操作
    - `Use`:实现使用物品逻辑
    - `Fight`:实现战斗逻辑
- `usable`
    - `Usable`:可用物品接口，定义了`getType()`与`Use()`两个行为
- `item`
    - `Item`:所有item的父类，存储`id`
    - `bottle`:package，实现`Bottle extends Item implements Usable`，并实现不同种类的药水瓶，均继承自Bottle类，重写各自的`getType()`与`Use()`
    - `equipment`:package，实现`Equipment extends Item`，存储`ce`,并实现不同种类的武器，均继承自Equipment类，重写各自的`getType()`
- `spell`
    - `Spell`:所有spell的父类，存储`id`，`manacost`，`power`，并实现`Usable`接口
    - `AttackSpell`与`HealSpell`:均继承自Spell，并重写各自的`getType()`与`Use()`
- `container`
    - `Container`:所有容器的父类，封装`Map<String, Object>`及常用操作，便于冒险者物品管理
    - `PackContainer`:背包，使用`LinkedHashMap<String, Object>`以保证容器有序，并根据题目要求重写`addObject`与`removeObject`逻辑
    - `其他Object`:负责管理对应物品，除父类所提供方法外未实现其余方法
- `store`
    - `Store`:实现商店，使用`工厂模式`
- `lexer`
    - `Lexer`:词法分析系统，解析lr指令时负责提供下一个`token`
- `command`
    - `InputParse`:输入解析
    - `Command`:指令接口，定义`run()`行为
    - `CommandCall`:根据指令实例化不同的指令类，并通过`run()`方法执行指令
    - `指令类`:均实现`command`接口，重写`run()`方法以实现各自指令行为
- `MainClass`:全局入口函数，存储所有的`adventurers`，调用`InputParse`进行输入解析并传入`CommandCall`进行指令的调用
### 架构调整与考虑
1. 使用package进行管理，使架构更为清晰
2. 将指令处理部分从`MainClass`独立出来，便于指令扩展与维护，并使`MainClass`只实现全局入口功能
3. 实现单独的容器类，单独处理不同容器的特异性功能，增强代码的拓展性，使`Adventurer`类更加清晰，便于维护
4. 将`Fight`与`Use`逻辑从Adventurer中分离，因这两部分具有良好的独立性，且逻辑较为复杂，同时是Adventurer与其他Adventurer交互的核心方式，故将其分离有利于拓展与复用；且逻辑上这两者为Adventurer的行为，并不适合通过实例化一个Fight或Use类的对象来实现操作，故将方法设定为`static`
5. 在实现冒险者的具体操作时，因为无法保证在其他地方调用或在之后的数次迭代中，我们能够传给方法的数据类型（比如我在调用时只拿到了id还是已经拿到了id的具体对象），故在实现时均作了函数的重载，可以在其他地方调用时更加的自然顺畅
6. 可优化部分：
    1. 在全局中管理冒险者，不利于代码的拓展，因迭代中未对冒险者管理提出过强的要求，故未对此进行重构
    2. 多次使用instanceof判断对象类型，可进行优化，将操作行为进一步封装，以更好的利用多态性来增强代码的可读性与可维护性
## JUnit心得体会
通过Junit的使用，我学会了
- 自动化测试方法
- 按照功能进行测试的意识，即将代码逻辑按照功能划分，对每一功能独立测试，提高测试的准确性
## 学习OOPre的心得体会
- 初步建立了面向对象的思想，即以**对象**为核心，一切操作均为对象的操作；将一个类型的对象的属性与方法封装在一起，通过可见性保证操作的安全
- 面向对象的思维方式是比面向过程更加自然的，虽然在码量上有所增加，但面向对象代码的可读性、扩展性与书写难度相较面向过程都有极大的提升，也更加适合大型工程的构建
- 不可否认的是，面向对象编程中，每一个具体逻辑的底层实现仍然是面向过程的，但是通过**封装**，我们在实现或使用某一功能时无需关注其具体的逻辑，甚至在**继承**、**多态**、**接口**等特性加持下，我们甚至无需关注所操作数据/对象的具体类型，或者说，面向对象的过程，核心是管理架构的过程
- 类的封装、继承、多态不仅是面向对象思想核心的体现，同时也为“减少代码复用”“开闭原则”等公认代码原则提供了很好的解决方案
- **官方库**的使用：作为现代语言，Java类库不仅提供了基础的系统操作，同时也为常用数据结构（如链表、栈、队列、哈希表）等进行了封装，使用类库不仅可以提高编程效率，同时正确性与运行效率也得到了保障
## 对OOPre的课程建议
- 希望加强中测数据点的强度
- AND，感谢每一位老师助教的辛苦付出！