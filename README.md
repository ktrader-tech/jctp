# JCTP  
[![Maven Central](https://img.shields.io/maven-central/v/org.rationalityfrontline/jctp.svg?label=Maven%20Central)](https://search.maven.org/search?q=g:%22org.rationalityfrontline%22%20AND%20a:%22jctp%22) ![platform](https://img.shields.io/badge/platform-windows%7Clinux-green) [![Apache License 2.0](https://img.shields.io/github/license/rationalityfrontline/jctp)](https://github.com/RationalityFrontline/jctp/blob/master/LICENSE)

基于 [SWIG](http://www.swig.org/) 实现的对[上期技术](http://www.sfit.com.cn/) CTP 的封装。当前封装版本为 6.3.19，支持 64 位的 Windows 及 Linux 操作系统，动态链接库已被包含至 jar 包内，并在类加载时自动 loadLibrary，只需添加 jar 包即可直接使用。

## Usage

API 及使用方法同上期技术官方提供的 C++ 版 CTP SDK，另外使用前可以通过以下方法判断动态链接库是否已被成功加载：

```kotlin
import org.rationalityfrontline.jctp.*

fun main() {
    if (jctpJNI.libraryLoaded()) {
        // Do something with CTP, here we print its sdk version
        println(CThostFtdcTraderApi.GetApiVersion())
    } else {
        System.err.println("Library load failed!")
    }
}
```

如果在 Linux 环境下使用，则需要确保已安装 zh_CN.GB18030 字符集：

```
sudo locale-gen zh_CN.GB18030
sudo dpkg-reconfigure locales
```

## Download

**Gradle Kotlin DSL:**

```kotlin
repositories {
    mavenCentral()
}

dependencies {
    implementation("org.rationalityfrontline:jctp:6.3.19-1.0.2")
}
```

**Maven:**

```xml
<dependency>
    <groupId>org.rationalityfrontline</groupId>
    <artifactId>jctp</artifactId>
    <version>6.3.19-1.0.2</version>
</dependency>
```
**Jar:**

[Releases](https://github.com/RationalityFrontline/jctp/releases)

使用 Jar 包前请先添加 [native-lib-loader](https://github.com/scijava/native-lib-loader) 依赖：
```kotlin
dependencies {
    implementation("org.scijava:native-lib-loader:2.3.5")
}
```

## Build

**前提要求（版本信息仅供参考，非必要）：**

1. 安装 [SWIG](http://www.swig.org/download.html) 4.0.2 并将其添加至环境变量中
2. 安装 [CMake](https://cmake.org/download/) > 3.16 并将其添加至环境变量中
3. 安装 C++ 编译器（ Windows 下是 [msvc](https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/)，Linux 下是 [gcc/g++](https://gcc.gnu.org/)）
4. 安装 [JDK 14](https://jdk.java.net/14/) 并将其添加至环境变量中

**Windows**

```powershell
build.cmd
```

**Linux**

```bash
./build.sh
```
以上为单平台版本编译，如需编译跨平台版本，则需要在两个平台下各编译一次（顺序随意）。

build 完毕后，生成的 jar 包在 java/build/libs 目录下。

## Reference

https://blog.csdn.net/pjjing/article/details/53186394

http://www.swig.org/Doc4.0/Contents.html#Contents

https://github.com/scijava/native-lib-loader

## License

JCTP is released under the [Apache 2.0 license](https://github.com/RationalityFrontline/jctp/blob/master/LICENSE).

```
Copyright 2020-2021 RationalityFrontline

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```