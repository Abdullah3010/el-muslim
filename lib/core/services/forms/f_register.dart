import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/utils/input_field_validator.dart';
import 'package:al_muslim/core/widgets/forms/w_email_field.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FRegister extends BaseFormController {
  late WPhoneField phoneField;
  late WTextField usernameField;
  late WEmailField emailField;

  @override
  void init() {
    usernameField = WTextField(hint: 'Username'.translated, validators: [InputFieldValidator.validateFullName]);
    phoneField = WPhoneField(hint: 'Phone Number'.translated);
    emailField = WEmailField(hint: 'Email'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    usernameField.clear();
    phoneField.clear();
    emailField.clear();
  }
}
