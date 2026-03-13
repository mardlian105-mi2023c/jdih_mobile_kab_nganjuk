import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isScrolled;
  final VoidCallback? onBack;

  const AppBarWidget({
    super.key,
    required this.isScrolled,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isScrolled ? Colors.white : Colors.transparent,
        elevation: isScrolled ? 4 : 0,
        toolbarHeight: kToolbarHeight + 10,
        centerTitle: true,
        titleSpacing: 16,

        leading: onBack != null
            ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isScrolled ? Colors.black : Colors.white,
          ),
          onPressed: onBack,
        )
            : null,

        title: Image.asset(
          'assets/logojdih.png',
          height: 36,
          fit: BoxFit.contain,
        ),

        actions: const [],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}