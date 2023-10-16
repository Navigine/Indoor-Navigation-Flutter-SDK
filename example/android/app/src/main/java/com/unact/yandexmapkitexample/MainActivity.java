package com.navigine.naviginesdkexample;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import com.navigine.idl.java.NavigineSdk;
import com.navigine.sdk.Navigine;

public class MainActivity extends FlutterActivity {
  private NavigineSdk sdk;
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    Navigine.initialize(getApplicationContext());
    sdk = NavigineSdk.getInstance();
    sdk.setUserHash("Your user hash");
    super.configureFlutterEngine(flutterEngine);
  }
}
