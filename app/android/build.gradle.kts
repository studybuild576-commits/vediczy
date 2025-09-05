import java.io.File
import java.io.IOException

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Kotlin DSL mein classpath ko is tarah likhte hain
        classpath("com.google.gms:google-services:4.4.2")
        classpath("com.android.tools.build:gradle:8.3.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Flutter aur Android build ko ek hi /build folder me rakhne ke liye
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Make sure :app module is always evaluated
    project.evaluationDependsOn(":app")
}

// Clean task (gradle clean ke liye)
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
