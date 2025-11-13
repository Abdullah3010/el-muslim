// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:al_muslim/core/extension/build_context.dart';
// import 'package:al_muslim/core/extension/num_ext.dart';
// import 'package:al_muslim/core/extension/text_theme_extension.dart';
// import 'package:al_muslim/core/widgets/w_app_button.dart';
// import 'package:al_muslim/modules/auth/managers/mg_auth.dart';

// class WForgetPasswordStepOne extends StatefulWidget {
//   const WForgetPasswordStepOne({super.key});

//   @override
//   State<WForgetPasswordStepOne> createState() => _WForgetPasswordStepOneState();
// }

// class _WForgetPasswordStepOneState extends State<WForgetPasswordStepOne> {
//   MgAuth manager = Modular.get<MgAuth>();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         20.heightBox,
//         Text(
//           'إعادة تعيين كلمة المرور',
//           style: context.textTheme.black16w700,
//           textAlign: TextAlign.center,
//         ),
//         26.heightBox,
//         manager.fForgetPassword.emailField.buildField(context),
//         58.heightBox,
//         Center(
//           child: WAppButton(
//             title: 'ارسال الكود',
//             onTap: () async {
//               await manager.sendOtp();
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
