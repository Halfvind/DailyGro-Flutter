pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        try {
            file("local.properties").inputStream().use { properties.load(it) }
        } catch (e: java.io.FileNotFoundException) {
            throw IllegalStateException("local.properties file not found: ${e.message}", e)
        } catch (e: java.io.IOException) {
            throw IllegalStateException("Failed to read local.properties file: ${e.message}", e)
        }
        val sdkPath = properties.getProperty("flutter.sdk")
        require(sdkPath != null) { 
            "flutter.sdk not set in local.properties. Available properties: ${properties.keys.joinToString(", ")}. " +
            "Please ensure Flutter SDK path is configured correctly."
        }
        sdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
