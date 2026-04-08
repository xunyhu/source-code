# React 源码“学习地图（Fiber + Hooks 全执行链路图解版）

## 🧠 一、React 更新的全流程总览（核心主线）

一句话版本：`一次 setState = 发起更新 → 调度 → render（reconcile）→ commit（真实 DOM）`

完整链路：

```txt
setState / dispatchAction
        ↓
scheduleUpdateOnFiber
        ↓
ensureRootIsScheduled
        ↓
performConcurrentWorkOnRoot
        ↓
renderRoot / workLoop
        ↓
beginWork / completeWork（Fiber Diff）
        ↓
commitRoot
        ↓
mutation / layout / passive effects
```

## ⚙️ 二、React Fiber 架构核心模型

### 🌲 Fiber 本质是什么？

Fiber = 链表化的 React Element 工作单元

结构：

```text
Fiber Node
 ├── child      → 第一个子节点
 ├── sibling    → 下一个兄弟节点
 └── return     → 父节点
```

👉 形成一棵“可中断的链表树”

### 🔁 双缓存机制（非常关键）

React 同时维护两棵树：

```txt
current Fiber Tree   → 当前页面显示的
workInProgress Tree  → 正在构建的
```

切换时：

```txt
commitRoot 完成后
workInProgress → current
```

👉 这就是“无刷新更新 UI”的本质

## 🚀 三、setState 发生了什么（核心链路）

以 Class Component 为例：this.setState({})

### 👉 Step 1：创建 update

```js
enqueueSetState
  → createUpdate
  → push 到 updateQueue
```

### 👉 Step 2：进入调度系统

scheduleUpdateOnFiber(fiber)

做三件事：

找 root
标记 lane（优先级）
请求调度

### 👉 Step 3：进入 Scheduler（时间切片）

```js
ensureRootIsScheduled
  ↓
performConcurrentWorkOnRoot
```

👉 React 18 开始支持：

time slicing（时间切片）
可中断渲染

## 🧩 四、Render 阶段（Reconciliation）

核心文件：

```text
ReactFiberWorkLoop.js
ReactFiberBeginWork.js
```

### 🔥 workLoop（核心循环）

```js
while (workInProgress !== null) {
  performUnitOfWork();
}
```

### 🔍 beginWork（Diff发生地）

每个 Fiber：beginWork(current, workInProgress)
做：

- props 对比
- children diff
- 复用 or 新建 fiber

### 🔚 completeWork

做：

- 标记 effect（插入/更新/删除）
- 构建 DOM（但不挂载）

## 💥 五、Commit 阶段（真正改 DOM）

### 1️⃣ before mutation（DOM 前）

useEffect 订阅准备
layout effect 处理准备

### 2️⃣ mutation（核心 DOM 操作）

👉 真正操作 DOM：

插入
删除
更新

文件：

```text
commitPlacement
commitDeletion
commitUpdate
```

### 3️⃣ layout（同步 effect）

useLayoutEffect 执行
ref 绑定

### 4️⃣ passive（useEffect）

useEffect → commitPassiveEffects

## 🪝 六、Hooks 完整执行链（重点）

核心文件：ReactFiberHooks.js

### 🧠 1. renderWithHooks（入口）

renderWithHooks()

发生：

- 初始化 hooks 链表
- 设置 dispatcher

### 🔁 2. Hooks 是“链表结构”

每个 hook：

```txt
Hook Node
 ├── memoizedState
 ├── next
 ├── queue
```

### ⚡ 3. useState 本质

mount：mountState

创建：

- hook
- queue
- initial state

update：

```js
dispatchAction
  ↓
enqueueUpdate
  ↓
scheduleUpdateOnFiber
```

### 🚨 为什么 hooks 不能写 if？

因为 hooks 是： “按顺序读取链表”

```js
if (a) {
  useState();
}
```

👉 链表顺序错乱 → state 对不上

## 🔄 七、完整一条链（面试必背）

⭐ setState → DOM 更新全链路

```txt
setState
  ↓
enqueueUpdate
  ↓
scheduleUpdateOnFiber
  ↓
render phase
  ↓
beginWork (diff)
  ↓
completeWork
  ↓
commitRoot
  ↓
DOM更新
  ↓
useLayoutEffect
  ↓
浏览器绘制
  ↓
useEffect
```

## 🧭 八、React 18 之后的关键变化

🧠 并发更新（Concurrent Rendering）

新增：

可中断 render
lane 优先级系统
transition（useTransition）

🔥 lane 系统（优先级）

```text
SyncLane
InputContinuousLane
DefaultLane
IdleLane
```

👉 替代旧 expirationTime

## 🎯 九、你应该怎么用这张“地图”学习源码

✔ 第一遍（理解结构）

只看：

scheduleUpdateOnFiber
workLoop
commitRoot

✔ 第二遍（深入 hooks）

renderWithHooks
mountState
dispatchAction

✔ 第三遍（调试）

在源码打断点：

ReactFiberHooks.js
ReactFiberWorkLoop.js
