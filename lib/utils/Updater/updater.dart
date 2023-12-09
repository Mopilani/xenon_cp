@Version('0.5.1')

library updater;

import 'dart:async';

import 'package:updater/ext/nexa_base_framework-0.3-Master/annotations.dart';

import 'state.dart';

// import 'package:flutter/material.dart' hide State;

/// Edited on 4/20/2022
/// Add the class [UpdaterOrSpecial] to use the [SpecialUpdater]
/// with the any of the blocs

abstract class UpdaterOrSpecial {
  Stream<State<T>> eventsStream<T>();
  void dispose();
}

Map<String, dynamic> _updatersCache = {};

/// By extending [Updater] class and making a new updater
/// instance [u] that saved in the [_updatersCache], you
/// must not recall the [u] by it's default constractor
/// cause it will resave it in the [_updaterCache] and the
/// data in the previous stream may be lost
class Updater<T> extends UpdaterOrSpecial {
  Updater(
    initialState, {
    int updateSpeed = 14,
    updateForCurrentEvent = true,
  }) {
    _updateSpeed = updateSpeed;
    // if (!_updatersCache.containsKey(toString())) {
    // print('////////////////////////////////');
    // print('Supr Initialaized, Adding ${toString()}');
    // if (initialState != null) {
    if (updateForCurrentEvent) {
      currentEvent = initialState;
      _updatersCache.addAll({toString(): this});
    }
    // print('INITIALAIZED///////////////');
    // print(currentEvent);
    // }
    // }
    // currentEvent = initialState;
    // _updatersCache.addAll({toString(): this});
  }

  /// Get The Events Stream That provided by the updater
  /// in the realtime
  Stream<State<T>> eventsStream<T>() {
    // print('Stream Geted');
    try {
      // print('------------------------');
      // print(_updatersCache[toString()]);
      // print(_updatersCache);
      return (_updatersCache[toString()] as Updater)._updater<T>();
    } catch (e) {
      rethrow;
    }
  }

  late int _updateSpeed;
  var currentError;
  var watchingError;
  var currentEvent;
  var _objectToWatch;
  var _oldObjectState;
  var _objectWatching = false;
  bool initialized = true;

  /// Dispose the updater instance after your events adding
  /// stopped
  void dispose() {
    // print('dispose');
    if (_updatersCache.containsKey(toString())) {
      _updatersCache.remove(toString());
    }
  }

  // An internal functions that used to initialize the
  // events stream
  Stream<State<T>> _updater<T>() async* {
    while (initialized) {
      await Future.delayed(
        Duration(milliseconds: _updateSpeed),
      );
      // print('Fromt Updater Fnction');
      // print(currentEvent);
      // print('Fromt Updater Fnction');
      if (currentEvent != null) {
        yield State(data: currentEvent, error: currentError);
        currentEvent = null;
        currentError = null;
      }
      if (_objectWatching) {
        if (_objectToWatch == _oldObjectState) {
        } else {
          yield State(data: _objectToWatch, error: watchingError);
          _oldObjectState = _objectToWatch;
        }
      }
    }
    // print('Stream Ended');
  }

  /// Add a new event to the updater instance to be passed
  /// to the events listeners
  void add(T event) {
    // print(event);
    // print(_updatersCache);
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as Updater).currentEvent = event;
    }
  }

  /// Watch an object state changes and provide it's events
  /// to the listeners
  void watch(object) {
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as Updater)._objectToWatch = object;
      (_updatersCache[toString()] as Updater)._objectWatching = true;
    }
  }

  void error(error) {
    if (_updatersCache.containsKey(toString())) {
      (_updatersCache[toString()] as Updater).currentError = error;
    }
  }

  /// Get the current updater instance name as string
  @override
  String toString() => runtimeType.toString();
}

