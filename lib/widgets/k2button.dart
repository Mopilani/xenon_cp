import 'package:flutter/material.dart';

class K3Button extends StatelessWidget {
  const K3Button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 100,
      child: MaterialButton(
        color: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}

class K2Button extends StatelessWidget {
  const K2Button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class OnSecondaryTapBottomSheetButton extends StatelessWidget {
  const OnSecondaryTapBottomSheetButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.iconData,
    this.iconColor,
  }) : super(key: key);
  final String text;
  final IconData iconData;
  final Color? iconColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
