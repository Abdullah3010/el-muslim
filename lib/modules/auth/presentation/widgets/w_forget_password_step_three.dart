// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:al_muslim/core/config/params/params_custom_input.dart';
// import 'package:al_muslim/core/extension/build_context.dart';
// import 'package:al_muslim/core/extension/num_ext.dart';
// import 'package:al_muslim/core/extension/string_extensions.dart';
// import 'package:al_muslim/core/extension/text_theme_extension.dart';
// import 'package:al_muslim/core/widgets/w_app_button.dart';
// import 'package:al_muslim/modules/auth/managers/mg_auth.dart';

// class WForgetPasswordStepThree extends StatefulWidget {
//   const WForgetPasswordStepThree({super.key});

//   @override
//   State<WForgetPasswordStepThree> createState() => _WForgetPasswordStepThreeState();
// }

// class _WForgetPasswordStepThreeState extends State<WForgetPasswordStepThree> {
//   MgAuth manager = Modular.get<MgAuth>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: manager.fForgetPassword.formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           20.heightBox,
//           Text(
//             'إعادة تعيين كلمة المرور',
//             style: context.textTheme.black16w700,
//             textAlign: TextAlign.center,
//           ),
//           26.heightBox,
//           manager.fForgetPassword.passwordField.buildField(context),
//           16.heightBox,
//           manager.fForgetPassword.confirmPasswordField.buildField(
//             context,
//             param: ParamsCustomInput(
//               confirmPaswordValidation: (confirmPassword) {
//                 return manager.fForgetPassword.passwordField.controller.text != confirmPassword
//                     ? 'Passwords do not match'.translated
//                     : null;
//               },
//             ),
//           ),
//           20.heightBox,
//           Center(
//             child: WAppButton(
//               title: 'حفظ'.translated,
//               onTap: () async {
//                 await manager.verifyOtp();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
