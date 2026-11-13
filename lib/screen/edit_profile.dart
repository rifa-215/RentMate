import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  String profileImage = '';
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    final user = UserData.currentUser;

    nameController.text = user?['name'] ?? '';
    emailController.text = user?['email'] ?? '';
    phoneController.text = user?['phone'] ?? '';
    addressController.text = user?['address'] ?? '';
    profileImage = user?['profileImage'] ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        profileImage = image.path;
      });
    }
  }

  void saveProfile() {
    final user = UserData.currentUser;

    if (user == null) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    final newPassword = passwordController.text.isEmpty
        ? user['password'] ?? ''
        : passwordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty) {
      showMessage('Please complete all information.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showMessage('Please enter a valid email address.');
      return;
    }

    if (newPassword.length < 6) {
      showMessage('Password must be at least 6 characters.');
      return;
    }

    final success = UserData.updateProfile(
      name: name,
      email: email,
      phone: phone,
      address: address,
      password: newPassword,
      profileImage: profileImage,
    );

    if (!success) {
      showMessage('This email is already registered.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFFFF3E8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE PHOTO
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFFFFF3E8),
                        backgroundImage: profileImage.isNotEmpty
                            ? FileImage(File(profileImage))
                            : null,
                        child: profileImage.isEmpty
                            ? const Icon(Icons.person, size: 65, color: orange)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: const BoxDecoration(
                              color: orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: pickProfileImage,
                    child: const Text(
                      'Change Profile Photo',
                      style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // PERSONAL INFORMATION
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),

            const SizedBox(height: 18),

            buildTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: nameController,
            ),

            const SizedBox(height: 18),

            buildTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 18),

            buildTextField(
              label: 'Phone Number',
              hint: 'Enter your phone number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 18),

            buildTextField(
              label: 'Address',
              hint: 'Enter your address',
              controller: addressController,
            ),

            const SizedBox(height: 25),

            // PASSWORD
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: black,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Leave blank if you do not want to change your password.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 15),

            buildTextField(
              label: 'New Password',
              hint: 'Enter new password',
              controller: passwordController,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
