import 'dart:math';

import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

const _defaultCategoryStyle = _CategoryStyle(
  gradient: LinearGradient(
    colors: [Color(0xFFFCEED4), Color(0xFFF5DFB1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  icon: Icons.star,
  iconColor: Color(0xFFB66A00),
  textColor: Color(0xFF42240F),
  shadowColor: Color(0x22000000),
);

const Map<int, _CategoryStyle> _categoryStyles = {
  1: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFFFF5E7), Color(0xFFF8E1BC)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.menu_book_outlined,
    iconColor: Color(0xFFB36800),
    textColor: Color(0xFF3F2A13),
    shadowColor: Color(0x22000000),
  ),
  2: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFD1EBFF), Color(0xFFA3D4FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.nights_stay_outlined,
    iconColor: Color(0xFF2B5DA0),
    textColor: Color(0xFF1D2D4C),
    shadowColor: Color(0x22000000),
  ),
  3: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFDFF6E7), Color(0xFFB8E7C5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.label,
    iconColor: Color(0xFF2F7150),
    textColor: Color(0xFF113426),
    shadowColor: Color(0x22000000),
  ),
  4: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFFFF4D7), Color(0xFFFBCF85)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.wb_sunny_outlined,
    iconColor: Color(0xFFD89F00),
    textColor: Color(0xFF3B2A0C),
    shadowColor: Color(0x22000000),
  ),
  5: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFDAE8FF), Color(0xFFABC6FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.nightlight_round_outlined,
    iconColor: Color(0xFF1C3B88),
    textColor: Color(0xFF0F215C),
    shadowColor: Color(0x22000000),
  ),
  6: _CategoryStyle(
    gradient: LinearGradient(
      colors: [Color(0xFFDBF9F6), Color(0xFFA7F1EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    icon: Icons.waving_hand_outlined,
    iconColor: Color(0xFF0D7A6F),
    textColor: Color(0xFF0F3F3A),
    shadowColor: Color(0x22000000),
  ),
};

class _CategoryStyle {
  final LinearGradient gradient;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color shadowColor;

  const _CategoryStyle({
    required this.gradient,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.shadowColor,
  });
}

class SnAzkarList extends StatefulWidget {
  const SnAzkarList({super.key});

  @override
  State<SnAzkarList> createState() => _SnAzkarListState();
}

class _SnAzkarListState extends State<SnAzkarList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<MgAzkar>().loadAzkarCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      withNavBar: true,
      body: Consumer<MgAzkar>(
        builder: (context, manager, _) {
          if (manager.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          const spacing = 12.0;

          return MasonryGridView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 120),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            itemCount: manager.categories.length,
            itemBuilder: (context, index) {
              final category = manager.categories[index];
              final style = _categoryStyles[category.id ?? -1] ?? _defaultCategoryStyle;
              final cardHeight = 180.0 + Random(index + 1).nextInt(70);

              return SizedBox(
                height: cardHeight,
                child: InkWell(
                  onTap: () {
                    Modular.to.pushNamed(RoutesNames.azkar.zekr(category.id ?? 1));
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: style.gradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: style.shadowColor, blurRadius: 16, offset: const Offset(0, 8))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(style.icon, size: 44, color: style.iconColor),
                          const Spacer(),
                          Text(
                            category.displayName,
                            style: TextStyle(color: style.textColor, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
