#import "Desk360flutterPlugin.h"
#if __has_include(<desk360flutter/desk360flutter-Swift.h>)
#import <desk360flutter/desk360flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "desk360flutter-Swift.h"
#endif

@implementation Desk360flutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDesk360flutterPlugin registerWithRegistrar:registrar];
}
@end
