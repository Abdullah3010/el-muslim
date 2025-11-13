// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:al_muslim/core/widgets/forms/w_pin_code_field.dart';
// import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
// import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
// import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_one.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_three.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_two.dart';
// import 'package:provider/provider.dart';

// class SNForgetPasswordFlow extends StatefulWidget {
//   const SNForgetPasswordFlow({super.key});

//   @override
//   State<SNForgetPasswordFlow> createState() => _SNForgetPasswordFlowState();
// }

// class _SNForgetPasswordFlowState extends State<SNForgetPasswordFlow> {
//   MgAuth manager = Modular.get<MgAuth>();

//   @override
//   void initState() {
//     super.initState();
//     manager.fForgetPassword.init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MgAuth>(
//       builder: (context, manager, child) {
//         return WSharedScaffold(
//           appBar: WSharedAppBar(
//             withScaffoldBackground: true,
//             onBackTap: () {
//               if (manager.forgetPasswordStep.value == 1) {
//                 Modular.to.pop();
//               } else if (manager.forgetPasswordStep.value == 2) {
//                 manager.setForgetPasswordStep(1);
//               } else if (manager.forgetPasswordStep.value == 3) {
//                 manager.fForgetPassword.pinCodeField = WPinCodeField(
//                   hint: '',
//                 );
//                 manager.setForgetPasswordStep(2);
//               }
//             },
//           ),
//           body: ListView(
//             padding: EdgeInsets.only(
//               right: 20.w,
//               left: 20.w,
//               top: 100.h,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
//             ),
//             children: [
//               if (manager.forgetPasswordStep.value == 1) const WForgetPasswordStepOne(),
//               if (manager.forgetPasswordStep.value == 2) const WForgetPasswordStepTwo(),
//               if (manager.forgetPasswordStep.value == 3) const WForgetPasswordStepThree(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
