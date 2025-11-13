import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_confirm_password_field.dart';
import 'package:al_muslim/core/widgets/forms/w_email_field.dart';
import 'package:al_muslim/core/widgets/forms/w_password_field.dart';
import 'package:al_muslim/core/widgets/forms/w_pin_code_field.dart';

class FForgetPassword extends BaseFormController {
  /// [Step 1]
  late WEmailField emailField;

  /// [Step 2]
  late WPinCodeField pinCodeField;

  /// [Step 3]
  late WPasswordField passwordField;
  late WConfirmPasswordField confirmPasswordField;

  @override
  void init() {
    emailField = WEmailField(hint: 'Enter Email'.translated);
    pinCodeField = WPinCodeField(hint: '');
    passwordField = WPasswordField(hint: 'New Password'.translated);
    confirmPasswordField = WConfirmPasswordField(hint: 'Re-enter New Password'.translated);
  }

  @override
  bool validate() {
    return passwordField.controller.text.isNotEmpty && confirmPasswordField.controller.text.isNotEmpty;
  }

  @override
  void clear() {
    emailField.clear();
    pinCodeField.clear();
    passwordField.clear();
    confirmPasswordField.clear();
  }
}
