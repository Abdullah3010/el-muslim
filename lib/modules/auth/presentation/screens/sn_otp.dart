import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/config/params/custom_pin_code_options.dart';
import 'package:al_muslim/core/config/params/params_custom_input.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
import 'package:provider/provider.dart';

class SNOtp extends StatefulWidget {
  const SNOtp({super.key});

  @override
  State<SNOtp> createState() => _SNOtpState();
}

class _SNOtpState extends State<SNOtp> {
  MgAuth manager = Modular.get<MgAuth>();

  @override
  void initState() {
    super.initState();
    manager.fOtp.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MgAuth>(
      builder: (context, mg, child) {
        return WSharedScaffold(
          appBar: const WSharedAppBar(),
          padding: EdgeInsets.symmetric(horizontal: 35.w),
          bottomSheet: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child:
                mg.isVerifingOtp
                    ? const CircularProgressIndicator.adaptive()
                    : WAppButton(
                      title: 'confirm'.translated,
                      onTap: () async {
                        await mg.verifyOtp();
                      },
                    ),
          ),
          body: ListView(
            children: [
              Image.asset(Assets.gifs.enterOTP.path, height: 240.h, width: 240.w),
              60.heightBox,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'A message with verification code was sent to'.translated,
                      style: context.textTheme.black18w400Arial,
                    ),
                    TextSpan(
                      text: ' ${manager.fRegister.phoneField.toApiBody()} ',
                      style: context.textTheme.black18w700Arial,
                    ),
                    TextSpan(
                      text: ' please enter that code below'.translated,
                      style: context.textTheme.black18w400Arial,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
              84.heightBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: manager.fOtp.pinCodeField.buildField(
                  context,
                  param: ParamsCustomInput(
                    pinCodeOptions: CustomPinCodeOptions(
                      onCompleted: (pin) async {
                        await manager.verifyOtp();
                      },
                    ),
                  ),
                ),
              ),
              20.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn’t get code? click to send again'.translated,
                    style: context.textTheme.black18w400Arial,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              const Spacer(),
              200.heightBox,
            ],
          ),
        );
      },
    );
  }
}
