---
title: "Authentication 驗證"
date: 2024-01-26T14:37:40+08:00
draft: false
tags: [Security, Authentication]
description:
---

## 妥善保存使用者的密碼

### 不要也不應該直接保存使用者的密碼（明碼）

| username | password |
| -------- | -------- |
| jessica  | 123      |

直接在服務器上保存使用者的密碼是一件很危險的事情，一勞永逸的方法是讓使用者自行保存密碼，服務器只要保存跟密碼有關的公鑰，之後能夠透過這些公鑰驗證密碼的正確性就行了，如果從來都不替使用者保存密碼，就不用擔心要如何保管密碼還要擔心有心人士竊取密碼等麻煩的事情。

---

### Salt

我們在使用者註冊帳號時，產生一組專屬使用者的公鑰，像這樣用途的公鑰我們統稱為 salt，salt 必須為隨機生成的一組文字通常用 base64 的編碼方式產生，在註冊成功時連同使用者資料一起保存下來，並在必要時才做異動(變更密碼)。

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI="
}
```

我們用 salt 加上使用者設定的密碼，加上後續的加密計算後後會得到一組文字我們稱為 hash(雜湊值)，hash 也會保存在使用者資料內，用來驗證之後的嘗試登入。

---

### Hash

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI=",
  "password" : "ea627a55bbd5b29066e5debc714943b2303fc28043caec714ea58390ccf23767""
}
```

之後使用者嘗試登入時，我們拿使用者的 salt 加上登入輸入的密碼去做加密計算，看得到的 hash 是不是和當初註冊時計算出來的 hash 相同，如果不同，表示輸入的密碼不正確。

## 記住使用者的登入狀態

使用者的帳號密碼搞定了，現在我們來思考要怎麼讓客戶端(通常是瀏覽器)記住使用者已經登入過，才不用在每次重新加載頁面後還要再做一次登入才能使用。

我們前面利用註冊時得到的 Salt 加上使用者設定的密碼，得到了一組可以用來驗證密碼是否正確的 Hash 對吧？

### SessionToken

同樣的，我們可以在每次登入時先取得一組新的 salt ，再加上使用者帳號來產生一組新的 hash，這組 hash 可以用來驗證使用者是否已經登入過，像這種用途的 hash 我們稱為 sessionToken (為方便說明後面用 token 簡稱)。

```json
{
  "username": "Jessica",
  "salt": "PyihcMvQPJqRagzZ+SDHcwmCZWwtWATjqOUKwc7Wus8zRAiaAq22p2C9VjBFjJM5omVh9yrtYK9s92zXS7NBvBk701fjqf/PBgiYs7UpfOYQi2FHU61zH9q9Uvqa/MmETSzi8f7YETQT4/AfjNNJ9gO1LCxaBRake/xXtZMo+tI=",
  "password": "ea627a55bbd5b29066e5debc714943b2303fc28043caec714ea58390ccf23767",
  "sessionToken": "d23b0f67ec8f30def212893e5b0f859a1602ac58f9cfe37c721cf22625990afb"
}
```

跟之前不同的是，這次除了要把 token 保存在使用者資料裡同時還要保存在客戶端內，之後客戶端才能拿 token 去跟服務器做確認使用者是否已經登入過。

#### 可以用 cookie 或 localStorage 在瀏覽器內保存 token

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

> 通常這種用途的 token 具有時效性且必須在同一個客戶端底下才能使用，我們才會稱這種 token 為 sessionToken 而不是普通的 token，也因為這樣我們可以利用這種特性判斷使用者是否已經在其他地方登入過，若在不同的地方登入會讓既有的 token 被覆蓋掉，實現強制登出其他地方登入狀態的效果。
