enum LogProiority {
  high,
  medium,
  low,
}

enum ServiceState {
  stopped,
  started,
  starting,
  error,
  timedOut,
  unavaliable,
  inMaintainance,
}


enum ProjectLang {
  dart,
  none,
  // python,
}

ProjectLang? getProjectLang(String name) {
  for (var lang in ProjectLang.values) {
    if (lang.toString() == name) {
      return lang;
    } else {
      throw 'There is no lang called $name';
    }
  }
}

ProjectLang? getProjectLangForUserInput(String name) {
  for (var lang in ProjectLang.values) {
    if (lang.toString() == name) {
      return lang;
    } else {
      throw 'There is no lang called $name';
    }
  }
}
