# JCTP

基于 [SWIG](http://www.swig.org/) 实现的对[上期技术](http://www.sfit.com.cn/) CTP 的封装。当前封装版本为 6.3.19，同时支持 64 位的 Windows 及 Linux 操作系统，动态链接库已被包含至 jar 包内，并在类加载时自动 loadLibrary，只需添加 jar 包即可直接使用。

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

**Gradle:**

```groovy
// Groovy DSL
dependencies {
    implementation 'org.rationalityfrontline.jctp:jctp:6.3.19-1.0'
}
```
```kotlin
// Kotlin DSL
dependencies {
    implementation("org.rationalityfrontline.jctp:jctp:6.3.19-1.0")
}
```

**Maven:**

```xml
<dependency>
  <groupId>org.rationalityfrontline.jctp</groupId>
  <artifactId>jctp</artifactId>
  <version>6.3.19-1.0</version>
</dependency>
```
**Jar:**

[Releases](https://github.com/RationalityFrontline/jctp/releases)

## Build

**前提要求（版本信息仅供参考，非必要）：**

1. 安装 [SWIG](http://www.swig.org/download.html) 4.0.2 并将其添加至环境变量中
2. 安装 [CMake](https://cmake.org/download/) > 3.16 并将其添加至环境变量中
3. 安装 C++ 编译器（ Windows 下是 [msvc](https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/)，Linux 下是 [gcc/g++](https://gcc.gnu.org/)）
4. 安装 [JDK 14](https://jdk.java.net/14/) 并将其添加至环境变量中

**Windows**

```powershell
cd swig
build.cmd
cd ..\cpp
build.cmd
cd ..\java
gradlew jar
```

**Linux**

```bash
cd swig
./build.sh
cd ../cpp
./build.sh
cd ../java
./gradlew jar
```
以上为单平台版本编译，如需编译跨平台版本，则需要执行以下步骤：

1. 在任意平台上执行 swig 目录下的 build 脚本
2. 在 Windows 及 Linux 下各运行一次 cpp 目录下的 build 脚本
3. 在任意平台上在 java 目录下执行 gradlew jar 命令

build 完毕后，生成的 jar 包在 java/build/libs 目录下。

## Reference

https://blog.csdn.net/pjjing/article/details/53186394

http://www.swig.org/Doc4.0/Contents.html#Contents

https://github.com/scijava/native-lib-loader

## License

JCTP is released under the [Apache 2.0 license](https://github.com/RationalityFrontline/jctp/blob/master/LICENSE).

```
Copyright 2020 RationalityFrontline

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