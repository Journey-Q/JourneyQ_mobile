plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.journeyq"
    compileSdk = 35  // Updated to 35 as required by plugins
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.journeyq"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
        
        // Add this to handle the PigeonUserDetails issue
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // Add packaging options to avoid conflicts
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    // Core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    
    // Firebase BOM (Bill of Materials) - ensures compatible versions
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))  // Latest version
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
    
    // Google Sign-In - Updated versions
    implementation("com.google.android.gms:play-services-auth:21.2.0")  // Updated
    implementation("com.google.android.gms:play-services-base:18.5.0")  // Updated
    
    // Facebook SDK - Updated versions
    implementation("com.facebook.android:facebook-login:17.0.1")  // Updated
    implementation("com.facebook.android:facebook-core:17.0.1")  // Updated
    
    // Additional dependencies
    implementation("androidx.browser:browser:1.8.0")  // Updated
    implementation("androidx.activity:activity-ktx:1.9.0")  // Updated
    implementation("androidx.fragment:fragment-ktx:1.8.0")  // Updated
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}

// Suppress Java 8 obsolete warnings and other compiler warnings
tasks.withType<JavaCompile> {
    options.compilerArgs.addAll(listOf(
        "-Xlint:-options",
        "-Xlint:-deprecation",
        "-Xlint:-unchecked"
    ))
}

// Also suppress Kotlin warnings if needed
tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = freeCompilerArgs + listOf(
            "-Xlint:-options",
            "-opt-in=kotlin.RequiresOptIn"
        )
    }
}