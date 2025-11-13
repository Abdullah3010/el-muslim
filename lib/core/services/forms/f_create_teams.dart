import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/utils/helper/app_alert.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FCreateTeams extends BaseFormController {
  late WTextField gameNameField;
  late WTextField team1NameField;
  late WTextField team2NameField;
  late int team1Members;
  late int team2Members;

  @override
  void init() {
    gameNameField = WTextField(hint: 'Game Name'.translated, isRequired: true);
    team1NameField = WTextField(hint: 'First Team Name'.translated, isRequired: true);
    team2NameField = WTextField(hint: 'Second Team Name'.translated, isRequired: true);
    team1Members = 1;
    team2Members = 1;
  }

  @override
  bool validate() {
    if (team1Members < 1 || team2Members < 1) {
      AppAlert.error('Each team must have at least one member'.translated);
    }
    return (formKey.currentState?.validate() ?? false) && team1Members >= 1 && team2Members >= 1;
  }

  @override
  void clear() {
    gameNameField.controller.clear();
    team1NameField.controller.clear();
    team2NameField.controller.clear();
  }

  Widget prefixIcon() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SvgPicture.asset(Assets.icons.requiredField.path, width: 10.w, height: 10.h),
    );
  }
}
