plugins {
    `java-library`
    id("org.javamodularity.moduleplugin") version "1.7.0"
}

group = "org.rationalityfrontline.jctp"
version = "6.3.19-1.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.scijava:native-lib-loader:2.3.4")
}

tasks {
    jar {
        from("../lib") {
            include("*.dll")
            into("META-INF/lib/windows_64")
        }
        from("../lib") {
            include("*.so")
            into("META-INF/lib/linux_64")
        }
    }
    compileJava {
        doFirst {
            file("src/main/java/org/rationalityfrontline/jctp/jctpJNI.java").run {
                writeText(readText().replace(
                        "  static {\r\n" +
                                "    swig_module_init();\r\n" +
                                "  }\r\n".trimMargin(), ""))
            }
        }
    }
}
