import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

enum AppButtonVariant { primary, outline, ghost }

class AppElevatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final AppButtonVariant variant;
  final double? width;
  final double height;
  final double borderRadius;

  const AppElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = AppButtonVariant.primary,
    this.width,
    this.height = 54,
    this.borderRadius = 14,
  });

  /// Outline variant constructor
  const AppElevatedButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 54,
    this.borderRadius = 14,
  }) : variant = AppButtonVariant.outline;

  /// Ghost/text variant constructor
  const AppElevatedButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 54,
    this.borderRadius = 14,
  }) : variant = AppButtonVariant.ghost;

  @override
  State<AppElevatedButton> createState() => _AppElevatedButtonState();
}

class _AppElevatedButtonState extends State<AppElevatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _animController;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _animController.reverse();
  void _onTapUp(_) => _animController.forward();
  void _onTapCancel() => _animController.forward();

  // ── Color resolvers ─────────────────────────────────────────
  Color get _bgColor {
    if (widget.onPressed == null) return AppColors.bgBorderColor;
    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.primaryColor,
      AppButtonVariant.outline => Colors.transparent,
      AppButtonVariant.ghost   => Colors.transparent,
    };
  }

  Color get _labelColor {
    if (widget.onPressed == null) return AppColors.paymentTxtColor;
    return switch (widget.variant) {
      AppButtonVariant.primary => Colors.white,
      AppButtonVariant.outline => AppColors.primaryColor,
      AppButtonVariant.ghost   => AppColors.primaryColor,
    };
  }

  BorderSide get _borderSide => switch (widget.variant) {
    AppButtonVariant.primary => BorderSide.none,
    AppButtonVariant.outline => BorderSide(color: AppColors.primaryColor, width: 1.8),
    AppButtonVariant.ghost   => BorderSide.none,
  };

  List<BoxShadow> get _shadow => widget.variant == AppButtonVariant.primary &&
      widget.onPressed != null
      ? [
    BoxShadow(
      color: AppColors.primaryColor.withOpacity(0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ]
      : [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.fromBorderSide(_borderSide),
            boxShadow: _shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_labelColor),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null) ...[
          Icon(widget.prefixIcon, size: 18, color: _labelColor),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: AppTextStyles.buttonMedium.copyWith(color: _labelColor),
        ),
        if (widget.suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.suffixIcon, size: 18, color: _labelColor),
        ],
      ],
    );
  }
}