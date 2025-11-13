import 'package:flutter/material.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/widgets/w_app_bottom_sheet.dart';
import 'package:al_muslim/core/widgets/w_app_dialog.dart';

class AppDialogs {
  static void showBottomSheet({
    required void Function() onMainAction,
    required Widget child,
    required BuildContext context,
    double? maxHeight,
    double? maxWidth,
    double? buttonWidth,
    String? mainActionTitle,
    String? titleText,
    Widget? titleWidget,
    bool? removeBack,
    bool? isDismissible,
    bool? withConstraints,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: true,
      isDismissible: isDismissible ?? true,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: WAppBottomSheet(
            buttonWidth: buttonWidth,
            mainActionTitle: mainActionTitle,
            onMainAction: onMainAction,
            titleText: titleText,
            titleWidget: titleWidget,
            removeBack: removeBack,
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            withConstraints: withConstraints,
            child: child,
          ),
        );
      },
    );
  }

  // static void showNotLoggedInDialog(BuildContext context) {
  //   AppDialogs.showBottomSheet(
  //     context: context,
  //     titleText: 'You must login first'.translated,
  //     // mainActionTitle: 'Registration'.translated,
  //     maxHeight: context.height * 0.34,
  //     onMainAction: () {},
  //     child: Column(
  //       children: [
  //         WAppButton(
  //           title: 'Sign In'.translated,
  //           height: 48,
  //           width: context.width * 0.8,
  //           onTap: () {
  //             Modular.to.pop();
  //             Modular.to.pushNamed(RoutesNames.auth.login);
  //           },
  //         ),
  //         20.heightBox,
  //         WAppButton(
  //           title: 'Registration'.translated,
  //           height: 48,
  //           width: context.width * 0.8,
  //           color: context.theme.colorScheme.white,
  //           style: context.textTheme.button.copyWith(
  //             color: context.theme.colorScheme.primaryOrange,
  //           ),
  //           onTap: () {
  //             Modular.to.pop();
  //             Modular.to.pushNamed(RoutesNames.auth.register);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  static void dialog({
    required String mainActionTitle,
    required String secondActionTitle,
    required void Function() onMainAction,
    required void Function() onSecondAction,
    String? titleText,
    String? description,
    bool? withExit,
    bool? dismissible,
    double? radius,
    EdgeInsetsGeometry? padding,
    Color? mainActionColor,
    Color? secondaryBorderColor,
    Color? secondaryTextColor,
    TextStyle? titleStyle,
  }) {
    showDialog(
      context: Constants.navigatorKey.currentContext!,
      barrierDismissible: dismissible ?? !(withExit ?? false),
      builder: (context) {
        return WAppDialog(
          mainActionTitle: mainActionTitle,
          secondActionTitle: secondActionTitle,
          onMainAction: onMainAction,
          onSecondAction: onSecondAction,
          titleText: titleText,
          description: description,
          radius: radius,
          withExit: withExit ?? true,
          padding: padding,
          mainActionColor: mainActionColor,
          secondaryBorderColor: secondaryBorderColor,
          secondaryTextColor: secondaryTextColor,
          titleStyle: titleStyle,
        );
      },
    );
  }
}
