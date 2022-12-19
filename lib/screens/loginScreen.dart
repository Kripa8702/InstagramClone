import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/signupScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textInputField.dart';
import 'package:sizer/sizer.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsiveLayout.dart';
import '../responsive/webScreenLayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  loginUser() async {
    setState(() {
      loading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    print(res);

    setState(() {
      loading = false;
    });

    if (res != "success") {
      showSnackBar(res, context);
    }
    else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            flex: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Flexible(
                    //   child: Container(),
                    //   flex: 2,
                    // ),
                    SizedBox(
                      height: 25.h,
                    ),
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      color: primaryColor,
                      height: 8.7.h,
                    ),
                    SizedBox(
                      height: 6.6.h,
                    ),

                    TextInputField(
                      hintText: 'Enter your email',
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextInputField(
                      hintText: 'Enter your password',
                      textEditingController: _passwordController,
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),

                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: loginUser,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: blueColor,
                        ),
                        child: loading
                            ? Container(
                                height: 2.2.h,
                                width: 2.2.h,
                                child: const CircularProgressIndicator(
                                  color: primaryColor,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text('Log In'),
                      ),
                    ),

                    // Flexible(
                    //   child: Container(),
                    //   flex: 2,
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'Dont have an account?',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    ' Signup.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
