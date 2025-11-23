import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
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

  @override
  void initState() {
    super.initState();
    _mgIndex = Modular.get<MgIndex>();
    _mgIndex.loadIndex();
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

          return ListView.separated(
            padding: EdgeInsets.only(top: 0.h, bottom: Constants.navbarHeight.h),
            itemCount: _mgIndex.surahs.length,
            separatorBuilder: (context, index) => Divider(color: context.theme.colorScheme.lightGray),
            itemBuilder: (context, index) {
              final surah = _mgIndex.surahs[index];

              return WSurahRow(surah: surah, onTap: () => _mgIndex.selectIndex(index));
            },
          );
        },
      ),
    );
  }
}
