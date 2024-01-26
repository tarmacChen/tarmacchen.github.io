---
title: "ORM的誕生及了解JPA, Hibernate 與 Spring Data JPA之間的關係"
date: 2023-03-22T20:03:18+08:00
draft: false
tags: [JDBC, ORM, JPA, Hibernate, Spring Data JPA]
description: 
---

{{< figure src="/img/cover/sheep.jpg" title="清境農場的綿羊">}}

## 在沒有ORM之前應用程式是怎麼跟資料庫交流的

我們必須透過JDBC API(Java Database Connectivity API)的介面搭配該資料庫適用的JDBC Driver去跟資料庫連接

{{< figure src="/diagrams/orm-is-born/jdbc.png" title="JDBC">}}

不同的資料庫有不同的JDBC Driver，透過DriverManager針對不同的請求去回傳對應的JDBC Driver

{{< figure src="/diagrams/orm-is-born/jdbc-driver-manager.png" title="JDBC Driver Manager">}}

## ORM的誕生

除了上述談到針對不同的資料庫有不同的連接方式這個問題，還有應用程式內的資料要怎麼對映到資料表也是個問題，ORM(Object Relational Mapping)的出現就是為了解決這些麻煩的事情，若少了ORM我們要手動去處理資料在這兩者之間的映對關係

{{< figure src="/diagrams/orm-is-born/relationship.png" title="物件模型與資料表的關係">}}

在操作時要把映對關係設定好才能讓資料在物件模型與資料表中做轉換，若資料表改變了結構，映對關係也要同步做調整，實務上資料庫不會只有一種，可能有MySQL、DB2、SQL Server之類的，不同的資料庫有不同的結構與SQL語法，透過ORM的抽象層去設定映對關係，這樣就可以專注在跟業務邏輯有關的代碼上，不用煩惱操作不同的資料庫時，應用程式要做哪些調整才能取得那些資料，ORM是位於資料庫與應用程式間的中間層，透過ORM提供的API介面幫你去跟資料庫打交道，聽起來一切都很美好但也有一些缺點

- 要多學一套ORM的API
- 比較複雜的功能沒有辦法單獨透過ORM來完成，還是需要SQL
- 多了ORM應用程式的性能會有些損失

{{< figure src="/diagrams/orm-is-born/orm.png" title="加入ORM">}}

> 雖然有提到使用ORM會損失性能，但這並不是造成應用程式緩慢的關鍵，會造成緩慢多半是因為SQL語法沒有最佳化、資料庫設計不佳、應用程式架構不良等其他因素導致的，也就是說如果沒有明確的原因，ORM帶來的性能損失可以暫且不論

## JPA是什麼?

JPA全名為Jakarta Persistence API 或在早期叫 Java Persistence API，是一個Java官方為了實現ORM所制定的一套標準規範(Specification)及接口(API)，要注意這是一個規範沒辦法給開發者直接使用，必須透過像是Hibernate、OpenJPA或TopLink之類的JPA Provider才行

{{< figure src="/diagrams/orm-is-born/jpa.png" title="加入實作JPA的ORM">}}

## Hibernate是什麼?

Hibernate是Java生態系中最廣泛使用的ORM框架並且實作了JPA的規範

## Spring Data JPA是什麼?

雖然我們有了ORM來幫助我們處理訪問持久層的操作，但這些ORM框架基於JPA規範又各自擴展了其他功能，導致開發人員無法在這些ORM框架之間無縫切換，於是Spring提出了Spring Data JPA這個解決方案，它是位於JPA與各個ORM框架之間經過抽象化的資料存取層(Data Access Layer)，這樣在Spring底下開發應用程式就不用管底下的ORM框架怎麼變化了

{{< figure src="/diagrams/orm-is-born/spring-data-jpa.png" title="加入Spring Data JPA">}}

## 總結

希望這篇文章能幫助讀者了解為什麼要有ORM及什麼是ORM，還有JPA, Hibernate與Spring Data JPA之間的關係，這些觀念對於剛踏入Spring世界的我來說很有幫助