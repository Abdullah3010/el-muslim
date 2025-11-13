import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_email_field.dart';
import 'package:al_muslim/core/widgets/forms/w_multi_line_field.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FContactUs extends BaseFormController {
  late WTextField fullNameField;
  late WEmailField emailField;
  late WPhoneField phoneField;
  late WMultiLineField addSuggestion;
  @override
  void init() {
    fullNameField = WTextField(hint: 'Enter Full Name'.translated);
    emailField = WEmailField(hint: 'Enter Email'.translated);
    phoneField = WPhoneField(hint: 'Enter Phone Number'.translated, isRequired: true);
    addSuggestion = WMultiLineField(hint: 'Enter your suggestion'.translated, maxLines: 6, minLines: 5);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    fullNameField.clear();
    emailField.clear();
    phoneField.clear();
    addSuggestion.clear();
  }
}
