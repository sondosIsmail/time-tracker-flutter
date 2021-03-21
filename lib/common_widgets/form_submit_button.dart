import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required String text,
    VoidCallback? onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          color: Colors.indigo,
          onPressed: onPressed,
        );
}
