import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_slice/router/router_names.dart';
import 'package:quick_slice/sevices/auth_services.dart';
import 'package:quick_slice/utils/utils.dart';
import 'package:quick_slice/widgets/app_bar_title.dart';
import 'package:quick_slice/widgets/custom_button.dart';
import 'package:quick_slice/widgets/text_form_field_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();
  final AuthServices authServices = AuthServices();

  bool _throwShotAway = false;

  void signupUser() {
    authServices.signUpUser(
      context: context,
      name: _nameController.text,
      phone: _phoneNumberController.text,
      email: _emailIdController.text,
      role: _roleController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = 20;
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(text: 'Create Account', textSize: 25),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _signUpFormKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Name',
                  controller: _nameController,
                  obscureText: false,
                ),
                SizedBox(height: height),
                Text(
                  'Phone number',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormFieldWidget(
                  hintText: 'Code',
                  controller: _phoneNumberController,
                  obscureText: false,
                ),
                SizedBox(height: height),
                Text('Email Id', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Email',
                  controller: _emailIdController,
                  obscureText: false,
                ),
                SizedBox(height: height),
                Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Role',
                  controller: _roleController,
                  obscureText: false,
                ),
                SizedBox(height: height),
                Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormFieldWidget(
                  hintText: 'Password',
                  controller: _passwordController,
                  obscureText: false,
                ),
                SizedBox(height: height),
                Text(
                  'Conform Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormFieldWidget(
                  hintText: 'Conform Password',
                  controller: _conformPasswordController,
                  obscureText: false,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _throwShotAway,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _throwShotAway = newValue!;
                          });
                        },
                      ),
                      Flexible(
                        child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                            style: TextStyle(
                              // default style
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: 'By signing up you agree to our '),
                              TextSpan(
                                text: 'conditions ',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              TextSpan(text: 'and '),
                              TextSpan(
                                text: 'privacy policy',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  onTap: () {
                    if (_signUpFormKey.currentState!.validate() &&
                        _throwShotAway == true) {
                      if (kDebugMode) {
                        print('✅✅✅press Sign Up✅✅✅');
                      }

                      if (_passwordController.text ==
                          _conformPasswordController.text) {
                        if (kDebugMode) {
                          print('✅✅✅ Password conform✅✅✅');
                        }
                        signupUser();

                        if (kDebugMode) {
                          print('✅✅✅ signupUser runed✅✅✅');
                        }
                      } else {
                        showSnackBar(
                          context,
                          'Password and Conform Password are not match',
                        );
                      }
                    }
                  },
                  text: 'Sign Up',
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
                      'or Sign in with',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.goNamed(RouterNames.signIn);
                      },
                      child: Text(
                        ' Sign in',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height),
                SizedBox(height: height),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
