import 'package:flutter/material.dart';

class DomainBoardWidget extends StatelessWidget {
  const DomainBoardWidget({
    Key? key,
    required this.board,
  }) : super(key: key);
  final DomainBoard board;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: board.yp,
      left: board.xp,
      child: Container(
        height: board.height,
        width: board.width,
        color: Color(board.color),
        child: Text(board.title),
      ),
    );
  }
}

class DomainBoard {
  DomainBoard({
    required this.id,
    required this.title,
    required this.color,
    required this.height,
    required this.width,
    required this.xp,
    required this.yp,
  });

  String id;
  String title;
  int color;
  double height;
  double width;
  double xp;
  double yp;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'color': color,
        'height': height,
        'width': width,
        'xp': xp,
        'yp': yp,
      };

  static DomainBoard fromMap(Map<String, dynamic> data) {
    return DomainBoard(
      id: data['id'],
      title: data['title'],
      color: data['color'],
      height: data['height'],
      width: data['width'],
      xp: data['xp'],
      yp: data['yp'],
    );
  }
}
