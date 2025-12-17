import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please agree to Terms and Conditions',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      // Handle registration logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF6F52ED),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleLogIn() {
    // Navigate to login page
    Navigator.of(context).pop();
  }

  void _handleTermsAndConditions() {
    // Handle terms and conditions navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Terms and Conditions',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF6F52ED),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // App Logo Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://via.placeholder.com/120x120?text=Quick+Mart',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: Icon(
                              Icons.shopping_cart,
                              size: 60,
                              color: const Color(0xFF6F52ED),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFF6F52ED),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Page Title + Subtitle
                  Column(
                    children: [
                      Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by creating an account.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Input Fields Section
                  Column(
                    children: [
                      // Full Name Field
                      CustomInputField(
                        label: '',
                        hintText: 'Full name',
                        controller: _fullNameController,
                        showLabel: false,
                        backgroundColor: const Color(0xFFF3F3F3),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      CustomInputField(
                        label: '',
                        hintText: 'Valid email',
                        controller: _emailController,
                        showLabel: false,
                        backgroundColor: const Color(0xFFF3F3F3),
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Phone Number Field
                      CustomInputField(
                        label: '',
                        hintText: 'Phone number',
                        controller: _phoneController,
                        showLabel: false,
                        backgroundColor: const Color(0xFFF3F3F3),
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      CustomInputField(
                        label: '',
                        hintText: 'Strong Password',
                        controller: _passwordController,
                        showLabel: false,
                        backgroundColor: const Color(0xFFF3F3F3),
                        obscureText: true,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey.shade600,
                          size: 22,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF6F52ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade700,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            'By checking the box you agree to our '),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: _handleTermsAndConditions,
                                        child: Text(
                                          'Terms and Conditions.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6F52ED),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Register Button
                      CustomButton(
                        text: 'Register >',
                        onPressed: _handleRegister,
                        height: 55,
                        borderRadius: 30,
                        backgroundColor: const Color(0xFF6F52ED),
                      ),

                      const SizedBox(height: 32),

                      // Bottom Log In Text
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                          children: [
                            const TextSpan(text: 'Already a member? '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: _handleLogIn,
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6F52ED),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
