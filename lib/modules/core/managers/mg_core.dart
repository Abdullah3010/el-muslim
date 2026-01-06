import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/core/data/model/m_nav_bar_item.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MgCore extends ChangeNotifier {
  int _currentIndex = 0;

  int get navIndex => _currentIndex;

  List<MNavBarItem> get navBarItems => [
    MNavBarItem(
      label: 'Quran'.translated,
      activeIcon: Assets.icons.listActive.path,
      inactiveIcon: Assets.icons.listInactive.path,
      route: RoutesNames.index.indexMain,
    ),
    MNavBarItem(
      label: 'The Prayer'.translated,
      activeIcon: Assets.icons.prayActive.path,
      inactiveIcon: Assets.icons.prayInactive.path,
      route: RoutesNames.prayTime.prayTimeMain,
    ),
    MNavBarItem(
      label: 'Werd Day'.translated,
      activeIcon: Assets.icons.werdActive.path,
      inactiveIcon: Assets.icons.werdInactive.path,
      route: RoutesNames.werd.werdMain,
    ),
    MNavBarItem(
      label: 'Azkar'.translated,
      activeIcon: Assets.icons.azkarActive.path,
      inactiveIcon: Assets.icons.azkarInactive.path,
      route: RoutesNames.azkar.azkarMain,
    ),
    MNavBarItem(
      label: 'More'.translated,
      activeIcon: Assets.icons.moreActive.path,
      inactiveIcon: Assets.icons.moreInactive.path,
      route: RoutesNames.more.moreMain,
    ),
  ];

  void setNavBarIndex(int index) {
    _currentIndex = index;
    Modular.to.navigate(navBarItems[index].route);
    notifyListeners();
  }

  int currentAdIndex = 0;
  void onAdPageChanged(int index) {
    currentAdIndex = index;
    notifyListeners();
  }

  Future<void> initAppData() async {
    await Modular.get<MgIndex>().loadIndex();
  }
}