// This must empelement updater
class SpecialUpdater<T> extends UpdaterOrSpecial {
  SpecialUpdater(
    this.updaterSpecialId,
    T initialState, {
    int updateSpeed = 14,
    updateForCurrentEvent = true,
  }) {
    _updateSpeed = updateSpeed;
    // if (!_updatersCache.containsKey(toString())) {
    // print('////////////////////////////////');
    // print('Supr Initialaized, Adding ${toString()}');
    // if (initialState != null) {
    if (updateForCurrentEvent) {
      currentEvent = initialState;
      if (_updatersCache.containsKey(updaterSpecialId) &&
          _updatersCache[updaterSpecialId] != null) {
      } else {
        _updatersCache.addAll({updaterSpecialId: this});
      }
    }
    // print('INITIALAIZED///////////////');
    // print(currentEvent);
    // }
    // }
    // currentEvent = initialState;
    // _updatersCache.addAll({toString(): this});
  }

  /// Get The Events Stream That provided by the updater
  /// in the realtime
  Stream<State<T>> eventsStream<T>() {
    // print('Stream Geted');
    try {
      // print('------------------------');
      // print(_updatersCache[toString()]);
      // print(_updatersCache);
      return (_updatersCache[updaterSpecialId] as SpecialUpdater)._updater<T>();
    } catch (e) {
      rethrow;
    }
  }

  String updaterSpecialId;
  late int _updateSpeed;
  var currentError;
  var watchingError;
  var currentEvent;
  var _objectToWatch;
  var _oldObjectState;
  var _objectWatching = false;
  bool initialized = true;

  /// Dispose the updater instance after your events adding
  /// stopped
  void dispose() {
    // print('dispose');
    if (_updatersCache.containsKey(updaterSpecialId)) {
      _updatersCache.remove(updaterSpecialId);
    }
  }

  // An internal functions that used to initialize the
  // events stream
  Stream<State<T>> _updater<T>() async* {
    while (initialized) {
      await Future.delayed(
        Duration(milliseconds: _updateSpeed),
      );
      // print('Fromt Updater Fnction');
      // print(currentEvent);
      // print('Fromt Updater Fnction');
      if (currentEvent != null) {
        yield State(data: currentEvent, error: currentError);
        currentEvent = null;
        currentError = null;
      }
      if (_objectWatching) {
        if (_objectToWatch == _oldObjectState) {
        } else {
          yield State(data: _objectToWatch, error: watchingError);
          _oldObjectState = _objectToWatch;
        }
      }
    }
    // print('Stream Ended');
  }

  /// Add a new event to the updater instance to be passed
  /// to the events listeners
  void add(T event) {
    // print(event);
    // print(_updatersCache);
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdater).currentEvent = event;
    }
  }

  /// Watch an object state changes and provide it's events
  /// to the listeners
  void watch(object) {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdater)._objectToWatch =
          object;
      (_updatersCache[updaterSpecialId] as SpecialUpdater)._objectWatching =
          true;
    }
  }

  void error(error) {
    if (_updatersCache.containsKey(updaterSpecialId)) {
      (_updatersCache[updaterSpecialId] as SpecialUpdater).currentError = error;
    }
  }

  /// Get the current updater instance name as string
  @override
  String toString() => runtimeType.toString() + '-' + updaterSpecialId;
}

// class UpdaterBloc extends StatelessWidget {
//   const UpdaterBloc({Key? key, required this.updater, required this.builder}) : super(key: key);
//   final Widget Function(BuildContext, AsyncSnapshot<State>) builder;
//   final Updater updater;
//   Widget _widget({required BuildContext context}) {
//     return StreamBuilder(
//       stream: updater.eventsStream.call(),
//       builder: builder,
//     );
//   }

//   @override
//   Widget build(BuildContext context) => _widget(context: context);
// }

abstract class Observer {
  Stream<dynamic> transforme(stream) {
    transformer = StreamTransformer.fromHandlers(
        handleData: onData, handleDone: onDone, handleError: onError);
    return transformer.bind(stream);
  }

  late StreamTransformer transformer;
  // late Stream<dynamic> transformedStream;

  void onData(dynamic data, EventSink<dynamic> sink);
  void onDone(EventSink<dynamic> sink);
  void onError(Object object, StackTrace stackTrace, EventSink<dynamic> sink);
}

