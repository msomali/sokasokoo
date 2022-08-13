import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/main_home.dart';

class AddPlayerFromThree extends StatefulWidget {
  const AddPlayerFromThree({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _PlayerFromThreeState createState() => _PlayerFromThreeState();
}

class _PlayerFromThreeState extends State<AddPlayerFromThree> {
  var isLoading = false;

  void onSubmit(value) async {
    setState(() {
      isLoading = true;
    });
    var payload = json.encode(value);
    try {
      await Api().updateUser(widget.id, payload);

      Fluttertoast.showToast(
          msg: 'Profile Information Submitted',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainHome()),
      );
    } catch (e) {
      print(e);
    }
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        'email': [''],
        'contact_number': [''],
        'facebook': [''],
        'youtube': [''],
        'instagram': [''],
        'twitter': [''],
        'linkedin': [''],
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: const [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ReactiveFormBuilder(
              form: buildForm,
              builder: (context, form, child) {
                return Column(
                  children: [
                    ReactiveTextField<String>(
                      formControlName: 'email',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: 'john@gmail.com',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'contact_number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '255678907867',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'facebook',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Facebook',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '@Juma John',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'youtube',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Youtube',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'instagram',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Instagram',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'twitter',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Twitter',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'linkedin',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Linkedin',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        child: Text(
                          'Submit'.toUpperCase(),
                          style:
                              const TextStyle(fontSize: 20, letterSpacing: 2),
                        ),
                        onPressed: () {
                          if (form.valid) {
                            print(form.value);
                            onSubmit(form.value);
                          } else {
                            form.markAllAsTouched();
                          }
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
