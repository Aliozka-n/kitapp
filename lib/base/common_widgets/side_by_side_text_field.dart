import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_sizes.dart';

class SideBySideTextFields extends StatelessWidget {
  final String? labelOne;
  final String? labelTwo;
  final void Function()? onPressed;
  final bool isEdit;

  const SideBySideTextFields({
    Key? key,
    this.labelOne,
    this.labelTwo,
    required this.onPressed,
    this.isEdit = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padding.low,
      margin: const EdgeInsets.only(top: AppSizes.small),
      decoration: const BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$labelOne  :",
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              labelTwo ?? "",
              style: const TextStyle(color: AppColors.white),
            ),
          ),
          isEdit
              ? Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                  ))
              : const SizedBox(height: AppSizes.large)
        ],
      ),
    );
  }
}
