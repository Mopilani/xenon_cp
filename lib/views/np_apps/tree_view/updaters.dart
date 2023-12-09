import 'package:updater/updater.dart' as updater;

class ThisPageUpdater<T> extends updater.Updater {
  // ThisPageUpdater({initialState, bool reset = false})
  ThisPageUpdater({initialState, bool reset = false})
      : super(
          initialState,
          updateForCurrentEvent: reset,
          updateSpeed: 17,
        );

  @override
  void add(event) {
    super.add(event);
    ThisPageAppBarUpdater().add(0);
  }
}

class ThisPageUpdater2 extends updater.Updater {
  ThisPageUpdater2({initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
          updateSpeed: 17,
        );
}

class ThisPageUpdater3 extends updater.Updater {
  ThisPageUpdater3({initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
          updateSpeed: 17,
        );
}

class ThisPageAppBarUpdater extends updater.Updater {
  ThisPageAppBarUpdater({initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
          updateSpeed: 17,
        );
}

class PropertiesBottomSheetUpdater extends updater.Updater {
  PropertiesBottomSheetUpdater(
      {initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
          updateSpeed: 17,
        );
}

class ZoomUpdater extends updater.Updater {
  ZoomUpdater({initialState, bool updateForCurrentEvent = false})
      : super(
          initialState,
          updateForCurrentEvent: updateForCurrentEvent,
          updateSpeed: 17,
        );
}
