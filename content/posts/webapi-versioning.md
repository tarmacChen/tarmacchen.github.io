---
title: "Web API 版本控制"
date: 2023-12-17T05:59:51+08:00
draft: false
tags: ["web api"]
description: "為什麼要替 Web API 做版本控制"
---

## 為什麼要替 Web API 做版本控制?

> 這邊的版本控制是指某個 Web API 因為某些因素改變了內部的實作，導致沒有辦法向下兼容，一旦 API 對外發佈了就要保證消費者呼叫後得到的結果其結構永遠不變

例如有個 API 呼叫後可以得到客戶 ID 為 001 的相關資料

```bash
> curl "company.com/api/customer/001"
{
  "id": "001",
  "name": "Jack Johnson",
}`
```

過了一陣子再次呼叫 API 卻得到了

```bash
> curl "company.com/api/customer/001"
{
  "id": "001",
  "firstName": "Jack",
  "lastName": "Johnson",
}
```

因為該 API 設計初期考慮不周，消費者在呼叫時總是需要自行將客戶的姓名做進一步的處理，才能得到客戶的姓氏與名字，於是開發團隊改變了 API 回應的數據結構，這樣的變動就會導致先前呼叫 API 的人要調整自己的程式碼，才能得到正確的客戶姓名

## 解決方案

### 用 URL 區分版本

為了避免這種情況發生，我們可以在 API 請求的 url 中加入版本控制的路由，確保呼叫 API 的人清楚明白自己呼叫了哪個版本的 API，進一步會得到什麼樣的回應

`company.com/api/v1/customer/001`

後續的 API 異動如果沒有辦法向下兼容就做版本遞增

`company.com/api/v2/customer/001`

這麼一來呼叫 API v1 的人始終可以得到

```bash
> curl "company.com/api/v1/customer/001"
{
  "id": "001",
  "name": "Jack Johnson",
}
```

而呼叫 API v2 的人可以得到

```bash
> curl "company.com/api/v2/customer/001"
{
  "id": "001",
  "firstName": "Jack",
  "lastName": "Johnson",
}
```

### 用 Domain 區分版本

我們也可以這樣做，用 Domain 來區分現在呼叫的 API 是什麼版本，不同的 API 版本使用不同的 Domain

`v1.api.company.com/customer/001`

這也是一種解決方案，但這樣的設計會有很多衍生問題需要處理

#### Domain 中的 API 版本辨識符號要放在域名的前綴或後綴?

`v1.api.company.com/customer/001`

`company.com.api.v1/customer/001`

`api.v1.company.com/customer/001`

> 別忘了我們變動的可是 Web API 的 Domain，這個調整造成的副作用遠比改變單一接口的返回數據結構影響來得大多了，每一次調整都要購買或租用新的 Domain，同時要告知所有使用到此 API 的消費者這個訊息...
>
> 嘿! 我們換了 API 的 Domain 哦，我不曉得對你們的影響有多大，祝你好運!

#### 跨來源資源共用 Cross-Origin Resource Sharing (CORS)

`company.com`，設計了這個 API 的公司網站需要呼叫 API 進一步取得訂單資料

因為 v1 版的 API 沒有取得訂單資料的接口，所以必須先呼叫 v2 版的 API

`v2.api.company.com/order/sn314056`

> :warning: Access to XMLHttpRequest at 'http://v2.api.company.com/order/sn314056' from origin 'http://company.com' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.

安全性考量，當你從一個網站嘗試取得其他來源（網域）的資源時會被阻擋，你只能取得與應用程式相同網域底下的資源

Web API Server 必須調整 Response 的 Header 來告訴瀏覽器允許 Host 來自`company.com`的請求

```bash
# on server (v2.api.company.com)
access-control-allow-origin: company.com
```

調整之後我們成功取得了訂單資料

```json
{
  "orderId": "sn314056",
  "customer": {
    "id": "001"
  },
  "items": [{ "name": "Learning JavaScript" }]
}
```

取得訂單資料後我想知道下這筆訂單的客戶他的名字是什麼，所以我利用客戶的 ID 再做一次查詢

`v1.api.company.com/customer/001`

> :warning: Access to XMLHttpRequest at 'http://v1.api.company.com/customer/001' from origin 'http://company.com' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.

因為 v1 的 Web API Server 是另一台機器，需要做相同的調整才能順利取得資料

```bash
# on server (v1.api.company.com)
access-control-allow-origin: company.com
```

終於有了...

```json
{
  "id": "001",
  "name": "Jack Johnson"
}
```

`在 Domain 中加入版本識別符`來做 Web API 的版本控制看來不是一個理想的方法，沒有絕對的理由應該盡量避免使用

### 用 Parameter 區分版本

如果要用這種解決方案，第一個要決定用來識別 API 版本的參數名稱

`api.company.com/customer/001?v=1`

`api.company.com/customer/001?apiversion=1`

`api.company.com/customer/001?api=v1`

假設我們決定使用第一種命名風格，在 Web API Server 對應的 endpoint 中要加入取得 API 版本資訊及在不同版本底下要如何處理的相關邏輯

> 這邊用 Node.js 的 Express 做為代碼範例

```js
const express = require("express");
const app = express();

app.get("/customer/:id", function (req, res) {
  let apiVersion = req.query.v;
  if (apiVersion == 1) {
    // do something
  }
  if (apiVersion == 2) {
    // do something
  }

  // when apiVersion is empty or other value, need to do something else to handle
});
```

這個解決方案有什麼副作用？

1. 每個 endpoint 都要加入判斷調用版本的邏輯代碼
2. 參數的名稱如果變動了，Web API 的 Provider 跟 Consumer 都要做調整
3. 用來識別 API 版本的參數名稱傳錯了，要怎麼處理?

## 結語

在本篇文章中思考了三種解決方案來處理 Web API 版本控制的問題，當然還有像是在表頭上加入 X-API-Version 等等其他做法，整體看來 `用 URL 區分版本` 似乎是最理想的做法，帶來最少的副作用且好調整好維護，API 版本控制不得不做，除非你的 API 永遠不會更新迭代
