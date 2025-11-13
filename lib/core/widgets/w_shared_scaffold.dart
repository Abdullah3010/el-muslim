import 'package:al_muslim/core/widgets/w_shared_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:al_muslim/core/extension/build_context.dart';

class WSharedScaffold extends StatefulWidget {
  const WSharedScaffold({
    required this.body,
    this.scaffoldKey,
    this.resizeToAvoidBottomInset,
    this.appBar,
    this.bottomSheet,
    this.padding,
    this.withSafeArea = true,
    this.isScreenLoading = false,
    this.withNavBar = false,
    super.key,
  });

  final Widget body;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool withSafeArea;
  final bool? resizeToAvoidBottomInset;
  final bool? withNavBar;
  final bool? isScreenLoading;
  final Widget? appBar;
  final Widget? bottomSheet;
  final EdgeInsetsGeometry? padding;

  @override
  State<WSharedScaffold> createState() => _WSharedScaffoldState();
}

class _WSharedScaffoldState extends State<WSharedScaffold> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Directionality(
        textDirection: context.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Stack(
          children: [
            Container(
              color: context.theme.colorScheme.scaffoldBackgroundColor,
              width: context.width,
              height: context.height,
            ),
            Scaffold(
              key: widget.scaffoldKey,
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.transparent,
              appBar:
                  widget.appBar == null
                      ? null
                      : AppBar(
                        title: widget.appBar,
                        leading: const SizedBox(),
                        leadingWidth: 0,
                        backgroundColor: Colors.transparent,
                        forceMaterialTransparency: true,
                      ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    SafeArea(
                      top: widget.withSafeArea,
                      bottom: widget.withSafeArea,
                      right: widget.withSafeArea,
                      left: widget.withSafeArea,
                      child: Container(
                        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),
                        child: widget.body,
                      ),
                    ),
                    if (widget.withNavBar == true) const Positioned(bottom: 10, child: WSharedNavBar()),
                  ],
                ),
              ),
              bottomSheet: widget.bottomSheet,
            ),
            if (widget.isScreenLoading ?? false)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.4),
                  child: const Center(child: CupertinoActivityIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
