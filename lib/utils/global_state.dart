// ignore_for_file: constantzidentifier_names, constant_identifier_names

class GlobalState {
  GlobalState();
  static GlobalState ins = GlobalState();

  static final Map<dynamic, dynamic> cache = <dynamic, dynamic>{};

  static T get<T>(key) => cache[key];

  static void set(key, value) => cache[key] = value;
}
