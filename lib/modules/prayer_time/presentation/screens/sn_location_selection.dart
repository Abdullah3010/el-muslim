import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_location_selection.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_city_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnLocationSelection extends StatefulWidget {
  const SnLocationSelection({super.key});

  @override
  State<SnLocationSelection> createState() => _SnLocationSelectionState();
}

class _SnLocationSelectionState extends State<SnLocationSelection> {
  late final MgLocationSelection _manager;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manager = Modular.get<MgLocationSelection>();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _manager.search(_searchController.text);
  }

  void _onCityTap(MCityOption city) {
    _manager.selectCity(city);
    Modular.to.pop(city);
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(
        title: _manager.countryName.isNotEmpty ? _manager.countryName : 'Location'.translated,
        withBack: true,
      ),
      body: AnimatedBuilder(
        animation: _manager,
        builder: (context, _) {
          final cities = _manager.filteredCities;

          if (_manager.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_manager.errorMessage != null && cities.isEmpty) {
            return Center(child: Text(_manager.errorMessage!, textAlign: TextAlign.center));
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search cities'.translated,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cities.length,
                  separatorBuilder:
                      (_, __) => Divider(height: 1, color: Colors.grey.shade300, indent: 16.w, endIndent: 16.w),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return WCityOptionItem(city: city, onTap: () => _onCityTap(city));
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
