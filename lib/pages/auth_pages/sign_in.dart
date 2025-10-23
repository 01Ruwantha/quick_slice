import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_slice/router/router_names.dart';
import 'package:quick_slice/sevices/auth_services.dart';
import 'package:quick_slice/sevices/google_auth.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/custom_button.dart';
import 'package:quick_slice/widgets/text_form_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServices authServices = AuthServices();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _googleLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      _googleLoading = true;
    });

    try {
      final userCredential = await GoogleSignInService.signInWithGoogle();

      if (userCredential != null && context.mounted) {
        context.goNamed(RouterNames.bottomNavigation);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed in with Google!'),
            backgroundColor: Colors.green,
          ),
        );

        if (kDebugMode) {
          print("User signed in: ${userCredential.user?.displayName}");
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-in was canceled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      if (kDebugMode) {
        print('Google Sign-In Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _googleLoading = false;
        });
      }
    }
  }

  void loginUser() {
    if (_signInFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      authServices
          .signInUser(
            context: context,
            email: _emailController.text,
            password: _passwordController.text,
          )
          .whenComplete(() {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
    }
  }

  void _loginAsGuest() async {
    if (kDebugMode) {
      print('Pressed Log In as Guest');
    }
    // Save guest status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    await prefs.setString(
      'x-auth-token',
      'guest-token-${DateTime.now().millisecondsSinceEpoch}',
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
    // );
    context.goNamed(RouterNames.bottomNavigation);
    if (kDebugMode) {
      print('Log In as Guest completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    const double height = 20;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(text: 'Sign In', textSize: 25),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _signInFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormFieldWidget(
                  hintText: 'Email',
                  controller: _emailController,
                  obscureText: false,
                ),
                const SizedBox(height: height),
                const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormFieldWidget(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _rememberMe = newValue ?? false;
                        });
                      },
                    ),
                    const Text('Remember me'),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onTap: () {
                          if (_signInFormKey.currentState!.validate()) {
                            loginUser();
                          }
                        },
                        text: 'Sign In',
                      ),
                const SizedBox(height: height),
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'or Sign up with',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: height),
                _googleLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text('Sign in with Google'),
                          ],
                        ),
                      ),
                const SizedBox(height: height),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => context.goNamed(RouterNames.signUp),
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: height),
                CustomButton(onTap: _loginAsGuest, text: 'Log In as Guest'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
