import 'package:flutter/material.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';
import 'package:al_muslim/core/widgets/forms/w_shared_field.dart';

class WTextField extends BaseFormField {
  WTextField({super.isRequired = true, super.hint = '', super.label = '', super.fieldName = '', super.validators});

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return WSharedField(
      controller: controller,
      focusNode: focusNode,
      hint: hint,
      label: label,
      prefixIcon: param?.prefixIcon,
      suffixIcon: param?.suffixIcon,
      onValidate: validate,
      keyboardType: TextInputType.text,
      textInputAction: param?.inputAction ?? textInputAction,
      onChanged: param?.onChanged,
      onFieldSubmitted: param?.onFieldSubmitted,
      enabled: param?.enabled ?? true,
      maxLines: param?.maxLines,
      minLines: param?.minLines,
      maxLength: param?.maxLength,
      inputFormatters: inputFormatters,
      border: param?.border,
      focusedBorder: param?.focusedBorder,
      errorBorder: param?.errorBorder,
      enabledBorder: param?.enabledBorder,
      disabledBorder: param?.disabledBorder,
      contentPadding: param?.contentPadding,
    );
  }
}
