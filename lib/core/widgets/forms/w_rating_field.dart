import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';

class WRatingField extends BaseFormField {
  WRatingField({
    super.label = '',
    super.hint = '',
    super.fieldName = '',
    super.isRequired = false,
    this.maxRating = 5,
    int initialRating = 0,
    this.iconSize,
    this.spacing,
    this.onChanged,
    this.filledIcon = Icons.star,
    this.outlinedIcon = Icons.star_border,
  }) : assert(initialRating >= 0 && initialRating <= maxRating, 'initialRating must be between 0 and maxRating'),
       _rating = initialRating;

  final int maxRating;
  final double? iconSize;
  final double? spacing;
  final ValueChanged<int>? onChanged;
  final IconData filledIcon;
  final IconData outlinedIcon;
  int _rating;

  int get rating => _rating;

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return _RatingFieldContent(
      label: label,
      hint: hint,
      maxRating: maxRating,
      iconSize: iconSize,
      spacing: spacing,
      filledIcon: filledIcon,
      outlinedIcon: outlinedIcon,
      rating: _rating,
      onChanged: (value) {
        _rating = value;
        onChanged?.call(value);
      },
    );
  }

  @override
  void clear() {
    _rating = 0;
  }
}

class _RatingFieldContent extends StatefulWidget {
  const _RatingFieldContent({
    required this.label,
    required this.hint,
    required this.maxRating,
    required this.rating,
    required this.onChanged,
    this.iconSize,
    this.spacing,
    this.filledIcon = Icons.star,
    this.outlinedIcon = Icons.star_border,
  });

  final String label;
  final String hint;
  final int maxRating;
  final int rating;
  final ValueChanged<int> onChanged;
  final double? iconSize;
  final double? spacing;
  final IconData filledIcon;
  final IconData outlinedIcon;

  @override
  State<_RatingFieldContent> createState() => _RatingFieldContentState();
}

class _RatingFieldContentState extends State<_RatingFieldContent> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(covariant _RatingFieldContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      _currentRating = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final itemSpacing = widget.spacing ?? 8.w;
    final iconDimension = widget.iconSize ?? 32.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
            child: Wrap(
              spacing: itemSpacing,
              children: List.generate(widget.maxRating, (index) {
                final starIndex = index + 1;
                final isActive = starIndex <= _currentRating;
                return GestureDetector(
                  onTap: () => _updateRating(starIndex),
                  child: Icon(
                    isActive ? widget.filledIcon : widget.outlinedIcon,
                    color: isActive ? theme.colorScheme.gold : theme.colorScheme.lightGray,
                    size: iconDimension,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void _updateRating(int value) {
    setState(() {
      _currentRating = value;
    });
    widget.onChanged(value);
  }
}
