import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';

class FLogin extends BaseFormController {
  late WPhoneField phoneField;

  @override
  void init() {
    phoneField = WPhoneField(hint: 'phone number'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    phoneField.clear();
  }
}
