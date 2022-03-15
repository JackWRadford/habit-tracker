import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsBtn extends StatelessWidget {
  const SettingsBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(CupertinoIcons.slider_horizontal_3),
    );
  }
}
