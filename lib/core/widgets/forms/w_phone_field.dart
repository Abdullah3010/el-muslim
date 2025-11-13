import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/utils/input_field_validator.dart';
import 'package:al_muslim/core/utils/input_formatters/phone_number_formatter.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';
import 'package:al_muslim/core/widgets/forms/w_shared_field.dart';

class WPhoneField extends BaseFormField {
  WPhoneField({
    super.isRequired = false,
    super.hint = '',
    super.label = '',
    super.validators = const [InputFieldValidator.validateOptionalPhoneNumber],
    super.fieldName = '',
  });

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return WSharedField(
          validatorKey: fieldKey,
          controller: controller,
          inputFormatters: [
            PhoneNumberFormatter(),
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
            FilteringTextInputFormatter.deny(RegExp(r'^( |0)')),
          ],
          hint: hint,
          label: label,
          onValidate: (value) {
            return validate(value);
          },
          keyboardType: TextInputType.phone,
          textInputAction: textInputAction,
          onChanged: param?.onChanged,
          textDirection: TextDirection.ltr,
          prefixIcon: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                12.widthBox,
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(Assets.images.syriaFlag.path, width: 30.w, height: 20.h),
                ),
                8.widthBox,
                Text('+963'.translated, style: context.theme.inputDecorationTheme.hintStyle),
                8.widthBox,
                VerticalDivider(
                  color: context.theme.colorScheme.black,
                  thickness: 1,
                  width: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                8.widthBox,
              ],
            ),
          ),
          enabled: param?.enabled ?? true,
        );
      },
    );
  }

  String toApiBody() {
    return '${Constants.countryCode}${controller.text.replaceAll(' ', '')}';
  }

  /// Set raw digits (no spaces) and apply the same formatter used on input.
  void setRawDigits(String digits) {
    final cleaned = digits.replaceAll(RegExp(r'[^0-9]'), '');
    final formatter = PhoneNumberFormatter();
    final formatted = formatter.formatEditUpdate(
      const TextEditingValue(text: ''),
      TextEditingValue(text: cleaned, selection: TextSelection.collapsed(offset: cleaned.length)),
    );
    controller.value = formatted;
  }
}
