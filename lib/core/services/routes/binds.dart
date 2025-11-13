import 'package:al_muslim/modules/cart/managers/mg_cart.dart';
import 'package:al_muslim/modules/cart/managers/mg_checkout.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/modules/categories/managers/mg_categories.dart';
import 'package:al_muslim/modules/products/managers/mg_products.dart';
import 'package:al_muslim/modules/profile/managers/mg_profile.dart';
import 'package:al_muslim/modules/wishlist/manager/mg_wishlist.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
import 'package:al_muslim/modules/reels/managers/mg_reels.dart';
import 'package:al_muslim/modules/reels/managers/mg_time_line.dart';
import 'package:al_muslim/modules/settings/managers/mg_settings.dart';

/// [Binds] is a class that contains all the dependencies that will be used in the app.
class Binds {
  /// [binds] is a function that bind all dependencies.
  static void binds(Injector i) {
    i.addSingleton(BoxAppConfig.new);
    i.addSingleton(DSAppConfig.new);

    /// ================= Auth ================= ///
    i.addLazySingleton(MgAuth.new);

    /// ================= Profile ================= ///
    i.addLazySingleton(MgProfile.new);

    /// ================= Cart ================= ///
    i.addLazySingleton(MgCart.new);
    i.addLazySingleton(MgCheckout.new);

    /// ================= Categories ================= ///
    i.addLazySingleton(MgCategories.new);

    /// ================= Products ================= ///
    i.addLazySingleton(MgProducts.new);

    /// ================= Reels ================= ///
    i.addLazySingleton(MgReels.new);
    i.addLazySingleton(MgTimeLine.new);

    /// ================= Settings ================= ///
    i.addLazySingleton(MgSettings.new);

    /// ================= Wishlist ================= ///
    i.addLazySingleton(MgWishlist.new);

    /// ================= Core ================= ///
    i.addLazySingleton(MgCore.new);
  }
}
