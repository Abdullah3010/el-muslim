// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:al_muslim/core/config/params/custom_pin_code_options.dart';
// import 'package:al_muslim/core/config/params/params_custom_input.dart';
// import 'package:al_muslim/core/extension/build_context.dart';
// import 'package:al_muslim/core/extension/num_ext.dart';
// import 'package:al_muslim/core/extension/string_extensions.dart';
// import 'package:al_muslim/core/extension/text_theme_extension.dart';
// import 'package:al_muslim/core/widgets/w_app_button.dart';
// import 'package:al_muslim/modules/auth/managers/mg_auth.dart';

// class WForgetPasswordStepTwo extends StatefulWidget {
//   const WForgetPasswordStepTwo({super.key});

//   @override
//   State<WForgetPasswordStepTwo> createState() => _WForgetPasswordStepTwoState();
// }

// class _WForgetPasswordStepTwoState extends State<WForgetPasswordStepTwo> {
//   MgAuth manager = Modular.get<MgAuth>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'التحقق من رمز ال OTP',
//           style: context.textTheme.black16w700,
//           textAlign: TextAlign.center,
//         ),
//         18.heightBox,
//         SizedBox(
//           width: 186.w,
//           child: Text(
//             'ادخل الرمز المرسل الي البريد الالكتروني التالي',
//             style: context.textTheme.grey12w600,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         6.heightBox,
//         Text(
//           manager.fForgetPassword.emailField.controller.text,
//           style: context.textTheme.black16w700,
//           textAlign: TextAlign.center,
//         ),
//         16.heightBox,
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w),
//           child: manager.fForgetPassword.pinCodeField.buildField(
//             context,
//             param: ParamsCustomInput(
//               pinCodeOptions: CustomPinCodeOptions(
//                 onCompleted: (pin) async {
//                   await manager.verifyOtp();
//                 },
//               ),
//             ),
//           ),
//         ),
//         16.heightBox,
//         WAppButton(
//           title: 'تأكيد'.translated,
//           onTap: () async {
//             await manager.verifyOtp();
//           },
//         ),
//       ],
//     );
//   }
// }
