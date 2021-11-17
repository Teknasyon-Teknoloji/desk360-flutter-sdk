enum Environment { SANDBOX, PRODUCTION }

extension Desk360Environment on Environment {
  static const values = {
    Environment.SANDBOX: 0,
    Environment.PRODUCTION: 1,
  };

  int? get value => values[this];
}
