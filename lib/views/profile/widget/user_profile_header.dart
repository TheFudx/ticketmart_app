import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onEditTap;

  const ProfileHeaderWidget({
    super.key,
    this.name = 'Update your name',
    this.phone = '+91 XXXXXXXXXX',
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 14),
          _buildNameSection(),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withOpacity(0.15),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 36,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildNameSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(phone, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return GestureDetector(
      onTap: onEditTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor.withOpacity(0.15),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: const Icon(
          Icons.edit_outlined,
          size: 18,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}