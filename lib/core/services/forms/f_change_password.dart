import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_confirm_password_field.dart';
import 'package:al_muslim/core/widgets/forms/w_password_field.dart';

class FChangePassword extends BaseFormController {
  late WPasswordField currentPasswordField;
  late WPasswordField newPasswordField;
  late WConfirmPasswordField confirmNewPasswordField;

  @override
  void init() {
    currentPasswordField = WPasswordField(hint: 'Current Password'.translated);
    newPasswordField = WPasswordField(hint: 'New Password'.translated);
    confirmNewPasswordField = WConfirmPasswordField(hint: 'Re-enter New Password'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    currentPasswordField.clear();
    newPasswordField.clear();
    confirmNewPasswordField.clear();
  }
}
