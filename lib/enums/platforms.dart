enum Platform { GOOGLE, HUAWEI }

extension Desk360Platform on Platform {
  static const values = {
    Platform.GOOGLE: 0,
    Platform.HUAWEI: 1,
  };

  int? get value => values[this];
}
