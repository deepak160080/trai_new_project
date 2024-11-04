// sms_listener.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trai_new_ui/auth/auth_services.dart';
import 'package:trai_new_ui/home_page.dart';

class SmsListener {
  static const platform = MethodChannel('com.example.trai_ui/sms');
  
  Future<void> startListening(Function(String) onCodeReceived) async {
    try {
      platform.setMethodCallHandler((call) async {
        if (call.method == 'onSmsReceived') {
          final message = call.arguments as String;
          final code = extractCode(message);
          if (code != null) {
            onCodeReceived(code);
          }
        }
      });
      await platform.invokeMethod('startListening');
    } on PlatformException catch (e) {
      print('Error starting SMS listener: $e');
    }
  }

  String? extractCode(String message) {
    // Customize this regex based on your OTP SMS format
    final regex = RegExp(r'\b(\d{6})\b');
    final match = regex.firstMatch(message);
    return match?.group(1);
  }

  Future<void> stopListening() async {
    try {
      await platform.invokeMethod('stopListening');
    } on PlatformException catch (e) {
      print('Error stopping SMS listener: $e');
    }
  }
}


class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  _PhoneVerificationScreenState createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (index) => FocusNode());
  final AuthServices _authServices = AuthServices();
  final SmsListener _smsListener = SmsListener();
  
  String? _verificationId;
  bool _isLoading = false;
  bool _codeSent = false;
  String _selectedCountryCode = '+1';

  @override
  void initState() {
    super.initState();
    _setupOtpAutoFill();
  }

  void _setupOtpAutoFill() {
    _smsListener.startListening((code) {
      if (code.length == 6) {
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = code[i];
          if (i < 5) {
            _focusNodes[i + 1].requestFocus();
          }
        }
        _verifyOTP();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your phone number',
             
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Country code dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    underline: Container(),
                    items: ['+1', '+91', '+44', '+81'].map((code) {
                      return DropdownMenuItem(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCountryCode = value!);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                     
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOTP,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send OTP', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    if (_phoneController.text.isEmpty) {
      _showSnackBar('Please enter a phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phoneNumber = '$_selectedCountryCode${_phoneController.text}';
      await _authServices.verifyPhone(
        phoneNumber: phoneNumber,
        onCodeSent: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
            _isLoading = false;
            _codeSent = true;
          });
          _showOtpBottomSheet();
        },
        onError: (String error) {
          setState(() => _isLoading = false);
          _showSnackBar(error);
        },
        onVerified: (PhoneAuthCredential credential) async {
          try {
            await _authServices.signInWithCredential(credential);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } catch (e) {
            _showSnackBar('Error during verification: $e');
          }
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error sending OTP: $e');
    }
  }

  void _showOtpBottomSheet() {
    if (!_codeSent) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter the 6-digit code sent to ${_phoneController.text}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 50,
                      child: CustomOtpInput(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        nextFocusNode: index < 5 ? _focusNodes[index + 1] : null,
                        previousFocusNode: index > 0 ? _focusNodes[index - 1] : null,
                        onComplete: index == 5 ? _verifyOTP : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Verify', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _verifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    try {
      final credential = await _authServices.verifyOTPAndLogin(
        _verificationId!,
        otp,
      );

      if (credential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      _showSnackBar('Invalid OTP. Please try again.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _smsListener.stopListening();
    super.dispose();
  }
}

// custom_otp_input.dart
class CustomOtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;
  final Function? onComplete;

  const CustomOtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.previousFocusNode,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLength: 1,
      decoration: InputDecoration(
        counterText: "",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      onChanged: (value) {
        if (value.length == 1 && nextFocusNode != null) {
          nextFocusNode!.requestFocus();
        } else if (value.isEmpty && previousFocusNode != null) {
          previousFocusNode!.requestFocus();
        } else if (value.length == 1 && onComplete != null) {
          onComplete!();
        }
      },
    );
  }
}