import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:provider/provider.dart';

class SNLogin extends StatefulWidget {
  const SNLogin({super.key});

  @override
  State<SNLogin> createState() => _SNLoginState();
}

class _SNLoginState extends State<SNLogin> {
  MgAuth manager = Modular.get<MgAuth>();

  @override
  void initState() {
    super.initState();
    manager.fLogin.init();
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
              await manager.login();
            },
          ),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have an account yet?'.translated,
                style: context.theme.textTheme.black16w400Arial.copyWith(
                  color: context.theme.colorScheme.black.withValues(alpha: 0.7),
                ),
              ),
              5.widthBox,
              InkWell(
                onTap: () {
                  Modular.to.pushReplacementNamed(RoutesNames.auth.register);
                },
                child: Text('Sign Up now'.translated, style: context.theme.textTheme.black16w700Arial),
              ),
            ],
          ),
          30.heightBox,
        ],
      ),
      body: Consumer<MgAuth>(
        builder: (context, manager, child) {
          return Form(
            key: manager.fLogin.formKey,
            child: ListView(
              children: [
                80.heightBox,
                SvgPicture.asset(Assets.icons.newIcons.logo.path, height: 117.h, width: 291.w),
                128.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign In'.translated, style: context.textTheme.black24w700Arial),
                        Text('Enter Your Phone Number:'.translated, style: context.textTheme.black18w700Arial),
                      ],
                    ),
                  ],
                ),
                16.heightBox,
                manager.fLogin.phoneField.buildField(context),
                200.heightBox,
              ],
            ),
          );
        },
      ),
    );
  }
}
