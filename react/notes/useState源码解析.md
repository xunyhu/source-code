# useState 源码解析

React Hooks 本质是三层结构：

```txt
React API 层 (useState等)
   ↓
Dispatcher（当前环境）
   ↓
Hooks 实现（Fiber + 链表 + queue）
```

## useState 全链路

react 暴露的 API

```js
exports.useState = function (initialState) {
  return resolveDispatcher().useState(initialState);
};
```

### 1️⃣ resolveDispatcher

```js
function resolveDispatcher() {
  return ReactSharedInternals.H;
}
```

👉 拿到当前 Dispatcher

### 2️⃣ 当前 Dispatcher 是谁？

在 render 时被设置：

```js
ReactSharedInternals.H = HooksDispatcherOnMount;
```

或

```js
ReactSharedInternals.H = HooksDispatcherOnUpdate;
```

### 3️⃣ Dispatcher 结构

```js
const HooksDispatcherOnMount = {
  useState: mountState,
};

const HooksDispatcherOnUpdate = {
  useState: updateState,
};
```

### 4️⃣ 所以真实调用的是：

首次渲染：useState → mountState

更新时：useState → updateState

## mountState 做了什么（第一次渲染）

核心代码（简化）：

```js
function mountState(initialState) {
  const hook = mountWorkInProgressHook();

  hook.memoizedState = initialState;

  const queue = {
    pending: null,
    dispatch: null,
  };

  hook.queue = queue;

  const dispatch = dispatchSetState.bind(null, currentlyRenderingFiber, queue);
  queue.dispatch = dispatch;

  return [hook.memoizedState, dispatch];
}
```

### 🔥 核心点拆解

####　1️⃣ hook 链表
const hook = mountWorkInProgressHook();

👉 本质是：

fiber.memoizedState = {
memoizedState: xxx,
next: nextHook
}

👉 Hooks 是一个单向链表

#### 2️⃣ 状态存储

hook.memoizedState = initialState;

👉 真正的 state 存在这里

#### 3️⃣ queue（更新队列）

const queue = {
pending: null
};

👉 用来存 setState 的更新

#### 4️⃣ dispatch（关键）

const dispatch = dispatchSetState.bind(null, fiber, queue);

👉 setState 本质就是这个函数

## setState 发生了什么

当你调用：

setCount(1);

其实执行的是：

dispatchSetState(fiber, queue, action)

核心逻辑：

```js
function dispatchSetState(fiber, queue, action) {
  const update = {
    action,
    next: null,
  };

  // 放入 queue（环形链表）
  queue.pending = update;

  scheduleUpdateOnFiber(fiber);
}
```

🔥 关键点

1️⃣ update 是链表

update.next = update;

👉 React 用的是 环形链表

2️⃣ 不会立刻更新 UI

👉 只是：

收集更新 → 调度 → 下一轮 render

## updateState 做了什么（更新阶段）

```js
function updateState() {
  const hook = updateWorkInProgressHook();
  const queue = hook.queue;

  let baseState = hook.memoizedState;

  const pendingQueue = queue.pending;

  if (pendingQueue !== null) {
    // 遍历更新链表
    let first = pendingQueue.next;

    do {
      const action = update.action;
      baseState = reducer(baseState, action);
      update = update.next;
    } while (update !== first);

    hook.memoizedState = baseState;
  }

  return [hook.memoizedState, queue.dispatch];
}
```

## 最核心的 3 个本质

🔥 1️⃣ Hooks = 链表

🔥 2️⃣ useState = 读取当前 hook 节点

currentHook 指针依次向后移动

👉 这就是为什么：

Hooks 不能写在 if 里

🔥 3️⃣ setState = 往队列里塞 update

## 一张完整流程图

```js
useState()
   ↓
resolveDispatcher()
   ↓
ReactSharedInternals.H
   ↓
Dispatcher.useState
   ↓
mountState / updateState
   ↓
hook.memoizedState（存 state）
   ↓
queue.pending（存更新）
   ↓
dispatchSetState（触发更新）
   ↓
scheduleUpdateOnFiber（调度）
```
