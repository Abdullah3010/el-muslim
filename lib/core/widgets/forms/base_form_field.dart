import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/utils/input_field_validator.dart';

abstract class BaseFormField {
  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey<FormFieldState> fieldKey;
  final String hint;
  final String label;
  final String fieldName;
  final bool isRequired;
  final String? customRequiredMessage;
  final ParamsCustomInput? params;
  final List<TextInputFormatter> inputFormatters = [];
  List<String? Function(String?)?>? validators;
  TextInputAction? textInputAction;

  BaseFormField({
    required this.hint,
    required this.label,
    this.fieldName = '',
    this.validators,
    this.isRequired = false,
    this.customRequiredMessage,
    this.params,
  }) : controller = TextEditingController(),
       focusNode = FocusNode(),
       fieldKey = GlobalKey<FormFieldState>(),
       textInputAction = TextInputAction.next;

  String? validate(String? v) {
    final value = v ?? controller.text;
    if (isRequired) {
      final error = InputFieldValidator.validateRequired(
        value: value,
        fieldName: fieldName,
        customMessage: customRequiredMessage,
      );
      if (error != null) {
        return error;
      }
    }
    if (validators != null) {
      for (final validator in (params?.validators ?? validators ?? [])) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
    }
    return null;
  }

  void clear() {
    controller.clear();
  }

  Widget buildField(BuildContext context, {ParamsCustomInput? param});
}
