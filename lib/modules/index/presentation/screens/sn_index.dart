import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/index/presentation/widgets/w_surah_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnIndex extends StatefulWidget {
  const SnIndex({super.key});

  @override
  State<SnIndex> createState() => _SnIndexState();
}

class _SnIndexState extends State<SnIndex> {
  late final MgIndex _mgIndex;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mgIndex = Modular.get<MgIndex>();
    _mgIndex.loadIndex();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _mgIndex.search(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      withNavBar: true,
      appBar: WSharedAppBar(title: 'Index'.translated, withBack: false),
      body: AnimatedBuilder(
        animation: _mgIndex,
        builder: (context, _) {
          if (_mgIndex.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (_mgIndex.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_mgIndex.errorMessage ?? 'Unable to load index'.translated, textAlign: TextAlign.center),
                  12.heightBox,
                  TextButton(onPressed: () => _mgIndex.loadIndex(), child: Text('Retry'.translated)),
                ],
              ),
            );
          }

          if (!_mgIndex.hasData) {
            return Center(child: Text('Unable to load index'.translated));
          }

          final surahs = _mgIndex.filteredSurahs;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  cursorColor: context.theme.colorScheme.primaryColor,
                  cursorHeight: 20.h,
                  decoration: InputDecoration(
                    hintText: 'Search surah'.translated,
                    prefixIcon: Icon(Icons.search, color: context.theme.colorScheme.primaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: context.theme.textTheme.primary14W500.copyWith(color: context.theme.colorScheme.gray),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  ),
                ),
              ),
              8.heightBox,
              Expanded(
                child:
                    surahs.isEmpty
                        ? Center(child: Text('No results'.translated))
                        : ListView.separated(
                          padding: EdgeInsets.only(top: 0.h, bottom: Constants.navbarHeight.h),
                          itemCount: surahs.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                indent: 20.w,
                                endIndent: 20.w,
                                color: context.theme.colorScheme.secondaryColor,
                              ),
                          itemBuilder: (context, index) {
                            final surah = surahs[index];

                            return WSurahRow(surah: surah, onTap: () => _mgIndex.selectSurah(surah));
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
