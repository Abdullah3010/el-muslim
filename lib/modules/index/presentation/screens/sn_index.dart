import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';

class SnIndex extends StatelessWidget {
  const SnIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(withNavBar: true, body: Center(child: Text('Index Screen'.translated)));
  }
}
