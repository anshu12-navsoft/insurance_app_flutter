import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/constants/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  AnimationController? _fadeController;
  AnimationController? _slideController;
  AnimationController? _checkboxController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _checkboxAnimation;

  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkboxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController!,
            curve: Curves.easeOutCubic,
          ),
        );

    _checkboxAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _checkboxController!, curve: Curves.elasticOut),
    );

    _fadeController!.forward();
    _slideController!.forward();
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    _checkboxController?.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passCtrl.text.trim().isEmpty ||
        confirmPassCtrl.text.trim().isEmpty) {
      _showSnack("Please fill all fields", Colors.red);
      return;
    }

    if (passCtrl.text != confirmPassCtrl.text) {
      _showSnack("Passwords do not match", Colors.red);
      return;
    }

    if (!_acceptTerms) {
      _showSnack("Please accept terms and conditions", Colors.orange);
      return;
    }

    Navigator.pushReplacementNamed(context, "/dashboard");
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFf093fb), Color(0xFF764ba2), Color(0xFF667eea)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // 🔑 FIX
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWeb ? 460 : double.infinity,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),

                            /// HEADER
                            FadeTransition(
                              opacity: _fadeAnimation!,
                              child: SlideTransition(
                                position: _slideAnimation!,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 24),

                                    /// Centered Title + Subtitle
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Create Account",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Join us and start your journey",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            /// FORM CARD
                            FadeTransition(
                              opacity: _fadeAnimation!,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      hint: "Full Name",
                                      controller: nameCtrl,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      hint: "Email Address",
                                      controller: emailCtrl,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      hint: "Password",
                                      controller: passCtrl,
                                      obscure: true,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      hint: "Confirm Password",
                                      controller: confirmPassCtrl,
                                      obscure: true,
                                    ),
                                    const SizedBox(height: 20),

                                    /// TERMS
                                    ScaleTransition(
                                      scale: _checkboxAnimation!,
                                      child: InkWell(
                                        onTap: () {
                                          setState(
                                            () => _acceptTerms = !_acceptTerms,
                                          );
                                          if (_acceptTerms) {
                                            _checkboxController!.forward(
                                              from: 0,
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: _acceptTerms,
                                              onChanged: (v) => setState(
                                                () => _acceptTerms = v!,
                                              ),
                                              activeColor: AppColors.primary,
                                            ),
                                            const Expanded(
                                              child: Text(
                                                "I accept Terms & Conditions",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    CustomButton(
                                      text: "Already have Account",
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    ),const SizedBox(height: 20),
                                    CustomButton(
                                      text: "Create Account",
                                      onPressed: _handleSignup,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
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
