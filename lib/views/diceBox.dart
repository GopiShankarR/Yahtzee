
import 'package:flutter/material.dart';

class DiceBox extends StatefulWidget {
  final int? value;
  final bool isHeld;
  final Function() onTap;

  const DiceBox({super.key, 
    required this.value,
    required this.isHeld,
    required this.onTap,
  });

  @override
  _DiceBoxState createState() => _DiceBoxState();
}

class _DiceBoxState extends State<DiceBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 90.0,
        height: 90.0,
        child: Card(
          color: widget.isHeld ? Colors.red : Colors.blue,
          child: Center(
            child: Text(
              widget.value == null ? '' : widget.value.toString(),
            style: const TextStyle(fontSize: 25)),
          ),
        ),
      ),
    );
  }
}
