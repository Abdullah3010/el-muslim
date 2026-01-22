int getPrayerMethodByCountryCode(String? code) {
  if (code == null || code.trim().isEmpty) {
    return 3;
  }

  switch (code.trim().toUpperCase()) {
    case 'EG':
      return 5;
    case 'SA':
      return 4;
    case 'AE':
      return 16;
    case 'QA':
      return 10;
    case 'KW':
      return 9;
    case 'BH':
    case 'OM':
      return 8;
    case 'TN':
      return 18;
    case 'DZ':
      return 19;
    case 'MA':
      return 21;
    case 'JO':
      return 23;
    case 'TR':
      return 13;
    case 'RU':
      return 14;
    case 'IR':
      return 7;
    case 'PK':
    case 'IN':
    case 'BD':
      return 1;
    case 'SG':
      return 11;
    case 'MY':
      return 17;
    case 'ID':
      return 20;
    case 'FR':
      return 12;
    case 'PT':
      return 22;
    default:
      return 3;
  }
}
