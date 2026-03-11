import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class PassBannerWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const PassBannerWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            _buildPassBadge(),
            const SizedBox(width: 14),
            Container(width: 1, height: 36, color: AppColors.bgBorderColor),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Become a Pass holder at ₹999',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Text(
            'ticket',
            style: TextStyle(color: Colors.white70, fontSize: 8, letterSpacing: 1),
          ),
          Text(
            'PASS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}