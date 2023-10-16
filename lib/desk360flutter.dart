import 'dart:async';

import 'package:desk360flutter/enums/errorcodes.dart';
import 'package:flutter/services.dart';

class Desk360flutter {
  static const MethodChannel _channel = const MethodChannel('desk360flutter');

  constructor() {}

  static void start({properties}) async {
    if (properties != null) {
      if ((properties["appID"] as String).isEmpty) {
        throw new Desk360FlutterException(ErrorCode.PROPERTIES_APPID_REQUIRED);
      }
      if (properties["environment"] != null &&
          (properties["environment"] as int) > 1) {
        throw new Desk360FlutterException(
            ErrorCode.VALIDATE_ENVIRONMENT_NOT_VALID);
      }
      if (properties["platform"] != null &&
          (properties["platform"] as int) > 1) {
        throw new Desk360FlutterException(
            ErrorCode.VALIDATE_PLATFORM_NOT_VALID);
      }
      await _channel.invokeMethod('start', {"properties": properties});
    } else {
      await _channel.invokeMethod('start');
    }
  }

  //ios only
  static void show({animated = false}) async {
    await _channel.invokeMethod('show', {"animated": animated});
  }

  //ios only
  static void setPushToken(deviceToken) async {
    await _channel.invokeMethod('setPushToken', {"deviceToken": deviceToken});
  }

  //ios only
  static void applicationLaunchChecker(launchOptions) async {
    await _channel.invokeMethod(
        'applicationLaunchChecker', {"launchOptions": launchOptions});
  }

  //ios only
  static void willNotificationPresent(userInfo) async {
    await _channel
        .invokeMethod('willNotificationPresent', {"userInfo": userInfo});
  }

  //ios only
  static void applicationUserInfoChecker(launchOptions) async {
    await _channel.invokeMethod(
        'applicationUserInfoChecker', {"launchOptions": launchOptions});
  }

  //ios only
  static void showWithPushDeeplink() async {
    await _channel.invokeMethod('showWithPushDeeplink');
  }

  //ios only
  static Future getUnreadTickets() async {
    final tickets = await _channel.invokeMethod('getUnreadTickets');
    return tickets;
  }

  //ios only
  static void ticketDetailsViewController(ticket, {animated = false}) async {
    await _channel.invokeMethod('ticketDetailsViewController',
        {"ticket": ticket, "animated": animated});
  }

  //ios only
  static void showDetails(ticket, {animated = false}) async {
    await _channel
        .invokeMethod('showDetails', {"ticket": ticket, "animated": animated});
  }

  //android only
  static Future getTicketId() async {
    final ticketId = await _channel.invokeMethod('getTicketId');
    return ticketId;
  }

  //android only
  static void initialize(properties, notificationToken, deviceId) async {
    if (properties['appID'].isEmpty) {
      throw new Desk360FlutterException(ErrorCode.PROPERTIES_APPID_REQUIRED);
    }
    if (properties["environment"] == null ||
        (properties["environment"] != null &&
            (properties["environment"] as int) > 1)) {
      throw new Desk360FlutterException(
          ErrorCode.VALIDATE_ENVIRONMENT_NOT_VALID);
    }
    if (properties["platform"] == null ||
        (properties["platform"] != null &&
            (properties["platform"] as int) > 1)) {
      throw new Desk360FlutterException(ErrorCode.VALIDATE_PLATFORM_NOT_VALID);
    }
    if (deviceId.isEmpty) {
      throw new Desk360FlutterException(ErrorCode.DEVICE_TOKEN_REQUIRED);
    }
    await _channel.invokeMethod('initialize', {
      "properties": properties,
      "notificationToken": notificationToken,
      "deviceId": deviceId
    });
  }
}
