import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_dropdown_field.dart';
import 'package:al_muslim/core/widgets/forms/w_email_field.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FCreatePaymentMethod extends BaseFormController {
  late WDropdownField<String> typeField;
  late WTextField billingNameField;
  late WTextField cardNumberField;
  late WTextField expiryDateField;
  late WTextField cvvField;
  late WEmailField billingEmailField;
  late WPhoneField billingPhoneField;
  late WTextField providerTokenField;

  bool isDefault = false;

  @override
  void init() {
    typeField = WDropdownField<String>(items: const ['wallet', 'card'], hint: 'Type'.translated);
    // Default to wallet
    typeField.controller.text = 'wallet';
    billingNameField = WTextField(hint: 'Billing Name'.translated);
    cardNumberField = WTextField(hint: 'Card Number'.translated);
    expiryDateField = WTextField(hint: 'Expiry Date (MM/YY)'.translated);
    cvvField = WTextField(hint: 'CVV'.translated);
    billingEmailField = WEmailField(hint: 'Billing Email'.translated);
    billingPhoneField = WPhoneField(hint: 'Billing Phone'.translated, isRequired: true);
    providerTokenField = WTextField(hint: 'Provider Token'.translated, isRequired: false);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    typeField.clear();
    billingNameField.clear();
    cardNumberField.clear();
    expiryDateField.clear();
    cvvField.clear();
    billingEmailField.clear();
    billingPhoneField.clear();
    providerTokenField.clear();
    isDefault = false;
  }
}
