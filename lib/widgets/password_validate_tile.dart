import 'package:flutter/material.dart';

class PasswordValidateTile extends StatelessWidget {
  const PasswordValidateTile({
    Key? key,
    required this.validation,
    required this.title,
  }) : super(key: key);
  final bool validation;
  final String title;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: true,
      onChanged: validation ? (_) => null : null,
      title: Text(
        title,
        style: TextStyle(fontSize: 12),
      ),
      groupValue: validation,
    );
  }
}
