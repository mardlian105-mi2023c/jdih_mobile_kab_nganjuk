import 'package:flutter/material.dart';

class FloatingBottomBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;
  final Widget child;

  const FloatingBottomBarWidget({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      body: child,

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.home_outlined, "Beranda", 0),
          _buildItem(Icons.description_outlined, "Dokumen", 1),
          _buildItem(Icons.info_outline, "Tentang Kami", 2),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, int index) {
    final isSelected = index == currentIndex;

    return InkWell(
      onTap: () => onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xff3E5F8A) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xff3E5F8A) : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}