// class MyOB extends Observer {
//   @override
//   void onData(data, EventSink sink) {}

//   @override
//   void onDone(EventSink sink) {
//     // ignore: todo
//     // TODO: implement onDone
//   }

//   @override
//   void onError(Object object, StackTrace stackTrace, EventSink sink) {
//     // ignore: todo
//     // TODO: implement onError
//   }
// }

// import 'dart:async';

// import 'package:acog/UPDATER/state.dart';

// import 'package:flutter/material.dart' hide State;

// Map<String, dynamic> _updatersCache = {};

// class Updater {
//   Updater(
//     initialState, {
//     int updateSpeed = 8,
//     updateForCurrentEvent = true,
//   }) {
//     _updateSpeed = updateSpeed;
//     if (!_updatersCache.containsKey(this.toString())) {
//       print(true);
//       currentEvent = initialState;
//       _updatersCache.addAll({this.toString(): this});
//     }
//   }

//   Stream<State> get eventsStream => _updater();

//   late int _updateSpeed;
//   var currentError;
//   var watchingError;
//   var currentEvent;
//   var _objectToWatch;
//   var _oldObjectState;
//   var _objectWatching = false;

//   void dispose() {
//     if (_updatersCache.containsKey(this.toString())) {
//       _updatersCache.remove(this.toString());
//     }
//   }

//   Stream<State> _updater() async* {
//     while (initialized) {
//       await Future.delayed(
//         Duration(milliseconds: _updateSpeed),
//       );
//       if (currentEvent != null) {
//         yield State(data: currentEvent, error: currentError);
//         currentEvent = null;
//         currentError = null;
//       }
//       if (_objectWatching) {
//         if (_objectToWatch == _oldObjectState) {
//         } else {
//           yield State(data: _objectToWatch, error: watchingError);
//           _oldObjectState = _objectToWatch;
//         }
//       }
//     }
//   }

//   bool initialized = true;

//   void add<T>(T event) {
//     // print(event);
//     // print(_updatersCache);
//     if (_updatersCache.containsKey(this.toString())) {
//       (_updatersCache[this.toString()] as Updater).currentEvent = event;
//     }
//   }

//   void watch(object) {
//     if (_updatersCache.containsKey(this.toString())) {
//       (_updatersCache[this.toString()] as Updater)._objectToWatch = object;
//       (_updatersCache[this.toString()] as Updater)._objectWatching = true;
//     }
//   }

//   void error(error) {
//     if (_updatersCache.containsKey(this.toString())) {
//       (_updatersCache[this.toString()] as Updater).currentError = error;
//     }
//   }

//   @override
//   String toString() => this.runtimeType.toString();
// }

// class UpdaterBloc extends StatelessWidget {
//   UpdaterBloc({required this.updater, required this.builder});
//   final Widget Function(BuildContext, AsyncSnapshot<State>) builder;
//   final Updater updater;
//   Widget _widget({required BuildContext context}) {
//     return StreamBuilder(
//       stream: updater.eventsStream,
//       builder: builder,
//     );
//   }

//   @override
//   Widget build(BuildContext context) => _widget(context: context);
// }

// class Observer {
//   Observer(stream) {
//     var transformer = StreamTransformer.fromHandlers(
//         handleData: onData, handleDone: onDone, handleError: onError);
//     var transformedStream = transformer.bind(stream);
//   }

//   void onData(dynamic data, EventSink<dynamic> sink) {}
//   void onDone(EventSink<dynamic> sink) {}
//   void onError(Object object, StackTrace stackTrace, EventSink<dynamic> sink) {}
// }

// class MyOB implements Observer {
//   @override
//   void onData(data, EventSink sink) {}

//   @override
//   void onDone(EventSink sink) {}

//   @override
//   void onError(Object object, StackTrace stackTrace, EventSink sink) {}
// }

// Stream<State> get eventsStream {
//   if (initialized) {
//     if (_updatersCache.containsKey(this.toString())) {
//       _updatersCache.remove(this.toString());
//     }
//     return _updater();
//   } else {
//     return _updater();
//   }
// }
