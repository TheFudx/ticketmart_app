import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

class BookingCategoryTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const BookingCategoryTabsWidget({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'Comedy Shows', 'icon': Icons.mic_external_on_rounded},
    {'label': 'Booking Tickets', 'icon': Icons.movie_creation_outlined},
    {'label': 'Event Tickets', 'icon': Icons.music_note_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking History',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: List.generate(_categories.length, (i) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(i),
                child: _buildTab(i),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTab(int index) {
    final isSelected = selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : AppColors.bgBorderColor,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Column(
        children: [
          Icon(
            _categories[index]['icon'] as IconData,
            color: isSelected ? Colors.white : AppColors.primaryColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            _categories[index]['label'] as String,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}