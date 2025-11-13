import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FSearch extends BaseFormController {
  late WTextField searchField;

  @override
  void init() {
    searchField = WTextField(isRequired: false, hint: 'search here'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    searchField.clear();
  }
}
