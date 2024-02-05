import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  VoidCallback onTap;
  String buttontext;
  String snakBarMsg;
  double minSize;

  CustomButton({
    required this.onTap,
    required this.buttontext,
    required this.snakBarMsg,
    required this.minSize,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onTap();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${widget.snakBarMsg}")));
      },
      child: Text(widget.buttontext),
      style: ElevatedButton.styleFrom(minimumSize: Size(widget.minSize, 50)),
    );
  }
}
