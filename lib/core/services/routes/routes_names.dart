class RoutesNames {
  static String get baseUrl => '/';

  static CoreRoutes core = CoreRoutes();
  static AuthRoutes auth = AuthRoutes();
  static HomeRoutes home = HomeRoutes();
  static SearchRoutes search = SearchRoutes();
  static NotificationRoutes notification = NotificationRoutes();
  static ProfileRoutes profile = ProfileRoutes();
  static ShopRoutes shop = ShopRoutes();
  static ProductRoutes product = ProductRoutes();
  static ReelsRoutes reels = ReelsRoutes();
  static SettingsRoutes settings = SettingsRoutes();
  static WishListRoutes wishList = WishListRoutes();
  static CompareRoutes compare = CompareRoutes();
  static CartRoutes cart = CartRoutes();
}

class CoreRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get splash => baseUrl;

  String get logger => '${baseUrl}logger';
  String get imageViwer => '${baseUrl}image-viewer';
}

class AuthRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get login => '${baseUrl}login';

  String get register => '${baseUrl}register';

  String get forgetPassword => '${baseUrl}forget-password';

  String get otp => '${baseUrl}otp';
}

class HomeRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get homeMain => '${baseUrl}home';

  String get favorit => '${baseUrl}favorit';

  String get goldLive => '${baseUrl}gold-live';
}

class SearchRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get preSearch => '${baseUrl}pre-search';

  String get search => '${baseUrl}search';

  String get categoryDetails => '${baseUrl}category-details';
}

class NotificationRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get notifications => '${baseUrl}notifications';
}

class ShopRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get shopDetails => '${baseUrl}shop-details';

  String get shopsList => '${baseUrl}shops-list';
}

class ProductRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get productDetails => '${baseUrl}product-details';
}

class ReelsRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get timeline => '${baseUrl}timeline';

  String get reelsMain => '${baseUrl}reels';
}

class ProfileRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get profileMain => '${baseUrl}profile';

  String get editProfile => '${baseUrl}edit-profile';

  String get addresses => '${baseUrl}addresses';
  String get paymentMethods => '${baseUrl}payment-methods';
  String get addAddress => '${baseUrl}add-address';
  String get addPaymentMethod => '${baseUrl}add-payment-method';

  String get changePassword => '${baseUrl}change-password';
  String get contactUs => '${baseUrl}contact-us';
  String get privacyPolicy => '${baseUrl}privacy-policy';
  String get whoAreWe => '${baseUrl}who-are-we';
  String get termsAndConditions => '${baseUrl}terms-and-conditions';
}

class SettingsRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get settingsMain => '${baseUrl}settings';
  String get appLock => '${baseUrl}app-lock';
}

class WishListRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get wishListMain => '${baseUrl}wish-list';
}

class CompareRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get compareMain => '${baseUrl}compare';

  String get categoryCompare => '${baseUrl}category-compare';

  String get tableCompare => '${baseUrl}table-compare';
}

class CartRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get cartMain => '${baseUrl}cart';

  String get checkout => '${baseUrl}checkout';
}
