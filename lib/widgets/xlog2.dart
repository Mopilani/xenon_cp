import 'package:flutter/material.dart';

import 'package:updater/updater.dart' as updater;
import 'package:xenon_cp/model/log_event.dart';
import 'package:xenon_cp/updaters.dart';
import 'package:xenon_cp/utils/enums.dart';
import 'package:xenon_cp/utils/global_state.dart';

/// Next...
/// Web View For Web View Requests
/// Showing respose headers in the dialog
/// fontsize controle on dialog
/// Show Full Events Height
/// Delete an Event from list
class XLog2 extends StatefulWidget {
  const XLog2({
    Key? key,
    required this.logId,
    this.justUpdateNow,
  }) : super(key: key);
  final String logId;
  final bool? justUpdateNow;

  @override
  State<XLog2> createState() => _XLog2tate();
}

class _XLog2tate extends State<XLog2> {
  ScrollController controller = ScrollController();
  TextEditingController searchBarCont = TextEditingController();

  List<XLogEvent> scssLog = []; // 100
  List<XLogEvent> errLog = []; // 100
  List<XLogEvent> fullLog = []; // 200
  List<XLogEvent> limitedLog = []; // 200

  List<XLogEvent> filteredLog = [];

  bool enableFilteredLog = false;
  // the list has limit of fields for better performece = 100,
  // the old list fields will be droped to be persisted in logs segment
  // then the session log can be fully reloaded
  // other big list will be available in the settings/logs segment

