import 'package:flutter/material.dart';
import 'package:kitapp/base/models/message_model.dart';

import '../../base/common_widgets/message.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Message(messageModel: MessageModel("Ali", "selam", "3.10.17")),
      ],
    );
  }
}
