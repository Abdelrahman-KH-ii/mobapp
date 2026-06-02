import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/core/utils/assets.dart';
import 'package:farmtec/features/auth/presentation/screens/login_screen.dart';
import 'package:farmtec/features/auth/presentation/widgets/app_text_field.dart';
import 'package:farmtec/features/auth/presentation/widgets/farm_tec_logo.dart';
import 'package:farmtec/features/auth/presentation/widgets/field_label.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class SignupBody extends StatefulWidget {
  const SignupBody({super.key});

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final fillColor = isDark ? Pallete.darkSurfaceVariant : Pallete.background;
    final borderColor = isDark ? Pallete.darkOutline : const Color(0xFFE6E9E9);

    return Scaffold(
      backgroundColor: isDark ? Pallete.darkBackground : Pallete.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        FarmTecLogo(isDark: isDark),
                        const SizedBox(height: 28),
                        Text(
                          l.tr('create_account'),
                          style: GoogleFonts.manrope(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.tr('sign_up_subtitle'),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: subColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FieldLabel(
                                text: l.tr('full_name'),
                                color: textColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: 'Ahmed Rady',
                                type: TextInputType.name,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                              ),
                              const SizedBox(height: 14),
                              FieldLabel(
                                text: l.tr('email_address'),
                                color: textColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: 'farm@example.com',
                                type: TextInputType.emailAddress,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                              ),
                              const SizedBox(height: 14),
                              FieldLabel(
                                text: l.tr('phone_number'),
                                color: textColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: '+20 1234567890',
                                type: TextInputType.phone,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                                prefix: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 14,
                                    right: 8,
                                  ),
                                  child: Icon(
                                    Icons.phone_rounded,
                                    size: 18,
                                    color: Pallete.textHint,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  FieldLabel(
                                    text: l.tr('farm_name'),
                                    color: textColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${l.tr('or')})',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: Pallete.textHint,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: 'Green Valley Farm',
                                type: TextInputType.text,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                                isRequired: false,
                              ),
                              const SizedBox(height: 14),
                              FieldLabel(
                                text: l.tr('location_region'),
                                color: textColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: 'Cairo, Egypt',
                                type: TextInputType.text,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                                prefix: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 14,
                                    right: 8,
                                  ),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: 18,
                                    color: Pallete.textHint,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              FieldLabel(
                                text: l.tr('password'),
                                color: textColor,
                              ),
                              const SizedBox(height: 6),
                              AppTextField(
                                hint: '••••••••',
                                type: TextInputType.visiblePassword,
                                obscure: _obscurePassword,
                                fillColor: fillColor,
                                borderColor: borderColor,
                                textColor: textColor,
                                suffix: GestureDetector(
                                  onTap: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: SvgPicture.asset(
                                      Assets.eyeIcon,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              l.tr('signup_button'),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: l.tr('terms_prefix'),
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: subColor,
                              ),
                              children: [
                                TextSpan(
                                  text: l.tr('terms_of_service'),
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Pallete.accent,
                                  ),
                                ),
                                TextSpan(text: l.tr('and')),
                                TextSpan(
                                  text: l.tr('privacy_policy'),
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Pallete.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l.tr('have_account'),
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: subColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      LoginScreen.routeName,
                                    );
                                  },
                                  child: Text(
                                    l.tr('login'),
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Pallete.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
