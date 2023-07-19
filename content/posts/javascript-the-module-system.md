---
title: "JavaScript <The Module System>"
date: 2023-02-19T17:18:00+08:00
draft: true
tags: [javascript]
description: 
---

![blueandread-galaxy]

## 模組系統可以解決哪些問題

- 將代碼重新組織分割成不同的檔案
- 提升可重用性
- 封裝處理

## 天生缺陷

每一種程式語言或多或少都會有些天生的功能缺陷，也許這不是它當初被發明出來的目的所以沒有被納入設計考量到或其他因素導致，JavaScript就缺乏了原生的模組系統，這個功能在不同的程式語言底下有不同的稱呼，像是`package`, `library`等等，實現方法跟技術細節也許不同但它們都是用來解決類似的問題

## 解決方案 

- HTML Script Element
- Asynchronous Module Definition (AMD)
- Universal Module Definition (UMD)
- CommonJS (CJS)
- ES Modules (ESM)

## Cookbook

在JavaScript裡我們沒有辦法透過`public`, `private`這類的存取修飾詞(access modifiers)來設定物件的scope，因此我們會透過其他手段來達成相同的目的

### IIFE (Immediately Invoked Function Expression)

{{< gist tarmacChen 0ebdb56e91ef9075fd3121cc9e8ad552 >}}

### The Revealing Module Pattern

{{< gist tarmacChen 877b3b58e62af06c47d2f88a4841e743 >}}

### Named exports

### Exporting a function

### substack pattern

### Exporting a class

### Exporting a instance

### Modifying other modules (Monkey Patching)

## ESM (ECMAScript Modules)

[blueandread-galaxy]: /img/blueandred-galaxy.jpg