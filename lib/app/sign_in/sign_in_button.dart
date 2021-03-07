import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Color? color,
    Color? textColor,
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
