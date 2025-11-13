import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/base_form_controller.dart';
import 'package:al_muslim/core/widgets/forms/w_phone_field.dart';
import 'package:al_muslim/core/widgets/forms/w_dropdown_field.dart';
import 'package:al_muslim/core/widgets/forms/w_text_field.dart';

class FCreateAddress extends BaseFormController {
  late WTextField labelField;
  late WTextField contactNameField;
  late WPhoneField contactPhoneField;
  late WTextField addressLine1Field;
  late WTextField addressLine2Field;
  late WDropdownField<String> cityField;
  late WDropdownField<String> stateField;
  late WTextField postalCodeField;
  late WTextField countryField;
  late WTextField countryCodeField;

  // Switch field stored as state in controller
  bool isDefault = false;

  final Map<String, List<String>> _citiesByState = const {
    'Damascus': ['Barzeh', 'Midan', 'Qaboun', 'Mazzah'],
    'Aleppo': ['Al-Jamiliyah', 'Saif Al-Dawla', 'Aziziyah'],
    'Homs': ['Al-Hamidiya', 'Inshaat', 'Khaldiya'],
    'Hama': ['Al-Sabouniya', 'Al-Arbaeen', 'Al-Bayadiyah'],
    'Latakia': ['Al-Amerkan', 'Mashroua', 'Al-Slaibeh'],
    'Tartus': ['Al-Meena', 'Al-Karama', 'Safita'],
    'Raqqa': ['Tabqa', 'Kasrat', 'Mansoura'],
    'Deir ez-Zor': ['Al-Joura', 'Al-Qusour', 'Al-Hamidiya'],
    'Hasakah': ['Al-Nashwa', 'Gweiran', 'Al-Aziziya'],
    'Idlib': ['Maarrat Misrin', 'Binnish', 'Saraqib'],
    'Daraa': ['Al-Sadd', 'Al-Matar', 'Al-Mahatta'],
    'Quneitra': ['Khan Arnabah', 'Al-Baath', 'Jaba'],
    'As-Suwayda': ['Shahba', 'Salkhad', 'Qanawat'],
    'Rif Dimashq': ['Douma', 'Harasta', 'Jaramana', 'Darayya'],
  };

  @override
  void init() {
    labelField = WTextField(hint: 'Label'.translated);
    contactNameField = WTextField(hint: 'Contact Name'.translated);
    contactPhoneField = WPhoneField(hint: 'Contact Phone'.translated, isRequired: true);
    addressLine1Field = WTextField(hint: 'Address Line 1'.translated);
    addressLine2Field = WTextField(hint: 'Address Line 2'.translated, isRequired: false);
    stateField = WDropdownField<String>(
      items: const [
        'Damascus',
        'Rif Dimashq',
        'Aleppo',
        'Homs',
        'Hama',
        'Latakia',
        'Tartus',
        'Raqqa',
        'Deir ez-Zor',
        'Hasakah',
        'Idlib',
        'Daraa',
        'Quneitra',
        'As-Suwayda',
      ],
      hint: 'State'.translated,
    );
    cityField = WDropdownField<String>(items: const [], hint: 'City'.translated);
    postalCodeField = WTextField(hint: 'Postal Code'.translated, isRequired: false);
    countryField = WTextField(hint: 'Country'.translated);
    countryCodeField = WTextField(hint: 'Country Code'.translated);
  }

  @override
  bool validate() {
    return formKey.currentState!.validate();
  }

  @override
  void clear() {
    labelField.clear();
    contactNameField.clear();
    contactPhoneField.clear();
    addressLine1Field.clear();
    addressLine2Field.clear();
    cityField.clear();
    stateField.clear();
    postalCodeField.clear();
    countryField.clear();
    countryCodeField.clear();
    isDefault = false;
  }

  void updateCitiesForState(String state) {
    cityField.items = _citiesByState[state] ?? const [];
    cityField.controller.clear();
  }
}
