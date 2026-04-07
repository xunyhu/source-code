# React 源码“正确阅读路径”

## ① React 是怎么“开始渲染”的

```txt
react-reconciler
  └── ReactFiberWorkLoop.js
```

👉 入口核心：

- scheduleUpdateOnFiber
- performSyncWorkOnRoot

## ② Fiber 是怎么工作的

```txt
ReactFiber.js
ReactFiberWorkLoop.js
ReactFiberBeginWork.js
```

## ③ Hooks 核心

```txt
ReactFiberHooks.js
```

## ④ React DOM 如何落地

```txt
react-dom-bindings/
```
