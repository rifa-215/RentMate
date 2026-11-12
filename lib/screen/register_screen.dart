import 'package:flutter/material.dart';

import 'user_data.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: orange),
          suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: orange, width: 1.5),
          ),
        ),
      ),
    );
  }

  void registerAccount() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match.')));
      return;
    }

    final success = UserData.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is already registered.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Register to start using RentMate.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),

              buildField(
                label: 'Full Name',
                controller: nameController,
                icon: Icons.person_outline,
              ),
              buildField(
                label: 'Email Address',
                controller: emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              buildField(
                label: 'Phone Number',
                controller: phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              buildField(
                label: 'Address',
                controller: addressController,
                icon: Icons.location_on_outlined,
              ),
              buildField(
                label: 'Password',
                controller: passwordController,
                icon: Icons.lock_outline,
                obscure: obscurePassword,
                suffix: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              buildField(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                icon: Icons.lock_outline,
                obscure: obscureConfirmPassword,
                suffix: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: registerAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