  @override
  void initState() {
    super.initState();
    var _scssLog = GlobalState.get(widget.logId + 'scss');
    if (_scssLog != null) {
      scssLog = _scssLog;
    } else {
      GlobalState.set(widget.logId + 'scss', scssLog);
    }
    var _errLog = GlobalState.get(widget.logId + 'err');
    if (_errLog != null) {
      errLog = _errLog;
    } else {
      GlobalState.set(widget.logId + 'err', errLog);
    }
    var _limitedLog = GlobalState.get(widget.logId + 'lmtd');
    if (_limitedLog != null) {
      limitedLog = _limitedLog;
    } else {
      GlobalState.set(widget.logId + 'lmtd', limitedLog);
    }
    var _fullLog = GlobalState.get(widget.logId + 'full');
    if (_fullLog != null) {
      fullLog = _fullLog;
    } else {
      GlobalState.set(widget.logId + 'full', fullLog);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // GlobalState.set(widget.logId + 'scss', scssLog);
    // GlobalState.set(widget.logId + 'err', errLog);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return updater.StatelessUpdaterBloc(
        updater: XLog2Updater(
          widget.logId,
          initialState: '',
          updateForCurrentEvent: true,
        ),
        update: (context, state) {
          scssLog = GlobalState.get(widget.logId + 'scss');
          errLog = GlobalState.get(widget.logId + 'err');
          limitedLog = GlobalState.get(widget.logId + 'lmtd');
          fullLog = GlobalState.get(widget.logId + 'full');
          limitedLog = limitedLog.reversed.toList();

          try {
            Future.delayed(
                const Duration(
                  milliseconds: 200,
                ), () {
              // controller.animateTo(
              //   controller.position.minScrollExtent,
              //   duration: const Duration(milliseconds: 100),
              //   curve: Curves.ease,
              // );
            });
          } catch (e) {
            //
          }

          Widget _widget() => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: MaterialButton(
                                      // constraints: BoxConstraints(maxHeight: 10, maxWidth: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.clear,
                                        ),
                                      ),
                                      // iconSize: 15,
                                      onPressed: () {
                                        enableFilteredLog = false;
                                        searchBarCont.clear();
                                        XLog2Updater(widget.logId).add('');
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: TextField(
                                        controller: searchBarCont,
                                        textAlignVertical:
                                            TextAlignVertical.top,
                                        // style: TextStyle(fontSize: 16),
                                        cursorColor: Colors.transparent,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(4),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                          hoverColor: Colors.transparent,
                                          fillColor: Colors.black12,
                                          focusColor: Colors.transparent,
                                          filled: true,
                                          hintText: 'Search',
                                        ),
                                        onSubmitted: (result) {
                                          var _rtlc = result.toLowerCase();
                                          filteredLog.clear();
                                          for (var i in fullLog) {
                                            if (i.scssMsg != null) {
                                              if (i.scssMsg!
                                                  .toLowerCase()
                                                  .contains(_rtlc)) {
                                                filteredLog.add(i);
                                              }
                                            } else if (i.errorMsg != null) {
                                              if (i.errorMsg!
                                                  .toLowerCase()
                                                  .contains(_rtlc)) {
                                                filteredLog.add(i);
                                              }
                                            }
                                          }
                                          enableFilteredLog = true;
                                          XLog2Updater(widget.logId).add('');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(width: 40),
                            Row(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: MaterialButton(
                                    // constraints: BoxConstraints(maxHeight: 10, maxWidth: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.clear,
                                      ),
                                    ),
                                    onPressed: () {
                                      scssLog.clear();
                                      errLog.clear();
                                      limitedLog.clear();
                                      fullLog.clear();
                                      GlobalState.set(
                                          widget.logId + 'scss', scssLog);
                                      GlobalState.set(
                                          widget.logId + 'full', fullLog);
                                      GlobalState.set(
                                          widget.logId + 'lmtd', limitedLog);
                                      GlobalState.set(
                                          widget.logId + 'err', errLog);
                                      XLog2Updater(widget.logId).add(
                                          'Log Cleared on ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: MaterialButton(
                                    // constraints: BoxConstraints(maxHeight: 10, maxWidth: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.copy,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                // const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(4),
                        itemCount: enableFilteredLog
                            ? filteredLog.length
                            : limitedLog.length,
                        itemBuilder: (context, index) {
                          return logItem(
                            (enableFilteredLog
                                ? filteredLog[index]
                                : limitedLog[index]),
                            context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          return _widget();
        },
      );
    } catch (e) {
      return const Text('Error');
    }
  }

  Widget logItem(XLogEvent event, context) {
    var isError = event.errorMsg != null ? true : false;
    var _event = event.scssMsg ?? event.errorMsg;
    var _dateTime = event.dateTime;
    var _dateTimeShort =
        '${DateTime.parse(event.dateTime).hour}:${DateTime.parse(event.dateTime).minute}:${DateTime.parse(event.dateTime).second}:${DateTime.parse(event.dateTime).millisecond}';
    var _proiority = event.proiority;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          () {
                            if (isError) {
                              if (_proiority == LogProiority.high) {
                                return const Icon(Icons.error,
                                    color: Colors.red);
                              } else if (_proiority == LogProiority.medium) {
                                return const Icon(Icons.error,
                                    color: Colors.yellow);
                              } else {
                                return const Icon(Icons.error,
                                    color: Colors.grey);
                              }
                            } else {
                              if (_proiority == LogProiority.high) {
                                return const Icon(Icons.done,
                                    color: Colors.red);
                              } else if (_proiority == LogProiority.medium) {
                                return const Icon(Icons.done,
                                    color: Colors.yellow);
                              } else {
                                return const Icon(Icons.done,
                                    color: Colors.blueGrey);
                              }
                            }
                          }.call(),
                          // const SizedBox(height: 8),
                          Text(
                            'at: $_dateTime',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(_event!),
                    ],
                  ),
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
            '$_dateTimeShort: $_event',
          ),
        ),
      ),
    );
  }
}


        // XLog2Updater(
        //   widget.logId,
        //   initialState: '',
        //   updateForCurrentEvent: true,
        // ),
          // debugPrint(state.data.toString());
          // if (state.hasData) {
          //   var data = state.data.toString();
          //   if (data != '') {
          //     fullLog.add(data);
          //     limitedLog.add(data);
          //     scssLog.add(data);
          //     if (scssLog.length > 120) {
          //       for (var i = 0; i < 20; i++) {
          //         scssLog.removeAt(i);
          //       }
          //     }
          //     GlobalState.set(widget.logId + 'full', fullLog);
          //     GlobalState.set(widget.logId + 'lmtd', limitedLog);
          //     GlobalState.set(widget.logId + 'scss', scssLog);

          //     try {
          //       Future.delayed(
          //           const Duration(
          //             milliseconds: 150,
          //           ), () {
          //         controller.jumpTo(
          //           controller.position.maxScrollExtent,
          //           // duration: const Duration(milliseconds: 100),
          //           // curve: Curves.ease,
          //         );
          //       });
          //     } catch (e) {
          //       //
          //     }
          //   }
          // }
          // if (state.hasError) {
          //   var error = state.error.toString();
          //   if (error != '') {
          //     fullLog.add(error);
          //     limitedLog.add(error);
          //     errLog.add(error);
          //     if (errLog.length > 120) {
          //       for (var i = 0; i < 20; i++) {
          //         errLog.removeAt(i);
          //       }
          //     }
          //     GlobalState.set(widget.logId + 'full', fullLog);
          //     GlobalState.set(widget.logId + 'lmtd', limitedLog);
          //     GlobalState.set(widget.logId + 'err', errLog);
