import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';
import 'package:provider/provider.dart';

class SectionInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final SettingsPos pos; // top:0,middle:1,bottom:2
  final int? maxLength;
  final int? maxLines;
  final String? suffix;
  final String hintText;
  final TextInputType textInputType;
  final String? Function(String? value) validator;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final Function(String? newValue) onSaved;
  final Function(String? value)? onFieldSubmitted;
  final Function(String? valie)? onChanged;

  const SectionInput({
    Key? key,
    required this.pos,
    required this.textEditingController,
    required this.maxLength,
    required this.maxLines,
    required this.suffix,
    required this.hintText,
    required this.textInputType,
    required this.validator,
    required this.onSaved,
    required this.textAlign,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionElement(
      pos: pos,
      hasIndent: false,
      transparant: true,
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        maxLines: maxLines,
        controller: textEditingController,
        style: textBody,
        textAlign: textAlign,
        keyboardType: textInputType,
        // To make sure number keyboard only for Android (if number only)
        inputFormatters: (textInputType == TextInputType.number)
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : <TextInputFormatter>[],
        maxLength: maxLength,
        cursorColor:
            Provider.of<ThemeNotifier>(context).getHighlightColor(false),
        decoration: InputDecoration(
          suffix: (suffix != null)
              ? Text(
                  suffix!,
                  style: textBody,
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(mediumRadius),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(mediumRadius),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(mediumRadius),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.all(
              Radius.circular(mediumRadius),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(mediumRadius),
            ),
          ),
          filled: true,
          fillColor: Provider.of<ThemeNotifier>(context).getCardColor(),
          contentPadding: const EdgeInsets.all(mediumPadding),
          hintText: hintText,
          hintStyle: textBody,
          errorStyle: textFootnote.copyWith(
            color: Colors.red,
          ),
          helperStyle: textBody,
        ),
        autofocus: false,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
