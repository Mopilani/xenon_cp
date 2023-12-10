import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeleprompterView extends StatefulWidget {
  const TeleprompterView({super.key});

  @override
  State<TeleprompterView> createState() => _TeleprompterViewState();
}

class _TeleprompterViewState extends State<TeleprompterView> {
  String text = '';
  RxBool play = false.obs;
  RxInt speed = 96.obs;
  RxInt offset = 96.obs;
  Color? backgroundColor;

  ScrollController scrollController = ScrollController(
      // onAttach: (pos) {
      //   print(pos.pixels);
      //   print(pos.maxScrollExtent);
      // },
      );
  late TextEditingController contentCont;

  @override
  void initState() {
    contentCont = TextEditingController(text: text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            children: [
              if (!play.value)
                Expanded(
                  child: TextField(
                    controller: contentCont,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          // borderSide: BorderSide(color: Colors.black),
                          ),
                    ),
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    onChanged: (txt) {
                      text = txt;
                    },
                  ),
                ),
              if (play.value)
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow_rounded),
                    onPressed: () async {
                      play.value = true;
                      await Future.delayed(
                        const Duration(milliseconds: 200),
                      );
                      // print(
                      //     '/////////// Max offset: ${scrollController.position.pixels}');
                      print(text.split('\n').length * offset.value.toDouble());
                      scrollController.animateTo(
                        // scrollController.position.maxScrollExtent,
                        text.split('\n').length * 100,
                        duration: Duration(seconds: speed.value * 2),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause_rounded),
                    onPressed: !play.value
                        ? null
                        : () {
                            play.value = false;
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop_rounded),
                    onPressed: !play.value
                        ? null
                        : () {
                            play.value = false;
                            scrollController.animateTo(
                              0,
                              duration: const Duration(seconds: 2),
                              curve: Curves.bounceIn,
                            );
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.plus_one),
                    onPressed: () {
                      speed.value += 5;
                    },
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(speed.value.toString()),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.exposure_minus_1),
                    onPressed: () {
                      speed.value -= 5;
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.view_agenda_outlined),
                    onPressed: () {
                      if (backgroundColor == Colors.transparent) {
                        backgroundColor = null;
                        setState(() {});
                      } else {
                        backgroundColor = Colors.transparent;
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
