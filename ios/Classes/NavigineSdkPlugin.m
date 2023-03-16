#import "NavigineSdkPlugin.h"
#import <navigine_sdk/navigine_sdk-Swift.h>

@implementation NavigineSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNavigineSdkPlugin registerWithRegistrar:registrar];
}
@end
