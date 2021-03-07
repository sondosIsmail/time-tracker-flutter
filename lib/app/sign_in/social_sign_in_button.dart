import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    Color? color,
    Color? textColor,
    required String assetName,
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Row(
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(assetName),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          color: color,
          onPressed: onPressed,
        );
}
