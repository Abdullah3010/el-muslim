import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';

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
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: manager.categories.length,
            itemBuilder: (context, index) {
              final category = manager.categories[index];
              return InkWell(
                onTap: () {
                  Modular.to.pushNamed(RoutesNames.azkar.zekr(category.id ?? 1));
                },
                child: Container(child: Center(child: Text(category.displayName))),
              );
            },
          );
        },
      ),
    );
  }
}
