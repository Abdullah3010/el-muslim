// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_one.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_three.dart';
// import 'package:al_muslim/modules/auth/presentation/widgets/w_forget_password_step_two.dart';

// class WForgetPasswordBottomSheet extends StatefulWidget {
//   const WForgetPasswordBottomSheet({super.key});

//   @override
//   State<WForgetPasswordBottomSheet> createState() => _WForgetPasswordBottomSheetState();
// }

// class _WForgetPasswordBottomSheetState extends State<WForgetPasswordBottomSheet> {
//   MgAuth manager = Modular.get<MgAuth>();

//   @override
//   void initState() {
//     super.initState();
//     manager.fForgetPassword.init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: manager.forgetPasswordStep,
//       builder: (_, value, __) {
//         switch (value) {
//           case 1:
//             return const WForgetPasswordStepOne();
//           case 2:
//             return const WForgetPasswordStepTwo();
//           case 3:
//             return const WForgetPasswordStepThree();
//           default:
//             return Container();
//         }
//       },
//     );
//   }
// }
