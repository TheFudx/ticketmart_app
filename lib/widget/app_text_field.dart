import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(PointerDownEvent)? onTapOutside;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.validator,
    this.inputFormatters,
    this.onTapOutside,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isFocused = false;
  bool _obscure = true;
  late FocusNode _focusNode;

  bool get _isPassword => widget.obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating label above field
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            widget.label,
            style: AppTextStyles.labelLarge.copyWith(

            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _isPassword ? _obscure : false,
          maxLength: widget.maxLength,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onTapOutside: widget.onTapOutside ??
                  (event) => FocusScope.of(context).unfocus(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.colorBlack,
          ),
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.paymentTxtColor.withOpacity(0.5),
            ),
            counterText: '', // hide maxLength counter

            fillColor: _isFocused
                ? AppColors.primaryColor
                : AppColors.bgBorderColor,

            // ── Prefix Icon ──────────────────────────
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 14, right: 12),
              child: Icon(
                widget.prefixIcon,
                size: 20,
                color: _isFocused
                    ? AppColors.primaryColor
                    : AppColors.paymentTxtColor,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),

            // ── Suffix Icon (password toggle / custom) ─
            suffixIcon: _isPassword
                ? GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.paymentTxtColor,
                ),
              ),
            )
                : widget.suffixIcon != null
                ? Icon(
              widget.suffixIcon,
              size: 20,
              color: AppColors.paymentTxtColor,
            )
                : null,

            // ── Border Styles ────────────────────────
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.bgBorderColor,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.8,
              ),
            ),
            errorStyle: AppTextStyles.captionMedium.copyWith(
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}