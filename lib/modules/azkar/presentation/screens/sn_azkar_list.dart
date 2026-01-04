import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
      body: Column(
        children: [
          Text('El-Muslim'.translated, style: context.textTheme.primary30W500),
          Expanded(
            child: Consumer<MgAzkar>(
              builder: (context, manager, _) {
                if (manager.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 120),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.w,
                    crossAxisSpacing: 20.h,
                    childAspectRatio: 1,
                  ),
                  itemCount: manager.categories.length,
                  itemBuilder: (context, index) {
                    final category = manager.categories[index];
                    final style = _categoryStyles[category.id ?? -1] ?? _defaultCategoryStyle;
                    final imagePath = category.imagePath;

                    return _AzkarCategoryCard(
                      style: style,
                      imagePath: imagePath,
                      title: category.displayName,
                      onTap: () => Modular.to.pushNamed(RoutesNames.azkar.zekr(category.id ?? 1)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AzkarCategoryCard extends StatefulWidget {
  const _AzkarCategoryCard({required this.style, required this.imagePath, required this.title, required this.onTap});

  final _CategoryStyle style;
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  @override
  State<_AzkarCategoryCard> createState() => _AzkarCategoryCardState();
}

class _AzkarCategoryCardState extends State<_AzkarCategoryCard> {
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;
  bool _imageAvailable = true;

  @override
  void initState() {
    super.initState();
    // _resolveImage();
  }

  @override
  void didUpdateWidget(covariant _AzkarCategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _resolveImage();
    }
  }

  @override
  void dispose() {
    _removeImageListener();
    super.dispose();
  }

  void _resolveImage() {
    _removeImageListener();
    if (widget.imagePath.isEmpty) {
      if (_imageAvailable) {
        setState(() => _imageAvailable = false);
      }
      return;
    }

    final provider = AssetImage(widget.imagePath);
    final stream = provider.resolve(const ImageConfiguration());
    _imageStream = stream;
    _imageListener = ImageStreamListener(
      (_, __) {
        if (!mounted) return;
        if (!_imageAvailable) {
          setState(() => _imageAvailable = true);
        }
      },
      onError: (_, __) {
        if (!mounted) return;
        if (_imageAvailable) {
          setState(() => _imageAvailable = false);
        }
      },
    );
    stream.addListener(_imageListener!);
  }

  void _removeImageListener() {
    if (_imageStream != null && _imageListener != null) {
      _imageStream!.removeListener(_imageListener!);
    }
    _imageStream = null;
    _imageListener = null;
  }

  @override
  Widget build(BuildContext context) {
    final showImage = _imageAvailable && widget.imagePath.isNotEmpty;
    print(" =====>>>> showImage: ${widget.imagePath}");
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          gradient: widget.style.gradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: widget.style.shadowColor.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            if (showImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(22.w),
              child: Text(
                widget.title,
                style: TextStyle(color: const Color(0xff004B40), fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
