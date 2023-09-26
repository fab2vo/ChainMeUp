import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key, required this.cardnumber});
  final int cardnumber;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {print("You swiped the raised button $cardnumber"); },
      child: Text('$cardnumber'),
    );
  }
}