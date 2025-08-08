import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget reutilizable para crear un SliverAppBar personalizado y moderno
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final IconData? backgroundIcon;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Color startColor;
  final Color endColor;
  final double expandedHeight;
  final String titleRedirect;
  final String urlRedirect;
  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.backgroundIcon,
    this.onBackPressed,
    this.showBackButton = false,
    this.startColor = Colors.indigo,
    this.endColor = Colors.deepPurple,
    this.expandedHeight = 120,
    required this.titleRedirect,
    required this.urlRedirect,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: startColor,
      automaticallyImplyLeading: showBackButton,
      actions: [
        GestureDetector(
          onTap: () {
            context.go(urlRedirect);
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 0),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  titleRedirect,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
      leading: showBackButton
          ? Container(
              margin: const EdgeInsets.all(8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              ),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(8),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
          ),
          child: Stack(
            children: [
              if (backgroundIcon != null)
                Positioned(
                  top: 20,
                  right: 100,
                  child: Icon(
                    backgroundIcon!,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

CustomSliverAppBar custom({
  required String title,
  IconData? icon,
  Color? startColor,
  Color? endColor,
  bool showBack = false,
  VoidCallback? onBackPressed,
  List<Widget>? actions,
  double? expandedHeight,
  required String titleRedirect,
  required String urlRedirect,
}) {
  return CustomSliverAppBar(
    title: title,
    backgroundIcon: icon,
    startColor: startColor ?? Colors.blue,
    endColor: endColor ?? Colors.blueAccent,
    showBackButton: showBack,
    onBackPressed: onBackPressed,
    actions: actions,
    expandedHeight: expandedHeight ?? 120,
    titleRedirect: titleRedirect,
    urlRedirect: urlRedirect,
  );
}
