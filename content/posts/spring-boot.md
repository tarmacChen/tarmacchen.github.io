---
title: "Spring Boot"
date: 2023-03-21T07:20:23+08:00
draft: true
description: 
---

{{< figure src="/img/moist-effective.jpg" title="毛玻璃">}}

## Spring Boot是什麼?

## 學習Spring Boot

### 建立Spring Boot專案

1. [Spring Initializr][spring.io]

    ![web](/img/spring.io.png)

2. Spring Tool Suite (STS)

    ![sts-new-project](/img/sts-new-project.png)

3. Spring Boot CLI

    ```ps
    > spring init
    Using service at https://start.spring.io
    Content saved to 'demo.zip'
    ```

4. IntelliJ IDEA
    ![intellij-idea-new-project](/img/intellij-idea-new-project.png)

### 一窺Spring Boot專案的結構樣貌，了解每個元件的功能

- pom.xml
- Maven wrapper (mvnw...)
- package structure that contain source and test class Java files
- resources folder (application.properties...)

## pom.xml

### parent tag (spring-boot-starter-parent)

```xml
<parent>                                                     
    <groupId>org.springframework.boot</groupId>              
    <artifactId>spring-boot-starter-parent</artifactId>      
    <version>2.6.3</version>                                 
    <relativePath/> <!-- lookup parent from repository -->   
</parent>
```

將pom裡的parent tag設定為`spring-boot-starter-parent`，這個starter包含了其他所有的Spring Boot starter dependencies，必須先有這個starter存在，才能識別並注入其他starter dependency

如果已經有其他的parent pom也能直接將它注入
```xml
<dependencyManagement>
   <dependencies>
      <dependency>
         <groupId>org.springframework.boot</groupId>
         <artifactId>spring-boot-dependencies</artifactId>
         <version>2.6.3</version>
         <type>pom</type>
         <scope>import</scope>
      </dependency>
   </dependencies>
</dependencyManagement>
```

## 核心功能

### starter dependencies

### autoconfiguration

### CommandLineRunner

## Actuator

[spring.io]: https://start.spring.io/
