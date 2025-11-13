import 'package:al_muslim/modules/auth/presentation/screens/sn_otp.dart';
import 'package:al_muslim/modules/cart/presentation/screens/sn_cart.dart';
import 'package:al_muslim/modules/cart/presentation/screens/sn_checkout.dart';
import 'package:al_muslim/modules/compare/presentation/screens/sn_category_compare.dart';
import 'package:al_muslim/modules/compare/presentation/screens/sn_compare_main.dart';
import 'package:al_muslim/modules/compare/presentation/screens/sn_table_compare.dart';
import 'package:al_muslim/modules/core/presentation/screens/sn_splash.dart';
import 'package:al_muslim/modules/notification/presentation/screens/sn_notification.dart';
import 'package:al_muslim/modules/products/data/models/m_product.dart';
import 'package:al_muslim/modules/products/presentation/screens/sn_product_details.dart';
import 'package:al_muslim/modules/profile/presentation/screens/sn_profile.dart';
import 'package:al_muslim/modules/profile/presentation/screens/sn_addresses.dart';
import 'package:al_muslim/modules/profile/presentation/screens/sn_payment_methods.dart';
import 'package:al_muslim/modules/profile/presentation/screens/sn_add_address.dart';
import 'package:al_muslim/modules/profile/presentation/screens/sn_add_payment_method.dart';
import 'package:al_muslim/modules/reels/presentation/screens/sn_reels.dart';
import 'package:al_muslim/modules/categories/presentation/screens/sn_category_details.dart';
import 'package:al_muslim/modules/reels/presentation/screens/sn_time_line.dart';
import 'package:al_muslim/modules/search/presentation/screens/sn_pre_search.dart';
import 'package:al_muslim/modules/search/presentation/screens/sn_search.dart';
import 'package:al_muslim/modules/settings/presentation/screens/sn_settings.dart';
import 'package:al_muslim/modules/settings/presentation/screens/sn_app_lock.dart';
import 'package:al_muslim/modules/wishlist/presentation/screens/sn_wishlist.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/routes/guards/guards_ensuer_keyboard.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/auth/presentation/screens/sn_login.dart';
import 'package:al_muslim/modules/auth/presentation/screens/sn_register.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// [Routes] is a class that contains all the routes in the app.
class Routes {
  /// [buildRoutes] is a function that build all the routes in the app.
  static void buildRoutes(RouteManager r) {
    /// ================= Core ================= ///
    r.child(
      RoutesNames.core.splash,
      transition: TransitionType.fadeIn,
      child: (_) => const SNSplash(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Auth ================= ///
    r.child(
      RoutesNames.auth.login,
      transition: TransitionType.fadeIn,
      child: (_) => const SNLogin(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.auth.register,
      transition: TransitionType.fadeIn,
      child: (_) => const SNRegister(),
      guards: [EnsureKeyboardDismissed()],
    );
    // r.child(
    //   RoutesNames.auth.forgetPassword,
    //   transition: TransitionType.fadeIn,
    //   child: (_) => const SNForgetPasswordFlow(),
    //   guards: [
    //     EnsureKeyboardDismissed(),
    //   ],
    // );

    r.child(
      RoutesNames.auth.otp,
      transition: TransitionType.fadeIn,
      child: (_) => const SNOtp(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Profile ================= ///
    r.child(
      RoutesNames.profile.profileMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SNProfile(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.profile.addresses,
      transition: TransitionType.fadeIn,
      child: (_) => const SNAddresses(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.profile.paymentMethods,
      transition: TransitionType.fadeIn,
      child: (_) => const SNPaymentMethods(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.profile.addAddress,
      transition: TransitionType.fadeIn,
      child: (_) => const SNAddAddress(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.profile.addPaymentMethod,
      transition: TransitionType.fadeIn,
      child: (_) => const SNAddPaymentMethod(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Logger ================= ///
    r.child(
      RoutesNames.core.logger,
      child: (context) => TalkerScreen(talker: Constants.talker),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Reels ================= ///
    r.child(
      RoutesNames.reels.reelsMain,
      transition: TransitionType.fadeIn,
      child: (_) {
        String? productId;
        MProduct? product;
        final args = Modular.args.data;
        if (args is Map<String, dynamic>) {
          final dynamic idValue = args['productId'];
          productId = idValue?.toString();
          final dynamic productValue = args['product'];
          if (productValue is MProduct) {
            product = productValue;
          }
        } else if (args is String) {
          productId = args;
        }
        return SNReels(productId: productId, product: product);
      },
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.reels.timeline,
      transition: TransitionType.fadeIn,
      child: (_) => const SNTimeline(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Product ================= ///
    r.child(
      RoutesNames.product.productDetails,
      transition: TransitionType.fadeIn,
      child: (_) {
        final productId = Modular.args.data as String?;
        return SNProductDetails(productId: productId);
      },
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Wishlist ================= ///
    r.child(
      RoutesNames.wishList.wishListMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SNWishlist(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Compare ================= ///
    r.child(
      RoutesNames.compare.compareMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SNCompareMain(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.compare.categoryCompare,
      transition: TransitionType.fadeIn,
      child: (_) => const SNCategoryCompare(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.compare.tableCompare,
      transition: TransitionType.fadeIn,
      child: (_) => const SNTableCompare(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Search ================= ///
    r.child(
      RoutesNames.search.search,
      transition: TransitionType.fadeIn,
      child: (_) => const SNSearch(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.search.preSearch,
      transition: TransitionType.fadeIn,
      child: (_) => const SNPreSearch(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.search.categoryDetails,
      transition: TransitionType.fadeIn,
      child: (_) => const SNCategoryDetails(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Settings ================= ///
    r.child(
      RoutesNames.settings.settingsMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SNSettings(),
      guards: [EnsureKeyboardDismissed()],
    );
    r.child(
      RoutesNames.settings.appLock,
      transition: TransitionType.fadeIn,
      child: (_) => const SNAppLock(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Notification ================= ///
    r.child(
      RoutesNames.notification.notifications,
      transition: TransitionType.fadeIn,
      child: (_) => const SNNotification(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Cart ================= ///
    r.child(
      RoutesNames.cart.cartMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SNCart(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.cart.checkout,
      transition: TransitionType.fadeIn,
      child: (_) => const SNCheckout(),
      guards: [EnsureKeyboardDismissed()],
    );
  }
}
