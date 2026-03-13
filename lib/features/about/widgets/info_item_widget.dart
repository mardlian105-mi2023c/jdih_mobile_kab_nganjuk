import 'package:flutter/material.dart';

class InfoItemWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoItemWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Text(
              ":",
              style: TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}