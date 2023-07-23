import 'package:flutter/material.dart';
import 'package:kitapp/base/models/message_model.dart';

import '../../const/app_colors.dart';

class Message extends StatelessWidget {
  const Message({super.key, this.messageModel});

  final MessageModel? messageModel;

  @override
  Widget build(BuildContext context) {
    if (messageModel?.date == null) return const SizedBox();
    if (messageModel?.lastMessage == null) return const SizedBox();
    if (messageModel?.userName == null) return const SizedBox();
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: AppColors.black,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.book, color: AppColors.white),
        ),
        trailing: Text(messageModel?.date ?? ""),
        textColor: AppColors.white,
        title: Text(messageModel?.userName ?? ""),
        subtitle: Text(messageModel?.lastMessage ?? ""),
      ),
    );
  }
}
