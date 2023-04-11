# Navigine Flutter SDK

![flutter_img_1.png](https://github.com/Navigine/Indoor-Navigation-Flutter-SDK/blob/main/img/flutter_img_1.png)


**What is Flutter?**

Flutter is a free and open-source mobile UI framework created by Google. It allows you to create a native mobile application with only one codebase. This means that you can use one programming language and one codebase to create two different apps (for iOS and Android).

A flutter plugin for navigine sdk on iOS and Android.

|             | Android |   iOS   |
|-------------|---------|---------|
| __Support__ | SDK 21+ | iOS 12+ |

## Getting Started

### Generate your User Hash

1. Register at https://locations.navigine.com
2. Get user hash from Profile tab

### Initializing for iOS

1. Add `import Navigine` to `ios/Runner/AppDelegate.swift`
2. Add `NCNavigineSdk.setUserHash("Your user hash")` inside `func application` in `ios/Runner/AppDelegate.swift`
3. Specify your  User Hash in the application delegate `ios/Runner/AppDelegate.swift`
4. Uncomment `platform :ios, '9.0'` in `ios/Podfile` and change to `platform :ios, '12.0'`

`ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import Navigine

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    NCNavigineSdk.setUserHash("Your user hash")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Initializing for Android

1. Add dependency `implementation 'com.github.Navigine:Indoor-Navigation-Android-Mobile-SDK-2.0:20230213'` to `android/app/build.gradle`
2. Add permissions `<uses-permission android:name="android.permission.INTERNET"/> <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /> <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />     <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> <uses-permission android:name="android.permission.BLUETOOTH" /> <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" /> <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />` to `android/app/src/main/AndroidManifest.xml`
3. Add `import com.navigine.idl.java.NavigineSdk;` and `import com.navigine.sdk.Navigine;` to `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`
4. `Navigine.initialize(getApplicationContext());` and `NavigineSdk.setUserHash("Your user hash");` inside method `configureFlutterEngine` in `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`
5. Specify your User Hash in the application delegate `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`

`android/app/build.gradle`:

```groovy
dependencies {
    implementation 'com.github.Navigine:Indoor-Navigation-Android-Mobile-SDK-2.0:20230213'
}
```

#### For Java projects

`android/app/src/main/.../MainActivity.java`:

```java
package com.navigine.naviginesdkexample;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import com.navigine.idl.java.NavigineSdk;
import com.navigine.sdk.Navigine;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    Navigine.initialize(getApplicationContext());
    NavigineSdk.setUserHash("Your user hash");
    super.configureFlutterEngine(flutterEngine);
  }
}
```

### Usage

For usage examples refer to example [app](https://github.com/Navigine/Indoor-Navigation-Flutter-SDK/tree/master/example)
