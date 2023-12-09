import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;
import 'package:xenon_cp/updaters.dart';

import '../utils/global_state.dart';


class XLog extends StatefulWidget {
  const XLog({Key? key, required this.logId}) : super(key: key);
  final String logId;

  @override
  State<XLog> createState() => _XLogState();
}

class _XLogState extends State<XLog> {
  ScrollController controller = ScrollController(debugLabel: 'XLog_Cont');
  TextEditingController searchBarCont = TextEditingController();
  List<String> log = [];
  List<String> filteredLog = [];

  bool enableFilteredLog = false;

  @override
  void initState() {
    super.initState();
    var result = GlobalState.get(widget.logId);
    if (result != null) {
      log = result;
    }
  }

  @override
  void dispose() {
    super.dispose();
    GlobalState.set(widget.logId, log);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return updater.StatelessUpdaterBloc(
        updater: LogUpdater(
          widget.logId,
          initialState: '',
          updateForCurrentEvent: true,
        ),
        update: (context, state) {
          // debugPrint(state.data.toString());
          if (state.hasData) {
            if (state.data.toString() != '') {
              log.add(state.data.toString());
              try {
                Future.delayed(
                    const Duration(
                      milliseconds: 200,
                    ), () {
                  controller.animateTo(
                    controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease,
                  );
                });
              } catch (e) {
                //
              }
            }
          }
          var _widget = Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            // color: Theme.of(context).colorScheme.secondary,
            elevation: 0,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  // width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              enableFilteredLog = false;
                              searchBarCont.clear();
                              LogUpdater(widget.logId).add('');
                            },
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            height: 35,
                            child: TextField(
                              controller: searchBarCont,
                              textAlignVertical: TextAlignVertical.top,
                              // style: TextStyle(fontSize: 16),
                              cursorColor: Colors.transparent,
                              decoration: const InputDecoration(
                                hoverColor: Colors.transparent,
                                fillColor: Colors.black12,
                                focusColor: Colors.transparent,
                                filled: true,
                                hintText: 'Search',
                              ),
                              onSubmitted: (result) {
                                var _rtlc = result.toLowerCase();
                                filteredLog.clear();
                                for (var i in log) {
                                  if (i.toLowerCase().contains(_rtlc)) {
                                    filteredLog.add(i);
                                  }
                                }
                                enableFilteredLog = true;
                                LogUpdater(widget.logId).add('');
                              },
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(width: 40),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                            ),
                            onPressed: () {
                              log.clear();
                              LogUpdater(widget.logId).add(
                                  'Log Cleared on ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                              GlobalState.set(widget.logId, log);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.save,
                            ),
                            onPressed: () {
                              GlobalState.set(widget.logId, log);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(4),
                    itemCount:
                        enableFilteredLog ? filteredLog.length : log.length,
                    itemBuilder: (context, index) {
                      return logItem(
                        (enableFilteredLog ? filteredLog[index] : log[index]),
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
          return _widget;
        },
      );
    } catch (e) {
      return const Text('Error');
    }
  }

  Widget logItem(record, context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                height: 500,
                width: 800,
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SelectableText(record),
                ),
              ),
            );
          },
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 100,
          minHeight: 30,
        ),
        child: Container(
          // height: 50,
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            record,
          ),
        ),
      ),
    );
  }
}
