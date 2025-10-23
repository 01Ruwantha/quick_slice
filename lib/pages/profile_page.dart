import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quick_slice/sevices/auth_services.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthServices authServices = AuthServices();
  Uint8List? profileImage; // Store avatar image

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Load profile picture from Hive
  void _loadProfileImage() {
    final box = Hive.box('profile'); // ✅ changed from 'userBox' to 'profile'
    final storedImage = box.get('profileImage');
    if (storedImage != null) {
      setState(() {
        profileImage = Uint8List.fromList(List<int>.from(storedImage));
      });
    }
  }

  // Pick image from gallery and save
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final box = Hive.box('profile'); // ✅ keep consistent
      await box.put('profileImage', bytes);
      setState(() {
        profileImage = bytes;
      });
    }
  }

  void signOutUser(BuildContext context) {
    authServices.signOut(context);
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "Ready to leave?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Stay"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          signOutUser(context);
                        },
                        child: const Text("Log Out"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'phone': prefs.getString('phone'),
      'email': prefs.getString('email'),
      'role': prefs.getString('role'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Profile', textSize: 35),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found.'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Profile Avatar
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(
                        4,
                      ), // thickness of the gradient border
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF9A825), // vibrant orange/yellow
                            Color(0xFFE65100), // deep orange/red
                            Color(0xFF880E4F), // rich deep red/purple
                          ],
                          stops: [0.0, 0.5, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            Colors.white, // inner background (optional)
                        backgroundImage: profileImage != null
                            ? MemoryImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? Text(
                                (user['name'] != null &&
                                        user['name']!.isNotEmpty)
                                    ? user['name']![0].toUpperCase()
                                    : "?",
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Name
                  Text(
                    user['name'] ?? 'Guest User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Role
                  Text(
                    user['role'] ?? 'No role',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  // User details card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.phone,
                            user['phone'] ?? 'No phone',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.email,
                            user['email'] ?? 'No email',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sign Out Button
                  CustomButton(
                    onTap: () => _showLogoutConfirmationDialog(context),
                    text: 'Log Out',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
