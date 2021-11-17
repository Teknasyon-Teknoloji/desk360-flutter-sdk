# Desk360 (flutter sdk)
* This package gives wrapper methods for desk360 sdks. [iOS](https://github.com/Teknasyon-Teknoloji/desk360-ios-sdk) - [Android](https://github.com/Teknasyon-Teknoloji/desk360-android-sdk)

---

## Getting started

Add below code into your `pubspec.yaml` file under `dependencies` section.

```yml
desk360flutter:
    git:
      url: https://github.com/Teknasyon-Teknoloji/desk360-flutter-sdk.git
      ref: 0.1.0
```

And run `$ flutter pub get`

### Installation Notes

* **IOS**
    - Set minimum ios version 10.0 or higher in `ios/Podfile` like: `platform :ios, '10.0'`
    - Add `use_frameworks!` into `ios/Podfile` if not exists.
    - Run `$ cd ios && pod install`

* **ANDROID**
    - Set kotlin_version "1.4.32" or higher in `android/build.gradle`
    - Set `minSdkVersion` to 21 or higher in `android/app/build.gradle`
    - Add `maven { url 'https://raw.githubusercontent.com/Teknasyon-Teknoloji/desk360-android-sdk/master/' }` into `android/build.gradle` (Add into repositories under allprojects)

---

## Usage

### Let's start

### Important footnot

You must add your info.plist file.

```
<key>NSPhotoLibraryUsageDescription</key>
<string>Allow the app to access your photos.</string>
```

Permission text is optional. you can type whatever you want. But this permission not optional. If you didn't add this permission. Desk360 Images attachment property doesn't work

### Start Desk360 with appId -and an optinal deviceId, an optional language-

> Note: If no deviceId is provided, Desk360 will use device's [UUID](https://developer.apple.com/documentation/foundation/uuid), which might cause your app to lose tickets when the application is deleted. If use environment type .production, Desk360 will look at prod url. If no application language is provided, Desk360 will use device's language.

```dart
import 'package:desk360flutter/enums/environments.dart';
import 'package:desk360flutter/enums/platforms.dart' as Platforms;
import 'package:flutter/material.dart';
import 'package:desk360flutter/desk360flutter.dart';

if (Platform.isIOS) {
    Desk360flutter.start(properties: {
    "appID": "aOJe1THakL03kwONmc2U4utYCeW16zJr",
    "deviceID": "34567",
    "languageCode": 'en',
    "environment": Environment.SANDBOX.value,
    "countryCode": 'tr',
    "bypassCreateTicketIntro": true,
    });
    Desk360flutter.show(animated: true);
} else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    var deviceId = androidDeviceInfo.androidId;
    Desk360flutter.initialize({
    "appID": "aOJe1THakL03kwONmc2U4utYCeW16zJr",
    "appVersion": "1.0.0",
    "languageCode": 'en',
    "environment": Environment.SANDBOX.value,
    "platform": Platforms.Platform.GOOGLE.value,
    "countryCode": 'tr',
    "name": "Test-092021"
    }, "", deviceId);
    Desk360flutter.start();
}
```

### Using Desk360

```dart
import 'package:desk360flutter/desk360flutter.dart';

Desk360flutter.getTicketId()
          .then((value) => {print("Ticket ID: $value")});
```

### Using Optional Notification System

If you need to send a notification when a message is sent to the users. You have to do this integration in ios.

```swift
import Desk360

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       Desk360.setPushToken(deviceToken: deviceToken)
  }
  
}
```

After the above integration, it is sufficient to make the notification certificate settings in the [Desk360](https://desk360.com/) admin panel. You can now use notifications

Also if you want notification redirect deeplink system. You should some extra integration.

```swift
import Desk360

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
      Desk360.applicationLaunchChecker(launchOptions)
      if #available(iOS 10.0, *) {
          let center = UNUserNotificationCenter.current()
          center.delegate = self
      }
      return true
      
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert])
      Desk360.willNotificationPresent(notification.request.content.userInfo)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      Desk360.applicationUserInfoChecker(userInfo)
  }
  
  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      Desk360.applicationUserInfoChecker(response.notification.request.content.userInfo)
  }
}
```

When you click on the notification when your application is closed, you need to add this code on which page you want Des360 to open.

```dart
import 'package:desk360flutter/desk360flutter.dart';

...
Desk360flutter.showWithPushDeeplink();
...

```

### Getting the unread tickets

If you would like to get a list of the unread tickets you can do so like follows:

```dart
  Desk360flutter.getUnreadTickets().then( (results) {
      print(results);
  });
```

You can show the unread tickets the way that fits your app design and expierence. If you want to navigate to a specific ticket 
detail you can do so so by following:

```dart
  Desk360flutter.ticketDetailsViewController(unreadTicket);
```

### Customize Desk360 Theme

You should use [Desk360](https://desk360.com/) dashboard for custom config.

## Support

If you have any questions or feature requests, please [create an issue](https://github.com/Teknasyon-Teknoloji/desk360-flutter-sdk/issues/new).

## License

Desk360 is released under the MIT license. See [LICENSE](https://github.com/Teknasyon-Teknoloji/desk360-flutter-sdk/blob/master/LICENSE) for more information.
