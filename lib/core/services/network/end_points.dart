import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/utils/enums.dart';

class APIEndPoints {
  static const String baseApiUrl = "https://bnb-server-n434.onrender.com/api/v1";
  static const String baseDeveUrl = "https://bnb-server-n434.onrender.com/api/v1";

  static String get baseUrl {
    return switch (Constants.apiState) {
      APIState.prod => baseApiUrl,
      APIState.dev => baseDeveUrl,
    };
  }

  static Auth auth = Auth();
  static Addresses addresses = Addresses();
  static PaymentMethods paymentMethods = PaymentMethods();
  static Profile profile = Profile();
  static Categories categories = Categories();
  static Products products = Products();
  static Reels reels = Reels();
  static Cart cart = Cart();
  static Orders orders = Orders();
}

class Auth {
  String baseAuth = '${APIEndPoints.baseUrl}/auth';

  String get login => "$baseAuth/login";

  String get register => "$baseAuth/register";
  String get verifyOtp => "$baseAuth/verify-otp";

  String get refreshToken => "$baseAuth/refresh";
  String get logout => "$baseAuth/logout";
}

class Addresses {
  String baseAuth = '${APIEndPoints.baseUrl}/addresses';

  String get getAllAddresses => "$baseAuth/";
  String get createAddress => "$baseAuth/";

  String getAddress(String id) => "$baseAuth/$id";

  String updateAddress(String id) => "$baseAuth/$id";
  String deleteAddress(String id) => "$baseAuth/$id";

  String setDefaultAddress(String id) => "$baseAuth/$id/set-default";
}

class PaymentMethods {
  String baseAuth = '${APIEndPoints.baseUrl}/payment-methods';

  String get getAllPaymentMethods => "$baseAuth/";

  String get createPaymentMethod => "$baseAuth/";

  String getPaymentMethod(String id) => "$baseAuth/$id";
  String updatePaymentMethod(String id) => "$baseAuth/$id";
  String deletePaymentMethod(String id) => "$baseAuth/$id";

  String setDefaultPaymentMethod(String id) => "$baseAuth/$id/set-default";
}

class Profile {
  String baseProfile = '${APIEndPoints.baseUrl}/users';

  String get me => "$baseProfile/me";
  String get updateUser => "$baseProfile/me";
}

class Categories {
  String baseCategories = '${APIEndPoints.baseUrl}/categories';

  String get categories => baseCategories;
  String get root => '$baseCategories/root';
  String get hierarchy => '$baseCategories/hierarchy';
}

class Products {
  String baseProducts = '${APIEndPoints.baseUrl}/public/products/public/products';

  String get products => baseProducts;
  String get groupedByCategory => '$baseProducts/grouped-by-category';
  String categoryProducts(String categoryId) => '$baseProducts/category/$categoryId';
  String product(String productId) => '$baseProducts/$productId';
}

class Reels {
  String get _baseSellerProducts => '${APIEndPoints.baseUrl}/seller/products';

  String productReels(String productId) => '$_baseSellerProducts/$productId/reels';
}

class Cart {
  String baseCart = '${APIEndPoints.baseUrl}/public/cart';

  String fetchCart(String? cartToken) => '$baseCart/${cartToken != null ? '?cart_token=$cartToken' : ''}';
  String clearCart(String cartToken) => '$baseCart/?cart_token=$cartToken';
  String get items => '$baseCart/items';
  String cartItem(String itemId, String cartToken) => '$baseCart/items/$itemId?cart_token=$cartToken';
}

class Orders {
  String baseOrders = '${APIEndPoints.baseUrl}/public/orders';

  String submitFromCart(String shippingAddressId) =>
      '$baseOrders/from-cart?shipping_address_id=$shippingAddressId&delivery_method=standard';
}
