import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WChangeLocationDialog extends StatelessWidget {
  const WChangeLocationDialog({super.key, required this.locationLabel, this.canConfirm = true});

  final String locationLabel;
  final bool canConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Do you want to change your current location'.translated,
        style: context.textTheme.primary14W400.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
      ),
      content: Text(
        locationLabel,
        style: context.textTheme.primary14W400.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
          color: context.theme.colorScheme.black,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'.translated, style: context.textTheme.primary14W400),
        ),
        TextButton(
          onPressed: canConfirm ? () => Navigator.of(context).pop(true) : null,
          child: Text(
            'Change'.translated,
            style: context.textTheme.primary14W400.copyWith(
              color:
                  canConfirm
                      ? context.theme.colorScheme.primaryColor
                      : context.theme.colorScheme.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ),
      ],
    );
  }
}
