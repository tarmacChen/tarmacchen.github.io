---
title: "Authentication 驗證"
date: 2024-01-26T14:37:40+08:00
draft: false
tags: [Security, Authentication]
description:
---

## 1. 妥善保存使用者的密碼

### 不要也不應該直接保存使用者的密碼

| username | password |
| -------- | -------- |
| jessica  | 123      |

直接保存使用者的密碼是一件很危險的事情，一旦選擇幫客戶保存密碼，後續就要做很多機制來防範資料外洩或其他資安問題，同時讓系統管理者能直接看到客戶的密碼也不是正確的事情，一勞永逸的方法是讓使用者自行保管密碼，服務器永遠不替使用者保存記憶，服務器只保存用來驗證密碼正確性的公鑰。

---

### Salt

我們可以在使用者註冊帳號時，先產生一組專屬使用者的公鑰，像這樣用途的公鑰我們統稱為 salt，salt 必須為隨機生成的一組文字通常用 base64 的編碼方式產生，在註冊成功時連同使用者資料一起保存下來，並在必要時才做異動(變更密碼)。

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI="
}
```

### Hash

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI=",
  "password" : "ea627a55bbd5b29066e5debc714943b2303fc28043caec714ea58390ccf23767""
}
```

我們利用使用者的 salt 與註冊時設定的密碼，加上後續的加密計算後後會得到一組文字我們稱為 hash(雜湊值)，hash 也會保存在使用者帳戶的資料內，用來驗證之後的嘗試登入。

### 驗證密碼的正確性

當使用者註冊完成後要登入帳號時，我們拿使用者的 salt 加上嘗試登入輸入的密碼去做計算，看得到的 hash 是不是和當初註冊帳號時計算出來的 hash 相同，就能夠推斷出密碼是否輸入正確。

## 2. 記住使用者的登入狀態

使用者的帳號密碼搞定了，現在我們來思考要怎麼讓客戶端(通常是瀏覽器)在登入完成後記住登入狀態，才不用在每次加載頁面後還要再做一次登入才能使用。

### SessionToken

我們前面利用註冊時得到的 Salt 加上使用者設定的密碼，得到了一組可以用來驗證密碼是否正確的 Hash 對吧？

同樣的，我們可以在每次登入時先取得一組隨機產生的 salt ，與使用者帳號(最好是 unique key)做計算來產生一組新的 hash，這組 hash 可以用來驗證使用者是否已經登入過，像這種用途的 hash 我們稱為 sessionToken。

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI=",
  "password": "ea627a55bbd5b29066e5debc714943b2303fc28043caec714ea58390ccf23767",
  "sessionToken": "d23b0f67ec8f30def212893e5b0f859a1602ac58f9cfe37c721cf22625990afb"
}
```

> 使用者帳戶資料裡的 salt 是註冊帳號時得到的，只用來驗證後續嘗試登入時輸入的密碼是否正確。

> 從客戶端登入帳號時得到的 salt 不會做任何保存動作，每次的登入都會產生不同的 salt，產生後只用來做一次嘗試登入，無倫登入是否成功使用完都會直接拋棄，客戶端只會保存登入成功後得到的 sessionToken

#### 用 cookie 或 localStorage 在瀏覽器內保存 token

```js
document.cookie =
  "user_session=d23b0f67ec8f30def212893e5b0f859a1602ac58f9cfe37c721cf22625990afb";
```

```js
localStorage.setItem(
  "user_session",
  "d23b0f67ec8f30def212893e5b0f859a1602ac58f9cfe37c721cf22625990afb"
);
```

> 通常這種用途的 token 具有時效性且必須在同一個客戶端底下才能使用，我們才會稱這種 token 為 sessionToken 而不是普通的 token，也因為這樣我們可以利用這種特性判斷使用者是否已經在其他地方登入過，若在不同的地方登入會讓既有的 token 被覆蓋掉，進而實現重置登入狀態的效果。
