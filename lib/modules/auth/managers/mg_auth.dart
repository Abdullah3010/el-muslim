import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/forms/f_login.dart';
import 'package:al_muslim/core/services/forms/f_otp.dart';
import 'package:al_muslim/core/services/forms/f_register.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/utils/helper/app_alert.dart';
import 'package:al_muslim/modules/auth/data/models/m_user.dart';
import 'package:al_muslim/modules/auth/data/params/params_login.dart';
import 'package:al_muslim/modules/auth/data/params/params_register.dart';
import 'package:al_muslim/modules/auth/data/params/params_send_otp.dart';
import 'package:al_muslim/modules/auth/data/params/params_verify_otp.dart';
import 'package:al_muslim/modules/auth/sources/local/local_auth.dart';
import 'package:al_muslim/modules/auth/sources/remote/remotr_auth.dart';
import 'package:al_muslim/modules/cart/managers/mg_cart.dart';
import 'package:al_muslim/modules/cart/sources/local/local_cart.dart';
import 'package:al_muslim/modules/cart/sources/local/local_cart_items.dart';
import 'package:al_muslim/modules/categories/managers/mg_categories.dart';
import 'package:al_muslim/modules/categories/sources/local/local_category.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:al_muslim/modules/products/sources/local/local_product.dart';
import 'package:al_muslim/modules/profile/managers/mg_profile.dart';
import 'package:al_muslim/modules/profile/sources/local/local_addresses.dart';
import 'package:al_muslim/modules/profile/sources/local/local_payment_methods.dart';
import 'package:al_muslim/modules/wishlist/manager/mg_wishlist.dart';
import 'package:al_muslim/modules/wishlist/sources/local/local_wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MgAuth extends ChangeNotifier {
  final RemoteAuth remoteAuth = RemoteAuth();

  MUser? activeUser;
  String afterLoginRoute = RoutesNames.profile.profileMain;

  /// [Login]
  FLogin fLogin = FLogin();

  Future<void> login() async {
    try {
      if (fLogin.validate()) {
        activeUser = await remoteAuth.login(
          ParamsLogin(phoneNumber: fLogin.phoneField.controller.text, password: '12345678'),
        );
        if (activeUser != null) {
          fLogin.clear();
          // if (afterLoginRoute.isNotEmpty) {
          //   Modular.to.navigate(afterLoginRoute);
          //   afterLoginRoute = RoutesNames.profile.profileMain;
          // }
          Modular.get<MgCore>().setNavBarIndex(0);
          notifyListeners();
        } else {
          // AppAlert.error('Invalid email or password'.translated);
        }
      }
    } catch (e) {
      print(" ====>>> Login error: $e");
    }
  }

  /// [Register]
  FRegister fRegister = FRegister();

  Future<void> register() async {
    if (fRegister.validate()) {
      bool result = await remoteAuth.register(
        ParamsRegister(
          username: fRegister.phoneField.toApiBody().replaceAll('+', ''),
          phoneNumber: fRegister.phoneField.toApiBody(),
          password: '12345678',
          firstName: fRegister.usernameField.controller.text.split(' ').first,
          lastName: fRegister.usernameField.controller.text.split(' ').last,
          email: fRegister.emailField.controller.text,
        ),
      );
      if (result) {
        Modular.to.pushNamed(RoutesNames.auth.otp);

        notifyListeners();
      } else {
        // AppAlert.error('Email already exists'.translated);
      }
    }
  }

  bool isVerifingOtp = false;
  FOtp fOtp = FOtp();
  Future<void> verifyOtp() async {
    if (fOtp.pinCodeField.controller.text.isNotEmpty && isVerifingOtp == false) {
      isVerifingOtp = true;
      notifyListeners();
      bool result = await remoteAuth.verifyOtp(
        ParamsVerifyOtp(
          phoneNumber: fRegister.phoneField.toApiBody().replaceAll('+', ''),
          code: fOtp.pinCodeField.controller.text,
        ),
      );
      if (result) {
        fRegister.clear();
        fOtp.clear();
        activeUser = remoteAuth.getActiveUser();
        Modular.get<MgCore>().setNavBarIndex(0);
        notifyListeners();
      } else {
        AppAlert.error('Invalid OTP'.translated);
      }
      isVerifingOtp = false;
      notifyListeners();
    }
  }

  /// [Get Active User]
  MUser? getActiveUser() {
    activeUser = remoteAuth.getActiveUser();
    return activeUser;
  }

  // hasActiveUser getter
  bool get hasActiveUser => remoteAuth.getActiveUser() != null;

  /// [Logout]
  Future<void> logout() async {
    bool result = await remoteAuth.logout();
    if (result) {
      await _clearLocalDataOnLogout();
      activeUser = null;
      Modular.to.navigate(RoutesNames.auth.login);
    } else {
      // AppAlert.error('Failed to logout'.translated);
    }
  }

  /// [Refresh Token]
  Future<bool> refreshToken() async {
    try {
      bool result = await remoteAuth.refreshToken(ParamsRefreshToken(refreshToken: activeUser?.refreshToken ?? ''));
      if (result) {
        notifyListeners();
      }
      return result;
    } catch (e) {
      print(" ====>>> Refresh token error: $e");
    }
    return false;
  }

  Future<void> _clearLocalDataOnLogout() async {
    try {
      await Future.wait<dynamic>([
        LocalAuth().clear(),
        LocalAddresses().clear(),
        LocalPaymentMethods().clear(),
        LocalCart().clear(),
        LocalCartItems().clear(),
        LocalWishlist().clear(),
        LocalCategory().clear(),
        LocalProduct().clear(),
      ]);
    } catch (_) {}

    try {
      await Modular.get<MgCategories>().clearCachedData();
    } catch (_) {}

    try {
      await Modular.get<MgCart>().resetForLogout();
    } catch (_) {}

    try {
      await Modular.get<MgWishlist>().clearWishlist();
    } catch (_) {}

    try {
      await Modular.get<MgProfile>().resetForLogout();
    } catch (_) {}
  }
}
