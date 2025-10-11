import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_slice/pages/auth_pages/sign_up.dart';
import 'package:quick_slice/pages/home_page.dart';
import 'package:quick_slice/sevices/auth_services.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/custom_button.dart';
import 'package:quick_slice/widgets/text_form_field_widget.dart';

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
  bool _throwShotAway = false;

  void loginUser() {
    authServices.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = 20;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(text: 'Sign In', textSize: 25),
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
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Email',
                  controller: _emailController,
                ),
                SizedBox(height: height),
                Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Password',
                  controller: _passwordController,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _throwShotAway,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _throwShotAway = newValue!;
                        });
                      },
                    ),
                    Text('Remember me'),
                    Spacer(),
                    Text(
                      'Fogot password?',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomButton(
                  onTap: () {
                    if (_signInFormKey.currentState!.validate() &&
                        _throwShotAway == true) {
                      if (kDebugMode) {
                        print('✅✅✅press Sign In✅✅✅');
                      }
                      loginUser();
                      if (kDebugMode) {
                        print('✅✅✅ loginUser runed ✅✅✅');
                      }
                    }
                  },
                  text: 'Sign In',
                ),
                SizedBox(height: height),
                Row(
                  children: [
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
                SizedBox(height: height),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap
                        },
                        child: Container(
                          height: 60, // Button height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              image: AssetImage('assets/images/google.png'),
                              fit: BoxFit.fitHeight, // Cover the whole button
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap
                        },
                        child: Container(
                          height: 60, // Button height
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              image: AssetImage('assets/images/apple.png'),
                              fit: BoxFit.fitHeight, // Cover the whole button
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height),
                CustomButton(
                  onTap: () {
                    if (kDebugMode) {
                      print('✅✅✅press Log In as Gest✅✅✅');
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                    if (kDebugMode) {
                      print('✅✅✅ Log In as Gest runed ✅✅✅');
                    }
                  },
                  text: 'Log In as Gest',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
