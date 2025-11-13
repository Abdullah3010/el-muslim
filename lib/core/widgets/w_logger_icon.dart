import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';

class WLoggerIcon extends StatefulWidget {
  const WLoggerIcon({super.key});

  @override
  State<WLoggerIcon> createState() => _WLoggerIconState();
}

class _WLoggerIconState extends State<WLoggerIcon> {
  Offset _offset = const Offset(0, 100);
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _offset = Offset(0, context.height * .45);
      _initialized = true;
    }
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        onTap: () {
          Modular.to.pushNamed(RoutesNames.core.logger);
        },
        onPanUpdate: (d) => setState(() => _offset += Offset(d.delta.dx, d.delta.dy)),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: context.theme.colorScheme.red.withValues(alpha: .35),
          child: Icon(Icons.bug_report_outlined, size: 50.0, color: context.theme.colorScheme.red),
        ),
      ),
    );
  }
}
