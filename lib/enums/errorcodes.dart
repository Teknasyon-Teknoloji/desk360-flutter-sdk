enum ErrorCode {
  NATIVE_MODULE_NOT_FOUND,
  NATIVE_MODULE_EVENT_EMITTER_NOT_FOUND,
  PROPERTIES_APPID_REQUIRED,
  PROPERTIES_DEVICEID_REQUIRED,
  PROPERTIES_ENVIRONMENT_REQUIRED,
  VALIDATE_ENVIRONMENT_NOT_VALID,
  VALIDATE_PLATFORM_NOT_VALID,
  VALIDATE_CREDENTIALS_NOT_VALID,
  TARGETID_REQUIRED,
  TOKEN_REQUIRED,
  DEVICE_TOKEN_REQUIRED,
}

class Desk360FlutterException implements Exception {
  int code = 0;
  String message = "";

  Desk360FlutterException(ErrorCode code) {
    this.code = code.value?['code'] as int;
    this.message = code.value?['message'] as String;
  }
}

extension Desk360FlutterError on ErrorCode {
  static const values = {
    ErrorCode.NATIVE_MODULE_NOT_FOUND: {
      "code": 101,
      "message": 'Native module "Desk360Flutter" not found.',
    },
    ErrorCode.NATIVE_MODULE_EVENT_EMITTER_NOT_FOUND: {
      "code": 121,
      "message": 'Native module "Desk360FlutterEmitter" not found.',
    },
    ErrorCode.PROPERTIES_APPID_REQUIRED: {
      "code": 201,
      "message": 'Missing parameter "appID" required for Desk360Properties.'
    },
    ErrorCode.PROPERTIES_DEVICEID_REQUIRED: {
      "code": 202,
      "message": 'Missing parameter "deviceID" required for Desk360Properties.'
    },
    ErrorCode.PROPERTIES_ENVIRONMENT_REQUIRED: {
      "code": 203,
      "message":
          'Missing parameter "environment" required for Desk360Properties.'
    },
    ErrorCode.VALIDATE_ENVIRONMENT_NOT_VALID: {
      "code": 204,
      "message": 'Environment is not valid for Desk360Properties.'
    },
    ErrorCode.VALIDATE_PLATFORM_NOT_VALID: {
      "code": 209,
      "message": 'Platform is not valid for Desk360Properties.'
    },
    ErrorCode.VALIDATE_CREDENTIALS_NOT_VALID: {
      "code": 208,
      "message": 'Credentials is not valid for Desk360Properties.'
    },
    ErrorCode.TARGETID_REQUIRED: {
      "code": 301,
      "message": 'Missing parameter "targetID" required'
    },
    ErrorCode.TOKEN_REQUIRED: {
      "code": 302,
      "message": 'Missing parameter "notificationToken" required'
    },
    ErrorCode.DEVICE_TOKEN_REQUIRED: {
      "code": 303,
      "message": 'Missing parameter "deviceId" required'
    },
  };

  Map<String, Object>? get value => values[this];
}
