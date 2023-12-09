import 'package:flutter/material.dart';

import 'updater.dart';
import 'state.dart' as state;

/// Edited on 4/20/2022
/// Add the class [UpdaterOrSpecial] to use the [SpecialUpdater]
/// with the any of the blocs

class UpdaterBloc<T> extends StatefulWidget {
  final Widget Function(BuildContext, state.State) update;
  final UpdaterOrSpecial updater;

  const UpdaterBloc({
    Key? key,
    required this.updater,
    required this.update,
  }) : super(key: key);

  @override
  _UpdaterBlocState<T> createState() => _UpdaterBlocState<T>();
}

class _UpdaterBlocState<T> extends State<UpdaterBloc<T>> {
  _UpdaterBlocState();

  @override
  void initState() {
    super.initState();
    widget.updater;
  }

  Widget _widget({required BuildContext context}) {
    return StreamBuilder<state.State<T>>(
        stream: widget.updater.eventsStream.call<T>(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget.update(context, (snapshot.data as state.State<T>));
          }
          return widget.update(context, state.State());
        });
  }

  @override
  void dispose() {
    super.dispose();
    // print('Disposing ${this.toString()}');
    widget.updater.dispose();
  }

  @override
  Widget build(BuildContext context) => _widget(context: context);
}

class UpdaterBlocWithoutDisposer<T> extends StatefulWidget {
  final Widget Function(BuildContext, state.State) update;
  final dynamic updater;

  const UpdaterBlocWithoutDisposer({
    Key? key,
    required this.updater,
    required this.update,
  }) : super(key: key);

  @override
  _UpdaterBlocWithoutDisposerState<T> createState() =>
      _UpdaterBlocWithoutDisposerState<T>();
}

class _UpdaterBlocWithoutDisposerState<T>
    extends State<UpdaterBlocWithoutDisposer<T>> {
  _UpdaterBlocWithoutDisposerState();

  Widget _widget({required BuildContext context}) {
    return StreamBuilder<state.State<T>>(
        stream: widget.updater.eventsStream.call(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget.update(context, (snapshot.data as state.State<T>));
          }
          return widget.update(context, state.State());
        });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   print('Disposing ${this.toString()}');
  //   widget.updater.dispose();
  // }

  @override
  Widget build(BuildContext context) => _widget(context: context);
}

/// If you used this you must to call dispose for your udater
/// in the dispose in a statefulWidgt
class StatelessUpdaterBloc<T> extends StatelessWidget {
  const StatelessUpdaterBloc(
      {Key? key, required this.updater, required this.update})
      : super(key: key);
  final Widget Function(BuildContext, state.State) update;
  final dynamic updater;
  Widget _widget({required BuildContext context}) {
    return StreamBuilder<state.State<T>>(
        stream: updater.eventsStream.call(),
        builder: (context, snapshot) {
          // print('Data');
          if (snapshot.hasData) {
            return update(context, (snapshot.data as state.State));
          }
          return update(context, state.State());
        });
  }

  @override
  Widget build(BuildContext context) => _widget(context: context);
}

class StatelessUpdaterBloc0<T> extends StatelessWidget {
  const StatelessUpdaterBloc0(
      {Key? key, required this.updater, required this.builder})
      : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<state.State<T>>) builder;
  final dynamic updater;
  Widget _widget({required BuildContext context}) {
    return StreamBuilder<state.State<T>>(
      stream: updater.eventsStream.call(),
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) => _widget(context: context);
}
