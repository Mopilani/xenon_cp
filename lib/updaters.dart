import 'package:updater/updater.dart' as updater;
import 'package:xenon_cp/model/log_event.dart';
import 'package:xenon_cp/model/server_stat.dart';
import 'package:xenon_cp/utils/enums.dart';
import 'package:xenon_cp/utils/global_state.dart';


class LogUpdater extends updater.SpecialUpdater {
  LogUpdater(
    updaterID, {
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          updaterID,
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class XLog2Updater extends updater.SpecialUpdater {
  XLog2Updater(
    this.updaterID, {
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          updaterID,
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
  dynamic updaterID;

  /// the message [m]
  /// the time [t]
  /// the proirity [p]
  /// the id [i]

  @override
  void add(event, [LogProiority proiority = LogProiority.low]) {
    if (event == null || event.toString().isEmpty) return;

    var _event = XLogEvent.s(event, proiority);
    var scssLog = GlobalState.get(updaterID + 'scss');

    var limitedLog = GlobalState.get(updaterID + 'lmtd');
    var fullLog = GlobalState.get(updaterID + 'full');
    scssLog.add(_event);
    limitedLog.add(_event);
    fullLog.add(_event);

    if (scssLog.length > 120) {
      for (var i = 0; i < 20; i++) {
        scssLog.removeAt(i);
      }
    }
    GlobalState.set(updaterID + 'full', fullLog);
    GlobalState.set(updaterID + 'lmtd', limitedLog);
    GlobalState.set(updaterID + 'scss', scssLog);

    // var _event = {
    //   'm': event.toString(),
    //   't': DateTime.now().toString(),
    //   'p': proiority.toString(),
    //   'i': Random(11).nextInt(155).toString(),
    // };
    // var error = state.error.toString();
    super.add('');

    // else {
    //   super.add(/**Update */ true);
    // }
  }

  void addError(error, [LogProiority proiority = LogProiority.low]) {
    if (error == null || error.toString().isEmpty) return;

    var _error = XLogEvent.e(error, proiority);

    var errLog = GlobalState.get(updaterID + 'err');
    var limitedLog = GlobalState.get(updaterID + 'lmtd');
    var fullLog = GlobalState.get(updaterID + 'full');

    errLog.add(_error);
    limitedLog.add(_error);
    fullLog.add(_error);

    if (errLog.length > 120) {
      for (var i = 0; i < 20; i++) {
        errLog.removeAt(i);
      }
    }
    GlobalState.set(updaterID + 'full', fullLog);
    GlobalState.set(updaterID + 'lmtd', limitedLog);
    GlobalState.set(updaterID + 'err', errLog);

    // var _error = {
    //   'm': error.toString(),
    //   't': DateTime.now().toString(),
    //   'p': proiority.toString(),
    //   'i': Random(11).nextInt(155).toString(),
    // };
    super.error('');
  }
}

// class HomeLogUpdater extends LogUpdater {
//   HomeLogUpdater({
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(
//           'homeLog',
//           initialState: initialState,
//           updateForCurrentEvent: updateForCurrentEvent,
//         );
// }

class SettingsRequestStateUpdater extends updater.Updater {
  SettingsRequestStateUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class TestRequestStateUpdater extends updater.Updater {
  TestRequestStateUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class ConverterUpdater extends updater.Updater {
  ConverterUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class ThemeUpdater extends updater.Updater {
  ThemeUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class ServerStartIconUpdater extends updater.Updater {
  ServerStartIconUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class ReleaserScreenUpdater extends updater.Updater {
  ReleaserScreenUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class XenonServerCardUpdater extends updater.SpecialUpdater {
  XenonServerCardUpdater(
    updaterId, {
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          updaterId,
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class XbStaticsSegUpdater extends updater.SpecialUpdater<ServerStat?> {
  XbStaticsSegUpdater(
    updaterId, {
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          updaterId,
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}

class TelegramBotSettingsScreenUpdater extends updater.Updater {
  TelegramBotSettingsScreenUpdater({
    initialState,
    bool updateForCurrentEvent = false,
  }) : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
        );
}


// class XbStaticsSegUpdater extends updater.SpecialUpdater<ServerStat?> {
//   XbStaticsSegUpdater(
//     updaterId, {
//     initialState,
//     bool updateForCurrentEvent = false,
//   }) : super(
//           updaterId,
//           initialState,
//           updateForCurrentEvent: updateForCurrentEvent,
//         );
// }

// http://localhost:8888
