import java.util.Properties
import java.io.FileInputStream

// Load keystore properties
val keystorePropertiesFile = rootProject.file("../key.properties")
val keystoreProperties = Properties()

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.zarmira.torch"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.zarmira.torch"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode =5
        versionName = "1.0.5"
    }

    // Signing configuration
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val storeFileValue = keystoreProperties.getProperty("storeFile")
                val keyAliasValue = keystoreProperties.getProperty("keyAlias")
                val keyPasswordValue = keystoreProperties.getProperty("keyPassword")
                val storePasswordValue = keystoreProperties.getProperty("storePassword")
                
                // Ensure all required properties are not null
                if (storeFileValue != null && keyAliasValue != null && 
                    keyPasswordValue != null && storePasswordValue != null) {
                    
                    val keystoreFile = rootProject.file(storeFileValue)
                    if (keystoreFile.exists()) {
                        keyAlias = keyAliasValue
                        keyPassword = keyPasswordValue
                        storeFile = keystoreFile
                        storePassword = storePasswordValue
                    } else {
                        throw GradleException("Keystore file not found: ${keystoreFile.absolutePath}")
                    }
                } else {
                    throw GradleException("Missing required signing properties in key.properties")
                }
            } else {
                throw GradleException("key.properties file not found")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}
