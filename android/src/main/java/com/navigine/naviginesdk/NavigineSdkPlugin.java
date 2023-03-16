package com.navigine.naviginesdk;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class NavigineSdkPlugin implements FlutterPlugin, ActivityAware {
  private static final String VIEW_TYPE = "navigine_sdk/navigine_map";

  private static final String LOCATION_LIST_CHANNEL_ID  = "navigine_sdk/location_list_manager";
  private static final String LOCATION_CHANNEL_ID  = "navigine_sdk/location_manager";
  private static final String NAVIGATION_CHANNEL_ID  = "navigine_sdk/navigation_manager";
  private static final String ROUTE_CHANNEL_ID  = "navigine_sdk/route_manager";

  @Nullable private Lifecycle lifecycle;

  @Nullable private MethodChannel locationListMethodChannel;
  @Nullable private MethodChannel locationMethodChannel;
  @Nullable private MethodChannel navigationMethodChannel;
  @Nullable private MethodChannel routeMethodChannel;

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {

    BinaryMessenger messenger = binding.getBinaryMessenger();
    binding.getPlatformViewRegistry().registerViewFactory(VIEW_TYPE, new LocationViewFactory(messenger, new LifecycleProvider()));

    setupChannels(messenger, binding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    teardownChannels();
  }

  private void setupChannels(BinaryMessenger messenger, Context context) {
    locationListMethodChannel = new MethodChannel(messenger, LOCATION_LIST_CHANNEL_ID);
    NavigineLocationListManager navigineLocationListManager = new NavigineLocationListManager(context, messenger);
    locationListMethodChannel.setMethodCallHandler(navigineLocationListManager);

    locationMethodChannel = new MethodChannel(messenger, LOCATION_CHANNEL_ID);
    NavigineLocationManager navigineLocationManager = new NavigineLocationManager(context, messenger);
    locationMethodChannel.setMethodCallHandler(navigineLocationManager);

    navigationMethodChannel = new MethodChannel(messenger, NAVIGATION_CHANNEL_ID);
    NavigineNavigationManager navigineNavigationManager = new NavigineNavigationManager(context, messenger);
    navigationMethodChannel.setMethodCallHandler(navigineNavigationManager);

    routeMethodChannel = new MethodChannel(messenger, ROUTE_CHANNEL_ID);
    NavigineRouteManager navigineRouteManager = new NavigineRouteManager(context, messenger);
    routeMethodChannel.setMethodCallHandler(navigineRouteManager);
  }

  @SuppressWarnings({"ConstantConditions"})
  private void teardownChannels() {
    locationListMethodChannel.setMethodCallHandler(null);
    locationListMethodChannel = null;

    locationMethodChannel.setMethodCallHandler(null);
    locationMethodChannel = null;

    navigationMethodChannel.setMethodCallHandler(null);
    navigationMethodChannel = null;

    routeMethodChannel.setMethodCallHandler(null);
    routeMethodChannel = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    lifecycle = null;
  }

  public class LifecycleProvider {
    @Nullable
    Lifecycle getLifecycle() {
      return lifecycle;
    }
  }
}
