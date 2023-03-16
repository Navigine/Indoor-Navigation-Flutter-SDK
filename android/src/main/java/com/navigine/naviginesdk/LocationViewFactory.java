package com.navigine.naviginesdk;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class LocationViewFactory extends PlatformViewFactory {
  private final BinaryMessenger messenger;
  private final NavigineSdkPlugin.LifecycleProvider lifecycleProvider;

  public LocationViewFactory(BinaryMessenger messenger, NavigineSdkPlugin.LifecycleProvider lifecycleProvider) {
    super(StandardMessageCodec.INSTANCE);
    this.messenger = messenger;
    this.lifecycleProvider = lifecycleProvider;
  }

  @NonNull
  @Override
  @SuppressWarnings({"unchecked"})
  public PlatformView create(Context context, int id, Object args) {
    return new LocationViewController(id, context, messenger, (Map<String, Object>) args, lifecycleProvider);
  }
}
