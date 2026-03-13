import 'package:flutter/material.dart';
import '../models/peraturan_model.dart';
import 'peraturan_item_widget.dart';

class PeraturanListItemWidget extends StatelessWidget {
  final Peraturan peraturan;
  final int index;
  final int totalItems;
  final VoidCallback onTap;

  const PeraturanListItemWidget({
    super.key,
    required this.peraturan,
    required this.index,
    required this.totalItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index == 0) const SizedBox(height: 8),

        /// ⭐ OUTER SPACING (bukan internal card)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias, // ⭐ penting
            color: Colors.white,
            child: InkWell(
              onTap: onTap,
              child: PeraturanItemWidget(
                peraturan: peraturan,
                onTap: onTap,
              ),
            ),
          ),
        ),

        if (index < totalItems - 1) const SizedBox(height: 10),
      ],
    );
  }
}