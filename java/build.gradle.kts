import org.gradle.internal.os.OperatingSystem

plugins {
    `java-library`
    `maven-publish`
    signing
}

group = "org.rationalityfrontline"
version = "6.7.8-1.0.5"
val NAME = project.name
val DESC = "Java wrapper for CTP"
val GITHUB_REPO = "ktrader-tech/jctp"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.scijava:native-lib-loader:2.5.0")
}

java {
    modularity.inferModulePath.set(true)
    withJavadocJar()
    withSourcesJar()
}

tasks {
    compileJava {
        options.encoding = "utf-8"
        options.release.set(11)
        doFirst {
            val os = OperatingSystem.current()
            val lineBreak = when {
                os.isWindows -> "\r\n"
                else -> "\n"
            }
            file("src/main/java/org/rationalityfrontline/jctp/jctpJNI.java").run {
                writeText(readText(Charsets.UTF_8).replace(
                                "  static {$lineBreak" +
                                "    swig_module_init();$lineBreak" +
                                "  }$lineBreak", ""), Charsets.UTF_8)
            }
        }
    }
    jar {
        manifest.attributes(mapOf(
            "Implementation-Title" to NAME,
            "Implementation-Version" to project.version,
            "Implementation-Vendor" to "RationalityFrontline"
        ))
        from("../lib") {
            include("*.dll")
            into("natives/windows_64")
        }
        from("../lib") {
            include("*.so")
            into("natives/linux_64")
        }
    }
    withType(Javadoc::class.java) {
        options {
            this as StandardJavadocDocletOptions
            addStringOption("Xdoclint:none", "-quiet")
            encoding = "UTF-8"
        }
    }
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            from(components["java"])
            pom {
                name.set(NAME)
                description.set(DESC)
                packaging = "jar"
                url.set("https://github.com/$GITHUB_REPO")
                licenses {
                    license {
                        name.set("The Apache Software License, Version 2.0")
                        url.set("http://www.apache.org/licenses/LICENSE-2.0.txt")
                    }
                }
                developers {
                    developer {
                        name.set("RationalityFrontline")
                        email.set("rationalityfrontline@gmail.com")
                        organization.set("ktrader-tech")
                        organizationUrl.set("https://github.com/ktrader-tech")
                    }
                }
                scm {
                    connection.set("scm:git:git://github.com/$GITHUB_REPO.git")
                    developerConnection.set("scm:git:ssh://github.com:$GITHUB_REPO.git")
                    url.set("https://github.com/$GITHUB_REPO/tree/master")
                }
            }
        }
    }
    repositories {
        fun env(propertyName: String): String {
            return if (project.hasProperty(propertyName)) {
                project.property(propertyName) as String
            } else "Unknown"
        }
        maven {
            val releasesRepoUrl = uri("https://oss.sonatype.org/service/local/staging/deploy/maven2/")
            val snapshotsRepoUrl = uri("https://oss.sonatype.org/content/repositories/snapshots/")
            url = if (version.toString().endsWith("SNAPSHOT")) snapshotsRepoUrl else releasesRepoUrl
            credentials {
                username = env("ossrhUsername")
                password = env("ossrhPassword")
            }
        }
    }
}

signing {
    sign(publishing.publications["maven"])
}