import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/forms/base_form_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class WPinCodeField extends BaseFormField {
  WPinCodeField({super.isRequired = true, super.label = '', super.hint = '', this.errorController});

  StreamController<ErrorAnimationType>? errorController;

  @override
  Widget buildField(BuildContext context, {ParamsCustomInput? param}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        enabled: true,
        appContext: context,
        controller: controller,
        focusNode: focusNode,
        length: 4,
        animationType: AnimationType.fade,
        keyboardType: TextInputType.number,
        textStyle: context.textTheme.black18w700Arial,
        backgroundColor: Colors.transparent,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: 39.h,
          fieldWidth: 48.w,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
          activeFillColor: Colors.white,
          activeColor: context.theme.colorScheme.primaryOrange,
          disabledColor: context.theme.colorScheme.darkGray.withValues(alpha: 0.5),
          inactiveColor: context.theme.colorScheme.darkGray.withValues(alpha: 0.5),
          selectedColor: context.theme.colorScheme.darkGray.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4.r),
          errorBorderWidth: 2,
          disabledBorderWidth: 2,
          errorBorderColor: Colors.red,
          activeBorderWidth: 2,
          borderWidth: 2,
          inactiveBorderWidth: 2,
          selectedBorderWidth: 2,
        ),
        cursorColor: context.theme.colorScheme.black,
        cursorHeight: 20.h,
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: true,
        errorAnimationController: errorController,
        onCompleted: param?.pinCodeOptions?.onCompleted,
      ),
    );
  }
}
