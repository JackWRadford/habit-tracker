import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsBtn extends StatelessWidget {
  const SettingsBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigate to settings view
        Navigator.pushNamed(
          context,
          '/settingsView',
        );
      },
      icon: const Icon(CupertinoIcons.line_horizontal_3),
    );
  }
}
