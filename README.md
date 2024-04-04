# Navigine Flutter SDK

<p align="center"><img  width="50%"src=https://github.com/Navigine/Indoor-Navigation-Flutter-SDK/blob/main/img/flutter_img_1.png></p>


**What is Flutter?**

Flutter is a free and open-source mobile UI framework created by Google. It allows you to create a native mobile application with only one codebase. This means that you can use one programming language and one codebase to create two different apps (for iOS and Android).

A flutter plugin for navigine sdk on iOS and Android.

|             | Android |   iOS   |
|-------------|---------|---------|
| __Support__ | SDK 21+ | iOS 12+ |

### Useful links:
1. [SDK Documentation](https://github.com/Navigine/Indoor-Navigation-Android-Mobile-SDK-2.0/wiki)
2. Refer to the [Navigine official documentation](https://navigine.com/documentation/) for complete list of downloads, useful materials, information about the company, and so on.
3. [Get started](http://locations.navigine.com/login) with Navigine to get full access to Navigation services, SDKs, and applications.
4. Refer to the Navigine [User Manual](http://docs.navigine.com/) for complete product usage guidelines.
5. Find company contact information at the official website under [Contact](https://navigine.com/contacts/) tab.
6. Find information about Navigine’s Open Source Initiative [here](https://navigine.com/open-source/)

## Values and benefits

<p align="center"><img  width="100%" height="100%" src=https://github.com/Navigine/Indoor-Navigation-Flutter-SDK/blob/main/img/Flutter.jpg></p>

Flutter is a versatile platform that can be used in many industries, including retail, healthcare, logistics, transportation, and hospitality. The Navigine SDK for Flutter can provide businesses with accurate indoor positioning and tracking to improve their operations and provide a better experience for their customers.

In retail, Flutter with Navigine SDK can be used to create indoor navigation and wayfinding solutions for shopping malls, supermarkets, and other large stores, making it easier for customers to find products and leading to increased sales.

In healthcare, Flutter with Navigine SDK can be used to create indoor navigation and wayfinding solutions to help patients and visitors find their way around hospitals and medical facilities, reducing stress and anxiety and helping healthcare professionals locate patients and equipment more easily.

In transportation, Flutter with Navigine SDK can be used to create indoor navigation and wayfinding solutions for airports, train stations, and other transportation hubs, helping travelers find their gates or platforms more easily and improving the overall travel experience.

Using the Navigine SDK for Flutter provides businesses with several benefits, including high accuracy, scalability, and customization. The SDK is also user-friendly, with a simple and intuitive interface that makes it easy to integrate into any application.

Overall, by using Navigine SDK with Flutter, developers in these industries can create indoor navigation and wayfinding solutions that are fast, reliable, and user-friendly, improving the overall experience for customers and clients.

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

1. Add dependency `implementation 'com.github.Navigine:Indoor-Navigation-Android-Mobile-SDK-2.0:20240404'` to `android/app/build.gradle`
2. Add permissions `<uses-permission android:name="android.permission.INTERNET"/> <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /> <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />     <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> <uses-permission android:name="android.permission.BLUETOOTH" /> <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" /> <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />` to `android/app/src/main/AndroidManifest.xml`
3. Add `import com.navigine.idl.java.NavigineSdk;` and `import com.navigine.sdk.Navigine;` to `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`
4. `Navigine.initialize(getApplicationContext());` and `NavigineSdk.setUserHash("Your user hash");` inside method `configureFlutterEngine` in `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`
5. Specify your User Hash in the application delegate `android/app/src/main/.../MainActivity.java`/`android/app/src/main/.../MainActivity.kt`

`android/app/build.gradle`:

```groovy
dependencies {
    implementation 'com.github.Navigine:Indoor-Navigation-Android-Mobile-SDK-2.0:20240404'
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
