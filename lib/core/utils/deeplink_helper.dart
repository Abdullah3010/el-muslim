import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';

/// Helper class for handling deeplink navigation throughout the app
class DeepLinkHelper {
  /// Navigate to shop details with shopId
  /// Example: DeepLinkHelper.navigateToShopDetails('123')
  /// This creates a deeplink: /shop-details?shopId=123
  static Future<void> navigateToShopDetails(String shopId) async {
    await Modular.to.pushNamed('${RoutesNames.shop.shopDetails}?shopId=$shopId');
  }

  /// Navigate to shop details and replace current route
  static Future<void> navigateToShopDetailsAndReplace(String shopId) async {
    await Modular.to.pushReplacementNamed('${RoutesNames.shop.shopDetails}?shopId=$shopId');
  }

  /// Get the shop details URL for sharing or external use
  /// Example: DeepLinkHelper.getShopDetailsUrl('123')
  /// Returns: "/shop-details?shopId=123"
  static String getShopDetailsUrl(String shopId) {
    return '${RoutesNames.shop.shopDetails}?shopId=$shopId';
  }

  /// Parse shopId from a deeplink URL
  /// Example: DeepLinkHelper.parseShopIdFromUrl('/shop-details?shopId=123')
  /// Returns: '123'
  static String? parseShopIdFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['shopId'];
  }

  /// Check if a URL is a shop details deeplink
  static bool isShopDetailsUrl(String url) {
    final uri = Uri.parse(url);
    return uri.path == RoutesNames.shop.shopDetails && uri.queryParameters.containsKey('shopId');
  }
}
