# 🧠 Source Code Learning

This repository contains my deep dive into popular open-source projects, focusing on understanding their architecture, core principles, and design patterns.

> I focus on "how it works" rather than "how to use it".

---

## 🎯 Goals

* Understand core architecture of modern frameworks (React / Vue)
* Learn how large-scale systems are designed
* Extract reusable design patterns
* Improve system design & engineering thinking

---

## 📚 Contents

### ⚛️ React

* Hooks implementation (useState / useEffect)
* Fiber architecture
* Rendering & reconciliation process

### 🟢 Vue

* Reactivity system
* Dependency tracking
* Virtual DOM

### 🔷 TypeScript

* Type system basics
* Compiler workflow

---

## 🔍 Deep Dive

### React Hooks

* Linked list structure for hooks
* Update queue mechanism
* How React tracks state across renders

**Key Insight**

React stores hooks in a linked list attached to Fiber nodes, rather than simple variables.

---

## 🧩 Methodology

When reading source code, I focus on:

1. Entry point (where execution starts)
2. Core data structures (Fiber, Hooks, etc.)
3. Execution flow (render → commit)
4. Design trade-offs

---

## 📈 Progress

* [x] React Hooks
* [ ] React Fiber
* [ ] Vue Reactivity
* [ ] TypeScript Compiler

---

## ⚡ Notes

This is not just a note repository, but a collection of my understanding of system design through real-world source code.
