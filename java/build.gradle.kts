import com.jfrog.bintray.gradle.BintrayExtension.PackageConfig
import com.jfrog.bintray.gradle.BintrayExtension.VersionConfig
import java.util.Date
import org.gradle.internal.os.OperatingSystem

plugins {
    `java-library`
    `maven-publish`
    id("org.javamodularity.moduleplugin") version "1.7.0"
    id("com.jfrog.bintray") version "1.8.5"
}

group = "org.rationalityfrontline"
version = "6.3.19-1.0"

repositories {
    jcenter()
}

dependencies {
    implementation("org.scijava:native-lib-loader:2.3.4")
}

tasks {
    compileJava {
        options.encoding = "utf-8"
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
        from("../lib") {
            include("*.dll")
            into("META-INF/lib/windows_64")
        }
        from("../lib") {
            include("*.so")
            into("META-INF/lib/linux_64")
        }
    }
    withType(Javadoc::class.java) {
        options.apply {
            encoding = "UTF-8"
        }
    }
    register<Jar>("javadocJar") {
        archiveClassifier.set("javadoc")
        dependsOn(javadoc)
        from(getByName<Javadoc>("javadoc").destinationDir)
    }
    register<Jar>("sourcesJar") {
        archiveClassifier.set("sources")
        from(sourceSets["main"].allSource)
    }
}

val NAME = project.name
val DESC = "Java wrapper for CTP"
val GITHUB_REPO = "RationalityFrontline/jctp"

publishing {
    publications {
        create<MavenPublication>("mavenPublish") {
            from(components["java"])
            artifact(tasks["sourcesJar"])
            artifact(tasks["javadocJar"])
            pom {
                name.set(NAME)
                description.set("$NAME $version - $DESC")
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
                    }
                }
                scm {
                    url.set("https://github.com/$GITHUB_REPO")
                }
            }
        }
    }
}

bintray {
    fun env(propertyName: String): String {
        return if (project.hasProperty(propertyName)) {
            project.property(propertyName) as String
        } else "Unknown"
    }

    user = env("BINTRAY_USER")
    key = env("BINTRAY_KEY")
    publish = true
    override = true
    setPublications("mavenPublish")
    pkg(closureOf<PackageConfig>{
        repo = NAME
        name = NAME
        desc = DESC
        setLabels("java", "ctp", "quant", "futures")
        setLicenses("Apache-2.0")
        publicDownloadNumbers = true
        githubRepo = GITHUB_REPO
        vcsUrl = "https://github.com/$githubRepo"
        websiteUrl = vcsUrl
        issueTrackerUrl = "$vcsUrl/issues"
        version(closureOf<VersionConfig> {
            name = "${project.version}"
            desc = "JCTP - $DESC"
            released = "${Date()}"
            vcsTag = name
        })
    })
}