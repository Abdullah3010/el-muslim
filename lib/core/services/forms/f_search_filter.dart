import 'package:al_muslim/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_checkbox_field.dart';
import 'package:al_muslim/core/widgets/forms/w_dropdown_field.dart';
import 'package:al_muslim/core/widgets/forms/w_range_slider_field.dart';
import 'package:al_muslim/core/widgets/forms/w_rating_field.dart';

class FSearchFilter extends BaseFormController {
  FSearchFilter({List<String>? availableCategories, this.minPrice = 0, this.maxPrice = 2000})
    : availableCategories = availableCategories ?? Constants.filterCategoryNames;

  List<String> availableCategories;
  final double minPrice;
  final double maxPrice;

  late WDropdownField<String> categoryField;
  late WRangeSliderField priceRangeField;
  late WRatingField ratingField;
  late WCheckboxField inStockOnlyField;
  late ValueNotifier<RangeValues> priceRangeNotifier;

  RangeValues get priceRange => priceRangeField.currentRange;
  int get rating => ratingField.rating;
  bool get inStockOnly => inStockOnlyField.value;

  @override
  void init() {
    priceRangeNotifier = ValueNotifier<RangeValues>(RangeValues(minPrice, maxPrice));

    categoryField = WDropdownField<String>(
      hint: 'Select category'.translated,
      isRequired: false,
      items: List<String>.from(availableCategories),
    );

    priceRangeField = WRangeSliderField(
      hint: 'Use the slider to set a minimum and maximum price'.translated,
      min: minPrice,
      max: maxPrice,
      showValueChips: false,
      showValueIndicator: false,
      initialRange: priceRangeNotifier.value,
      divisions: null,
      onChanged: (value) => priceRangeNotifier.value = value,
      valueFormatter: (value) => '\$${value.toStringAsFixed(0)}',
    );

    ratingField = WRatingField(
      label: 'Minimum Rating'.translated,
      hint: 'Tap a star to choose the minimum rating'.translated,
      initialRating: 0,
    );

    inStockOnlyField = WCheckboxField(
      // label: 'Availability'.translated,
      checkboxLabel: 'In stock only'.translated,
      initialValue: false,
    );
  }

  @override
  bool validate() {
    return true;
  }

  @override
  void clear() {
    categoryField.clear();
    priceRangeField.clear();
    ratingField.clear();
    inStockOnlyField.clear();
    priceRangeNotifier.value = RangeValues(minPrice, maxPrice);
  }

  void setCategoryItems(List<String> items) {
    availableCategories = List<String>.from(items);
    categoryField.items = List<String>.from(items);
    if (categoryField.controller.text.isNotEmpty && !availableCategories.contains(categoryField.controller.text)) {
      categoryField.clear();
    }
  }
}
