import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_multi_line_field.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FAddress extends BaseFormController {
  late WTextField nameField;
  late WPhoneField phoneField;
  late WTextField areaField;
  late WTextField cityField;
  late WMultiLineField streetAddressField;
  late WTextField buildingNumberField;
  late WTextField landmarkField;
  late WTextField zipCodeField;

  @override
  void init() {
    nameField = WTextField(hint: 'Address Name'.translated);
    phoneField = WPhoneField(hint: 'Phone Number'.translated);
    areaField = WTextField(hint: 'Area'.translated);
    cityField = WTextField(hint: 'City'.translated);
    streetAddressField = WMultiLineField(hint: 'Street Address'.translated, minLines: 2, maxLines: 3);
    buildingNumberField = WTextField(hint: 'Building Number'.translated);
    landmarkField = WTextField(hint: 'Landmark'.translated);
    zipCodeField = WTextField(hint: 'Zip Code'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    nameField.clear();
    phoneField.clear();
    areaField.clear();
    cityField.clear();
    streetAddressField.clear();
    buildingNumberField.clear();
    landmarkField.clear();
    zipCodeField.clear();
  }
}
