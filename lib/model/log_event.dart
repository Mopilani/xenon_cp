import 'dart:math';

import 'package:xenon_cp/utils/enums.dart';

class XLogEvent {
  XLogEvent({
    this.errorMsg,
    this.id,
    this.scssMsg,
  }) {
    dateTime = DateTime.now().toString();
    proiority = LogProiority.low;
    id = Random(60).nextInt(133).toString();
  }

  String? scssMsg;
  String? errorMsg;
  late LogProiority proiority;
  late String dateTime;
  dynamic id;
  // dynamic errorEvent;

  static XLogEvent? s(scssMsg, [proiority]) {
    if (scssMsg != null && scssMsg.toString().isNotEmpty) {
      var _xLogEvent = XLogEvent();
      _xLogEvent.scssMsg = scssMsg.toString();
      _xLogEvent.proiority = proiority;
      return _xLogEvent;
    }
    return null;
  }

  static XLogEvent? e(errorMsg, [proiority]) {
    if (errorMsg != null && errorMsg.toString().isNotEmpty) {
      var _xLogEvent = XLogEvent();
      _xLogEvent.errorMsg = errorMsg.toString();
      _xLogEvent.proiority = proiority;
      return _xLogEvent;
    }
    return null;
  }

  static XLogEvent fromMap(Map<String, dynamic> logMap) {
    var _xLogEvent = XLogEvent();
    _xLogEvent.id = logMap['i'];
    _xLogEvent.scssMsg = logMap['s'];
    _xLogEvent.errorMsg = logMap['e'];
    _xLogEvent.dateTime = logMap['t'];
    _xLogEvent.proiority = logMap['p'];
    return _xLogEvent;
  }

  Map<String, dynamic> toErrMap() {
    return {
      's': scssMsg.toString(),
      't': dateTime.toString(),
      'p': proiority.toString(),
      'i': id.toString(),
    };
  }

  Map<String, dynamic> toScssMap() {
    return {
      'e': errorMsg.toString(),
      't': dateTime.toString(),
      'p': proiority.toString(),
      'i': id.toString(),
    };
  }
}
