import 'package:flutter/material.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';
import 'package:al_muslim/core/widgets/forms/w_shared_field.dart';

class WMultiLineField extends BaseFormField {
  WMultiLineField({
    super.isRequired = true,
    super.hint = '',
    super.label = '',
    super.fieldName = '',
    this.maxLines = 5,
    this.minLines = 3,
  });

  final int maxLines;
  final int minLines;

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return WSharedField(
      controller: controller,
      focusNode: focusNode,
      hint: hint,
      label: label,
      onValidate: validate,
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      onChanged: param?.onChanged,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
