import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_toggle.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.settings, style: textFootnote),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
          child: Column(
            children: [
              // Dark mode toggle
              SectionToggle(
                title: AppLocalizations.of(context)!.darkMode,
                onChanged: (value) {
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .setTheme(value);
                },
                pos: SettingsPos.solo,
                value: Provider.of<ThemeNotifier>(context).getIsDarkMode(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
