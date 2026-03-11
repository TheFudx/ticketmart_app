import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticketmart/controllers/login_controller.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';
import '../../utils/app_text_style.dart';
import '../../widget/app_elevated_button.dart';
import '../../widget/app_text_field.dart';
import '../home/drawer/privacy_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileController.dispose();
    _emailFocus.dispose();
    _mobileFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    final controller = LoginController(context);

    final error = await controller.submit(
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      _showError(error);
      return;
    }

    _emailController.clear();
    _mobileController.clear();
    Get.off(() => const HomeScreen());
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  // Ensure content fills full screen height
                  constraints: BoxConstraints(
                    minHeight: screenHeight -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Top spacer (dynamic) ───────────
                          SizedBox(height: screenHeight * 0.08),

                          // ── Logo Block ─────────────────────
                          _buildLogoBlock(),

                          SizedBox(height: screenHeight * 0.05),
                          // ── Email Field ────────────────────
                          AppTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            label: AppString.emailTxt,
                            hint: 'you@example.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context)
                                    .requestFocus(_mobileFocus),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppString.plzEntEmailTxt;
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return AppString.plzEntEmailTxt;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ── Mobile Field ───────────────────
                          AppTextField(
                            controller: _mobileController,
                            focusNode: _mobileFocus,
                            label: AppString.mobileNumTxt,
                            hint: '10-digit mobile number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onFieldSubmitted: (_) => _submit(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppString.plzEntMobTxt;
                              }
                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return AppString.mobLengTxt;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // ── Submit Button ──────────────────
                          AppElevatedButton(
                            label: AppString.submit,
                            isLoading: _isLoading,
                            onPressed: _submit,
                          ),

                          const SizedBox(height: 20),

                          // ── Divider ────────────────────────
                          _buildDivider(),

                          const SizedBox(height: 20),

                          // ── Terms ──────────────────────────
                          _buildTermsText(),

                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo Block ─────────────────────────────────────────────
  Widget _buildLogoBlock() {
    return Column(
      children: [
        // Logo container with soft bg ring
        Container(
          height: 170.h,
          width: 190.w,
          child: Image.asset(
            AppAssets.logo,
            fit: BoxFit.contain,
          ),
        ),

      ],
    );
  }


  // ── Divider with OR ────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.bgBorderColor, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'Secure Login',
            style: AppTextStyles.captionMedium,
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.bgBorderColor, thickness: 1),
        ),
      ],
    );
  }

  // ── Terms ──────────────────────────────────────────────────
  Widget _buildTermsText() {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPage()));
      },
      child: Center(
        child: Text.rich(
          TextSpan(
            text: 'By continuing, you agree to our ',
            style: AppTextStyles.captionLarge,
            children: [
              TextSpan(

                text: 'Terms & Privacy Policy',
                style: AppTextStyles.captionLarge.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}