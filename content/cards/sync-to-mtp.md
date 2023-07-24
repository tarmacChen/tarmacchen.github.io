---
title: "同步MTP Device裡的資料"
date: 2023-04-26T07:29:25+08:00
draft: false
description: 
---

{{< figure src="/img/cover/tulip.jpg" title="鬱金香">}}

## 使用情境

有個儲存裝置透過USB連接到電腦，他的連接協定不是用`USB MSC` (Usb Mass Storage Device Class)而是`MTP`，如果想讓裝置內的某個資料夾與本機的資料夾同步，可以怎麼做?

與`USB MSC`不同的是，透過`MTP`協定連接的儲存裝置不像一般的隨身碟會掛載到檔案系統中，也就是在電腦裡找不到一個實際存在的儲存空間 (Volume)可供操作

我的同步任務需要同時滿足以下兩個條件:

1. 只複製裝置上不存在的檔案過去
2. 遇到檔案已存在裝置上時自動忽略

## 探索解決方案

### 透過檔案總管手動拖拉

這個解法很明顯沒辦法滿足條件，因為複製時遇到檔案已存在的情況會不停跳出是否要覆蓋原有檔案的詢問，如果選擇不要覆蓋就會取消後續的動作

### 透過命令列或腳本

我有找到很多命令列工具像是`xcopy`或`robocopy`可以滿足同步任務的條件，但問題來了，下指令時我的目的地路徑參數要怎麼輸入，透過MTP協定連接的儲存裝置不會存在檔案系統中，所以要先用`mtpmount`將`MTP Storage`掛載到檔案系統再做後續操作，或直接用我最後選擇的解決方案`mtpcopy`

## mtpcopy

[GitHub][mtpcopy]

### 安裝

我是透過 [Scoop][scoop] (套件管理工具)安裝到電腦裡

```ps
> scoop install mtpcopy --global
```

### 列出所有的 MTP Storage

```ps
> mtpcopy storages
WALKMAN:Internal shared storage:
WALKMAN:Lyra:
```

可以看到我有兩個storage，一個是裝置上的內部儲存空間，另一個是裝置上的記憶卡儲存空間名為`Lyra`


### 同步資料

```ps
> mtpcopy copy -R C:\Users\hugo\Music\Music\ WALKMAN:Lyra:\Music\
```

> ...

### 列出路徑匹配到的所有檔案
```
PS C:\Users\hugo> mtpcopy list WALKMAN:Lyra:\Music\John*
WALKMAN:Lyra:\Music\John Mayer
WALKMAN:Lyra:\Music\John Williams
```

[mtpcopy]: https://github.com/kzmi/mtpcopy
[scoop]: https://scoop.sh/