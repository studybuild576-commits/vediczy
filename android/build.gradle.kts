buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Yeh line zaroori hai Google services plugin ko use karne ke liye.
        classpath 'com.google.gms:google-services:4.4.2'
        // Baaki zaruri dependencies yahan add karein, jaise ki Gradle plugin
        classpath 'com.android.tools.build:gradle:8.3.0' // Yeh version aapke Flutter project ke liye default ho sakta hai
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
```
eof

---
Ab jab aapne main `build.gradle` file update kar di hai, to ek aur ahem step baaki hai: **app-level** ki `build.gradle` file ko update karna.

`android/app/build.gradle` file mein do cheezein add karni hongi:

1.  File ke bilkul bottom mein yeh line add karein:
    ```gradle
    apply plugin: 'com.google.gms.google-services'
    ```
2.  `dependencies` block ke andar, Firebase SDK ko add karein, jisse aapko Firebase services (jaise ki Auth, Firestore) tak pahunch milegi:
    ```gradle
    dependencies {
        // ...baaki dependencies
        // Firebase BOM (Bill of Materials)
        implementation platform('com.google.firebase:firebase-bom:33.1.0')

        // Firebase Auth aur Google Sign-In SDK
        implementation 'com.google.firebase:firebase-auth'
        implementation 'com.google.android.gms:play-services-auth:21.2.0'

        // Firestore SDK
        implementation 'com.google.firebase:firebase-firestore'
    }
    
