import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_bottom_sheet.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_werd_empty_state.dart';

class SnWerd extends StatefulWidget {
  const SnWerd({super.key});

  @override
  State<SnWerd> createState() => _SnWerdState();
}

class _SnWerdState extends State<SnWerd> {
  late final MgWerd _mgWerd;
  late final VoidCallback _listener;
  bool _shouldAutoOpenSaved = true;
  bool _didLoadOnce = false;
  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    _listener = _handleUpdates;
    _mgWerd.addListener(_listener);
    _mgWerd.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final isLoading = _mgWerd.isPlanLoading || _mgWerd.isPlanDetailsLoading || _mgWerd.isLoading;
        return WSharedScaffold(
          withNavBar: true,
          appBar: WSharedAppBar(title: 'Werd'.translated, withBack: false),
          body:
              !_didLoadOnce || isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : WWerdEmptyState(mgWerd: _mgWerd, onPrimaryAction: _handlePrimaryAction),
        );
      },
    );
  }

  @override
  void dispose() {
    _mgWerd.removeListener(_listener);
    super.dispose();
  }

  void _handlePrimaryAction(bool hasCurrentWerd) {
    _shouldAutoOpenSaved = false;
    if (hasCurrentWerd) {
      Modular.to.pushNamed(RoutesNames.werd.werdDetails);
    } else {
      WNewWerdBottomSheet.show(context);
    }
  }

  void _markLoadedOnce() {
    if (_didLoadOnce) return;
    if (_mgWerd.isPlanLoading || _mgWerd.isPlanDetailsLoading || _mgWerd.isLoading) return;
    setState(() {
      _didLoadOnce = true;
    });
  }

  void _handleUpdates() {
    _markLoadedOnce();
    if (!_shouldAutoOpenSaved) return;
    if (_mgWerd.isPlanLoading || _mgWerd.isPlanDetailsLoading) return;
    if (_mgWerd.selectedPlanDay == null) return;

    _shouldAutoOpenSaved = false;
    Modular.to.pushNamed(RoutesNames.werd.werdDetails);
  }
}
