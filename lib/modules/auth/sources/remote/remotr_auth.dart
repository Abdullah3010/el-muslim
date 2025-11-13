import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/modules/auth/data/params/params_verify_otp.dart';
import 'package:dio/dio.dart';
import 'package:al_muslim/core/services/network/base_dio.dart';
import 'package:al_muslim/core/services/network/end_points.dart';
import 'package:al_muslim/core/utils/helper/app_alert.dart';
import 'package:al_muslim/core/utils/helper/error_helper.dart';
import 'package:al_muslim/modules/auth/data/models/m_user.dart';
import 'package:al_muslim/modules/auth/data/params/params_login.dart';
import 'package:al_muslim/modules/auth/data/params/params_register.dart';
import 'package:al_muslim/modules/auth/data/params/params_send_otp.dart';
import 'package:al_muslim/modules/auth/sources/local/local_auth.dart';

class RemoteAuth {
  final BaseDio dio = BaseDio();
  final LocalAuth localAuth = LocalAuth();

  Future<MUser?> login(ParamsLogin params) async {
    try {
      final Response<dynamic> response = await dio.post(APIEndPoints.auth.login, data: params.toJson());
      if (response.statusCode == 200) {
        MUser user = MUser.fromJson(response.data);
        await localAuth.createUpdate(user);
        return user;
      }
    } catch (e, st) {
      ErrorHelper.printDebugError(name: 'RemoteAuth.login', error: e, stackTrace: st);
    }
    return null;
  }

  Future<bool> register(ParamsRegister params) async {
    try {
      final Response<dynamic> response = await dio.post(APIEndPoints.auth.register, data: params.toJson());
      if (Constants.successStatusCodes.contains(response.statusCode ?? 0)) {
        print(response.data);
        return true;
      } else {
        if (response.data['message'] != null && response.data['message'] != '') {
          AppAlert.error(response.data['message'].toString());
          return false;
        }
      }
    } catch (e, st) {
      ErrorHelper.printDebugError(name: 'RemoteAuth.register', error: e, stackTrace: st);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      final Response<dynamic> response = await dio.post(APIEndPoints.auth.logout);

      if (response.statusCode == 200) {
        print(response.data);
        await localAuth.clear();
        return true;
      } else {
        if (response.data['message'] != null && response.data['message'] != '') {
          AppAlert.error(response.data['message'].toString());
          return false;
        }
      }
      return true;
    } catch (e, st) {
      ErrorHelper.printDebugError(name: 'RemoteAuth.logout', error: e, stackTrace: st);
    }
    return false;
  }

  MUser? getActiveUser() {
    return localAuth.get();
  }

  Future<bool> verifyOtp(ParamsVerifyOtp params) async {
    try {
      final Response<dynamic> response = await dio.post(APIEndPoints.auth.verifyOtp, data: params.toJson());
      if (response.statusCode == 200) {
        MUser user = MUser.fromJson(response.data);
        await localAuth.createUpdate(user);
        return true;
      }
    } catch (e, st) {
      ErrorHelper.printDebugError(name: 'RemoteAuth.verifyOtp', error: e, stackTrace: st);
    }
    return false;
  }

  Future<bool> refreshToken(ParamsRefreshToken params) async {
    try {
      final Response<dynamic> response = await dio.post(APIEndPoints.auth.refreshToken, data: params.toJson());
      if (response.statusCode == 200) {
        MUser user = MUser.fromJson(response.data);
        MUser? currentUser = localAuth.get();
        currentUser?.accessToken = user.accessToken;
        currentUser?.refreshToken = user.refreshToken;
        await localAuth.createUpdate(user);
        return true;
      }
    } catch (e, st) {
      ErrorHelper.printDebugError(name: 'RemoteAuth.refresh', error: e, stackTrace: st);
    }
    return false;
  }
}
