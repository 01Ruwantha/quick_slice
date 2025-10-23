import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_slice/router/router_names.dart';
import 'package:quick_slice/sevices/auth_services.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  bool _isDeveloperExpanded = false;
  final AuthServices authServices = AuthServices();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  void signOutUser(BuildContext context) {
    authServices.signOut(context);
  }

  final Uri _url = Uri.parse('https://github.com/01Ruwantha/quick_slice');

  Future<void> _launchGitHubURL() async {
    try {
      final bool launched = await launchUrl(
        _url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showGitHubFallbackDialog();
      }
    } catch (e) {
      debugPrint("💔 Launch failed: $e");
      _showGitHubFallbackDialog();
    }
  }

  void _showGitHubFallbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Open GitHub"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Please open your browser and visit:"),
              SizedBox(height: 10),
              SelectableText(
                "https://github.com/01Ruwantha/quick_slice",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text("Or tap below to copy the link."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _copyToClipboard("https://github.com/01Ruwantha/quick_slice");
                _showSuccessSnackBar('GitHub link copied to clipboard!');
              },
              child: const Text("Copy Link"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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

  // 📧 Show dialog for email + optional attachment
  void _showEmailDialog() {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Contact Developer"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Send a message to the developer:",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Type your message here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (_selectedImage != null)
                      Column(
                        children: [
                          Image.file(File(_selectedImage!.path), height: 120),
                          const SizedBox(height: 5),
                          TextButton.icon(
                            onPressed: () {
                              setStateDialog(() => _selectedImage = null);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              "Remove Attachment",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    TextButton.icon(
                      onPressed: () async {
                        final XFile? picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          setStateDialog(() => _selectedImage = picked);
                        }
                      },
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Attach Screenshot"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text("Send"),
                  onPressed: () {
                    context.pop();
                    _launchEmail(messageController.text.trim(), _selectedImage);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _launchEmail(String message, XFile? attachment) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '01ruwantha@gmail.com',
      queryParameters: {
        'subject': 'QuickSlice App Feedback',
        'body':
            (message.isEmpty
                ? 'Hello Ruwantha,\n\nI wanted to share my feedback about QuickSlice...'
                : message) +
            (attachment != null ? '\n\n(Attached: ${attachment.name})' : ''),
      },
    );

    try {
      if (!await launchUrl(emailUri)) {
        _showErrorSnackBar('Could not open email app.');
      }
    } catch (e) {
      debugPrint("💔 Email launch failed: $e");
      _showErrorSnackBar('Could not open email app.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
              child: const Center(
                child: AppBarTitle(text: 'QuickSlice', textSize: 35),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.shopping_cart_rounded, size: 30),
              title: const Text("Cart Page"),
              onTap: () => context.pushNamed(RouterNames.cart),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.favorite, size: 30),
              title: const Text("Favorite Page"),
              onTap: () => context.pushNamed(RouterNames.favourite),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.person, size: 30),
              title: const Text("Profile Page"),
              onTap: () => context.pushNamed(RouterNames.profile),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.policy_rounded, size: 30),
              title: Text("Policies"),
            ),
            ExpansionTile(
              leading: const Icon(Icons.developer_mode_rounded, size: 30),
              title: const Text("Developer Details"),
              onExpansionChanged: (expanded) {
                setState(() => _isDeveloperExpanded = expanded);
              },
              trailing: Icon(
                _isDeveloperExpanded ? Icons.expand_less : Icons.expand_more,
                size: 30,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildDeveloperItem(
                        icon: Icons.info_outline_rounded,
                        title: "App Info",
                        subtitle: "Version 1.0.0",
                        onTap: () {},
                      ),
                      _buildDeveloperItem(
                        icon: Icons.code_rounded,
                        title: "Technology",
                        subtitle: "Flutter • Dart • Firebase",
                        onTap: () {},
                      ),
                      _buildDeveloperItem(
                        icon: Icons.person_pin,
                        title: "Developer",
                        subtitle: "Ruwantha Madhushan",
                        onTap: () {},
                      ),
                      _buildDeveloperItem(
                        icon: Icons.email_rounded,
                        title: "Contact",
                        subtitle: "01ruwantha@gmail.com",
                        onTap: _showEmailDialog,
                      ),
                      _buildDeveloperItem(
                        icon: Icons.open_in_browser_rounded,
                        title: "GitHub Repository",
                        subtitle: "Open in browser",
                        onTap: _launchGitHubURL,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout_rounded, size: 30),
              title: const Text("Log Out"),
              onTap: () => _showLogoutConfirmationDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
    );
  }
}
