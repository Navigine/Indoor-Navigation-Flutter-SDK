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
