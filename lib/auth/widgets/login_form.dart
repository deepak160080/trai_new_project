import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trai_new_ui/auth/auth_services.dart';
import 'package:trai_new_ui/auth/phone_authentication.dart';
import 'package:trai_new_ui/auth/widgets/branded_logo.dart';
import 'package:trai_new_ui/auth/widgets/buttons.dart';
import 'package:trai_new_ui/home_page.dart';
import 'package:trai_new_ui/presentation/home/home_screen.dart';
import 'package:trai_new_ui/responsive/ts.dart';
import 'package:trai_new_ui/widget/textfield.dart';

enum SocialButtonsLayout { grid, column }

class LoginForm extends StatefulWidget {
  final SocialButtonsLayout socialButtonsLayout;
  final EdgeInsets padding;

  const LoginForm({
    super.key,
    required this.socialButtonsLayout,
    required this.padding,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
   final AuthServices _authService = AuthServices();
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoginFields(),
                const SizedBox(height: 10),
                _buildSocialButtons(),
                const SizedBox(height: 10),
                _buildMobileLoginButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const BrandLogo(),
        const Spacer(),
        Text(
          "Not a member yet? Join",
          style: Ts.semiBold12(),
        )
      ],
    );
  }

  Widget _buildLoginFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Login", style: Ts.bold20()),
        const SizedBox(height: 15),
        const Textfield(text: "Work Email"),
        const SizedBox(height: 10),
        const Textfield(text: "Password"),
        const SizedBox(height: 8),
        Text("Forget password?", style: Ts.medium14()),
        const SizedBox(height: 8),
        PrimaryButton(
          text: 'Login',
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => const ProjectsPage(),));
            log("login success");
          },
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    if (widget.socialButtonsLayout == SocialButtonsLayout.grid) {
      return _buildGridSocialButtons();
    } else {
      return _buildColumnSocialButtons();
    }
  }

  Widget _buildGridSocialButtons() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SocialButton(
                  text: 'Log in with Google',
                  icon: FontAwesomeIcons.google,
                  color: Colors.red,
                  onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  try {
                    final userCredential = 
                        await _authService.signInWithGoogle();
                    if (userCredential != null && mounted) {
                      // Navigate to home screen
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing in: $e'),
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isSigningIn = false;
                      });
                    }
                  }
                },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SocialButton(
                  text: 'Log in with Microsoft',
                  icon: FontAwesomeIcons.microsoft,
                  onPressed: (){},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SocialButton(
                  text: 'Log in with Facebook',
                  icon: Icons.facebook_outlined,
                  color: Colors.blue,
                    onPressed: () async {
                try {
                  final userCredential = await _authService.signInWithFacebook();
                  if (userCredential != null) {
                    // Navigate to home screen on successful login
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreen(),
                    //   ),
                    // );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SocialButton(
                  text: 'Log in with Apple',
                  icon: Icons.apple,
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
 Future<void> _handleLogin(BuildContext context, Future<UserCredential?> Function() signInMethod) async {
    try {
      final userCredential = await signInMethod();
      if (userCredential != null && context.mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        // );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildColumnSocialButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SocialButton(
            text: 'Log in with Google',
            icon: FontAwesomeIcons.google,
            color: Colors.red,
onPressed: () async {
  setState(() {
    _isSigningIn = true;
  });
  try {
    final userCredential = await _authService.signInWithGoogle();
    if (userCredential != null && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    } else if (mounted) {
      // Handle the case where sign in was cancelled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in cancelled'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: $e'),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isSigningIn = false;
      });
    }
  }
},
            width: double.infinity,
          ),
          const SizedBox(height: 10),
          SocialButton(
            text: 'Log in with Microsoft',
            icon: FontAwesomeIcons.microsoft,
            onPressed: (){},
            width: double.infinity,
          ),
          const SizedBox(height: 10),
          SocialButton(
            text: 'Log in with Facebook',
            icon: Icons.facebook_outlined,
            color: Colors.blue,
             onPressed: () async {
                try {
                  final userCredential = await _authService.signInWithFacebook();
                  if (userCredential != null) {
                    // Navigate to home screen on successful login
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreen(),
                    //   ),
                    // );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            width: double.infinity,
          ),
          const SizedBox(height: 10),
          SocialButton(
            text: 'Log in with Apple',
            icon: Icons.apple,
            color: Colors.black,
            onPressed: () {},
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLoginButton() {
    return SecondaryButton(
      text: 'Login with Mobile Number',
      onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const PhoneVerificationScreen(),)),
    );
  }
}