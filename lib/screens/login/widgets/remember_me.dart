import 'package:flutter/material.dart';

import '../../../const/app_text.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkBoxValue,
          onChanged: (value) {
            setState(() {
              checkBoxValue = !checkBoxValue;
            });
          },
        ),
        const Expanded(child: Text(AppText.rememberMe))
      ],
    );
  }
}
