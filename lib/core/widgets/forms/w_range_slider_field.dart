import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';

class WRangeSliderField extends BaseFormField {
  WRangeSliderField({
    required this.min,
    required this.max,
    RangeValues? initialRange,
    this.divisions,
    this.showValueChips = true,
    this.showValueIndicator = true,
    this.onChanged,
    this.valueFormatter,
    super.label = '',
    super.hint = '',
    super.fieldName = '',
    super.isRequired = false,
  }) : assert(min <= max, 'min should be less than or equal to max'),
       currentRange = initialRange ?? RangeValues(min, max);

  final double min;
  final double max;
  final int? divisions;
  final bool showValueChips;
  final bool showValueIndicator;
  RangeValues currentRange;
  final ValueChanged<RangeValues>? onChanged;
  final String Function(double value)? valueFormatter;

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return _RangeSliderFieldContent(
      label: label,
      hint: hint,
      min: min,
      max: max,
      divisions: divisions,
      showValueChips: showValueChips,
      showValueIndicator: showValueIndicator,
      rangeValues: currentRange,
      valueFormatter: valueFormatter,
      onChanged: (value) {
        currentRange = value;
        onChanged?.call(value);
      },
    );
  }

  @override
  void clear() {
    currentRange = RangeValues(min, max);
  }
}

class _RangeSliderFieldContent extends StatefulWidget {
  const _RangeSliderFieldContent({
    required this.label,
    required this.hint,
    required this.min,
    required this.max,
    required this.rangeValues,
    required this.onChanged,
    required this.showValueChips,
    required this.showValueIndicator,
    this.divisions,
    this.valueFormatter,
  });

  final String label;
  final String hint;
  final double min;
  final double max;
  final RangeValues rangeValues;
  final ValueChanged<RangeValues> onChanged;
  final bool showValueChips;
  final bool showValueIndicator;
  final int? divisions;
  final String Function(double value)? valueFormatter;

  @override
  State<_RangeSliderFieldContent> createState() => _RangeSliderFieldContentState();
}

class _RangeSliderFieldContentState extends State<_RangeSliderFieldContent> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = widget.rangeValues;
  }

  @override
  void didUpdateWidget(covariant _RangeSliderFieldContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rangeValues != oldWidget.rangeValues) {
      _values = widget.rangeValues;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = context.textTheme;
    final valueFormatter = widget.valueFormatter ?? _defaultFormatter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.lightGray.withValues(alpha: 0.5),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showValueChips) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RangeValueChip(label: valueFormatter(_values.start), textTheme: textTheme),
                      _RangeValueChip(label: valueFormatter(_values.end), textTheme: textTheme),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.colorScheme.primaryOrange,
                    inactiveTrackColor: theme.colorScheme.lightGray.withValues(alpha: 0.5),
                    trackHeight: 6.h,
                    rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                    thumbColor: theme.colorScheme.primaryOrange,
                    overlayColor: theme.colorScheme.primaryOrange.withValues(alpha: 0.12),
                    rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12.r, pressedElevation: 4),
                    rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
                    showValueIndicator:
                        widget.showValueIndicator ? ShowValueIndicator.always : ShowValueIndicator.never,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 18.r),
                    valueIndicatorColor: theme.colorScheme.secondaryBlue,
                    valueIndicatorTextStyle: textTheme.darkGrey12w500.copyWith(color: theme.colorScheme.white),
                  ),
                  child: RangeSlider(
                    values: _values,
                    min: widget.min,
                    max: widget.max,
                    divisions: widget.divisions,
                    labels: RangeLabels(valueFormatter(_values.start), valueFormatter(_values.end)),
                    onChanged: (newValues) {
                      setState(() {
                        _values = newValues;
                      });
                      widget.onChanged(newValues);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _defaultFormatter(double value) {
    if (value == value.floor()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _RangeValueChip extends StatelessWidget {
  const _RangeValueChip({required this.label, required this.textTheme});

  final String label;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: context.theme.colorScheme.lightGray),
      ),
      child: Text(label, style: textTheme.darkGrey12w500),
    );
  }
}
