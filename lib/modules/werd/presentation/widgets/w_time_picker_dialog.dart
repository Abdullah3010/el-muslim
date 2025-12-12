import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay?> showWTimePickerDialog(BuildContext context, {TimeOfDay? initialTime}) {
  final TimeOfDay time = initialTime ?? const TimeOfDay(hour: 8, minute: 0);
  return showDialog<TimeOfDay>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => _WTimePickerDialog(initialTime: time),
  );
}

class _WTimePickerDialog extends StatefulWidget {
  const _WTimePickerDialog({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<_WTimePickerDialog> createState() => _WTimePickerDialogState();
}

class _WTimePickerDialogState extends State<_WTimePickerDialog> {
  late DateTime _tempDateTime;

  @override
  void initState() {
    super.initState();
    _tempDateTime = DateTime(0, 1, 1, widget.initialTime.hour, widget.initialTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: _tempDateTime,
                use24hFormat: false,
                onDateTimeChanged: (value) => _tempDateTime = value,
              ),
            ),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(
                    TimeOfDay(hour: _tempDateTime.hour, minute: _tempDateTime.minute),
                  );
                },
                child: Text(
                  'Confirm'.translated,
                  style: Theme.of(context).textTheme.white16W500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
