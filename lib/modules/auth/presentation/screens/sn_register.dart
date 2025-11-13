import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SNRegister extends StatefulWidget {
  const SNRegister({super.key});

  @override
  State<SNRegister> createState() => _SNRegisterState();
}

class _SNRegisterState extends State<SNRegister> {
  MgAuth manager = Modular.get<MgAuth>();

  @override
  void initState() {
    super.initState();
    manager.fRegister.init();
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WAppButton(
            title: 'confirm'.translated,
            onTap: () async {
              await manager.register();
            },
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              25.heightBox,
              Text(
                'already have an account?'.translated,
                style: context.theme.textTheme.black16w400Arial.copyWith(
                  color: context.theme.colorScheme.black.withValues(alpha: 0.7),
                ),
              ),
              5.widthBox,
              InkWell(
                onTap: () {
                  Modular.to.pushReplacementNamed(RoutesNames.auth.login);
                },
                child: Text('Sign In here'.translated, style: context.theme.textTheme.black16w700Arial),
              ),
            ],
          ),
          30.heightBox,
        ],
      ),
      body: Form(
        key: manager.fRegister.formKey,
        child: ListView(
          children: [
            SvgPicture.asset(Assets.icons.newIcons.registerPlacholder.path, height: 378.h, width: 378.w),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Sign Up'.translated, style: context.textTheme.black24w700Arial)],
            ),
            12.heightBox,
            manager.fRegister.usernameField.buildField(context),
            24.heightBox,
            manager.fRegister.phoneField.buildField(context),
            25.heightBox,
            manager.fRegister.emailField.buildField(context),
            // InkWell(
            //   onTap: () {
            //     manager.forgetPasswordStep.value = 1;
            //     Modular.to.pushNamed(RoutesNames.auth.forgetPassword);
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Forgot Password'.translated,
            //         style: context.theme.textTheme.blue12w400.copyWith(
            //           decoration: TextDecoration.underline,
            //           decorationColor: context.theme.colorScheme.darkPrimary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            200.heightBox,
          ],
        ),
      ),
    );
  }
}
