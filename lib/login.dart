// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:poultry_classify/backend.dart';
import 'package:poultry_classify/constants.dart';
import 'package:poultry_classify/in_app_notification.dart';
import 'package:poultry_classify/loader.dart';
import 'package:poultry_classify/widgets/input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCont = TextEditingController(text: 'prmpsmart@gmail.com');
  final passwordCont = TextEditingController(text: 'prmpsmart');

  final api = ApiService();

  bool isLoading = false;

  login(bool isNew) async {
    if (emailCont.text.isNotEmpty && passwordCont.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      try {
        final data = await api.login(
          email: emailCont.text,
          password: passwordCont.text,
          isNew: isNew,
        );
        final success = data['status'] == 200;
        InAppNotification.show(
          context,
          data['detail'],
          isError: !success,
        );
        if (success) Navigator.of(context).pushNamed('home');
      } catch (e) {
        InAppNotification.show(
          context,
          e.toString(),
          isError: true,
        );
      }
      setState(() {
        isLoading = false;
      });
    } else {
      InAppNotification.show(
        context,
        'Invalid email and/or password',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Container(
              padding: EdgeInsets.only(
                left: 40.w,
                right: 40.w,
              ),
              width: 1.sw,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/sign.png'),
                  20.verticalSpace,
                  Text(
                    'Poultry Birds Disease Classification',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.spMin,
                    ),
                  ),
                  40.verticalSpace,
                  Input(
                    controller: emailCont,
                    labelText: 'Email address',
                  ),
                  20.verticalSpace,
                  Input(
                    controller: passwordCont,
                    labelText: 'Password',
                    obscureText: true,
                  ),
                  40.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () => login(true),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        color: Colors.green,
                        child: SizedBox(
                          width: .3.sw,
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.spMin,
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => login(false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        color: primaryColor,
                        child: SizedBox(
                          width: .3.sw,
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.spMin,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
