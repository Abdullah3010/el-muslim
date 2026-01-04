import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:al_muslim/modules/quran/presentation/screens/sn_quran_library.dart';
import 'package:flutter/material.dart';

class SnQuran extends StatelessWidget {
  const SnQuran({super.key, this.firstPage});

  final MQuranFirstPage? firstPage;

  @override
  Widget build(BuildContext context) {
    return SnQuranLibrary(firstPage: firstPage);
  }
}
