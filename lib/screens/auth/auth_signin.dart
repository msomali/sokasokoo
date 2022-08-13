import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/main_home.dart';
import 'package:sokasokoo/utils.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var isLoading = false;

  FormGroup buildForm() => fb.group(<String, Object>{
        'identifier': FormControl<String>(
          validators: [Validators.required],
        ),
        'password': ['', Validators.required],
      });

  final ButtonStyle mainButton = ElevatedButton.styleFrom(
      fixedSize: const Size(180, 50),
      padding: const EdgeInsets.all(8),
      textStyle: const TextStyle(
          color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
      enableFeedback: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/sign_in.jpg'),
                fit: BoxFit.cover)),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (BuildContext context, form, Widget? child) {
              return Column(
                children: [
                  ReactiveTextField<String>(
                    formControlName: 'identifier',
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'The phone or account number is required',
                    },
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Phone/Account Number',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '0645934523/TFH-P-000001',
                      helperStyle: TextStyle(height: 0.7, color: Colors.black),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: true,
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'The password must not be empty',
                    },
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      helperText: '',
                      border: OutlineInputBorder(),
                      helperStyle: TextStyle(height: 0.7, color: Colors.black),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () async {
                        if (form.valid) {
                          setState(() {
                            isLoading = true;
                          });
                          var payload = json.encode(form.value);
                          try {
                            var res = await Api().loginUser(payload);
                            print('Res $res');
                            print('Res Data ${res.data}');
                            if (res.data['suspend'] == true) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Account Has Been Suspended Contact Admin',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(User.fromJson(res.data));
                            var user = Provider.of<UserProvider>(context,
                                    listen: false)
                                .currentUser;
                            Fluttertoast.showToast(
                                msg:
                                    'Welcome ${user.type == 'ACADEMY' ? user.academyName : user.firstName} ${user.type == 'ACADEMY' ? '' : user.lastName}',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            SharedPrefs.setUser(res.data['_id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainHome()),
                            );
                          } on DioError catch (e) {
                            print(e.response!.statusCode);
                            Fluttertoast.showToast(
                                msg: 'Authentication failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      style: mainButton,
                      child: isLoading == true
                          ? const CircularProgressIndicator(
                              color: Colors.white70,
                            )
                          : Text('Submit'.toUpperCase()))
                ],
              );
            },
          ),
        )),
      ),
    );
  }
}
