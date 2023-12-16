---
title: "Web API 版本控制"
date: 2023-12-17T05:59:51+08:00
draft: false
tags: ["WebAPI"]
description: "為什麼要替 Web API 做版本控制"
---

## 為什麼要替 Web API 做版本控制?

> 這邊的版本控制是指某個 Web API 因為某些因素改變了內部的實作，導致沒有辦法向下兼容，一旦 API 對外發佈了就要保證消費者呼叫後得到的結果其結構永遠不變

例如有個 API 呼叫後可以得到客戶 ID 為 001 的相關資料

> company.com/api/customer/001

最一開始呼叫時得到結果

`{
  "id": 001,
  "name": "Jack Johnson",
}`

過了一段時間再次呼叫 API 卻得到了

`{
  "id": 001,
  "firstName": "Jack",
  "lastName": "Johnson",
}`

因為 API 設計初期考慮不周，消費者在呼叫時總是需要自行將客戶的姓名做進一步的處理，才能得到客戶的姓氏與名字，於是開發團隊很快的改變了 API 回應的數據結構，這樣的變動就會導致先前呼叫 API 的人要調整自己的程式碼，才能得到正確的客戶姓名

## 在 URL 中加入版本識別

為了避免這種情況發生，我們可以在 API 請求的 url 中加入版本控制的路由，確保呼叫 API 的人清楚明白自己呼叫了哪個版本的 API，進一步會得到什麼樣的回應

> company.com/api/**v1**/customer/001

後續的 API 內部異動如果沒有辦法向下兼容就做版本遞增

> company.com/api/**v2**/customer/001

這麼一來呼叫 API v1 的人始終可以得到

`{
  "id": 001,
  "name": "Jack Johnson",
}`

而呼叫 API v2 的人可以得到

`{
  "id": 001,
  "firstName": "Jack",
  "lastName": "Johnson",
}`

## 在域名中加入版本識別

我們也可以這樣做，用域名來區分現在呼叫的 API 是什麼版本

> v1.api.company.com/customer/001

這也是一個解決方案，但這樣的設計會有很多衍生問題需要處理
