import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/coach/form_two.dart';
import 'package:sokasokoo/screens/guardian/form_two.dart';
import 'package:sokasokoo/screens/sponsor/entity_sponsor_form_two.dart';

import '../../utils.dart';

class EntitySponsorFormOne extends StatefulWidget {
  final String type;
  final String sponsor_type;
  const EntitySponsorFormOne(
      {Key? key, required this.type, required this.sponsor_type})
      : super(key: key);

  @override
  _EntitySponsorFormOneState createState() => _EntitySponsorFormOneState();
}

final ButtonStyle mainButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    enableFeedback: true);

class _EntitySponsorFormOneState extends State<EntitySponsorFormOne> {
  late FocusNode _focusNode;
  var isLoading = false;

  FormGroup buildForm() => fb.group(<String, Object>{
        'entity_name': FormControl<String>(
          validators: [Validators.required],
        ),
        'phone': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(10),
            Validators.maxLength(10)
          ],
        ),
        'dob': FormControl<DateTime>(
            value: null, validators: [Validators.required]),
        'password': ['', Validators.required, Validators.minLength(4)],
        'confirmPassword': ''
      }, [
        Validators.mustMatch('password', 'confirmPassword')
      ]);

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                      formControlName: 'entity_name',
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The entity name is required',
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Entity name',
                        helperText: '',
                        border: OutlineInputBorder(),
                        hintText: 'JP Morgans',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'phone',
                      keyboardType: TextInputType.phone,
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The phone Number is required',
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        helperText: '',
                        border: OutlineInputBorder(),
                        hintText: '0678891720',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveDatePicker<DateTime>(
                      formControlName: 'dob',
                      firstDate: DateTime(1985),
                      lastDate: DateTime(2022),
                      initialDatePickerMode: DatePickerMode.year,
                      builder: (context, picker, child) {
                        Widget suffix = InkWell(
                          onTap: () {
                            _focusNode.unfocus();
                            _focusNode.canRequestFocus = false;

                            picker.control.value = null;

                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              _focusNode.canRequestFocus = true;
                            });
                          },
                          child: const Icon(Icons.clear),
                        );

                        if (picker.value == null) {
                          suffix = const Icon(Icons.calendar_today);
                        }

                        return ReactiveTextField(
                          onTap: () {
                            if (_focusNode.canRequestFocus) {
                              _focusNode.unfocus();
                              picker.showPicker();
                            }
                          },
                          valueAccessor: DateTimeValueAccessor(
                            dateTimeFormat: DateFormat('dd MMM yyyy'),
                          ),
                          focusNode: _focusNode,
                          formControlName: 'dob',
                          validationMessages: (control) => {
                            ValidationMessage.any:
                                'Age must be greater than 18',
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: const OutlineInputBorder(),
                            suffixIcon: suffix,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ReactiveTextField<String>(
                      formControlName: 'password',
                      obscureText: true,
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The password must not be empty',
                        ValidationMessage.minLength:
                            'The password must be at least 6 characters',
                      },
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        helperText: '',
                        border: OutlineInputBorder(),
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'confirmPassword',
                      obscureText: true,
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The password must not be empty',
                        ValidationMessage.minLength:
                            'The password must be at least 6 characters',
                        ValidationMessage.mustMatch:
                            'The Password does not match'
                      },
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        helperText: '',
                        border: OutlineInputBorder(),
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () async {
                          if (form.valid) {
                            setState(() {
                              isLoading = true;
                            });
                            var data = form.control('dob').value.toString();
                            var formValues = {
                              ...form.value,
                              'dob': data,
                              'type': widget.type,
                              'sponsor_type': widget.sponsor_type,
                              'firstName': form.control('entity_name').value,
                              'lastName': form.control('entity_name').value,
                            };
                            formValues.remove('confirmPassword');
                            var payload = json.encode(formValues);
                            try {
                              var response = await Api().createUser(payload);
                              var id = response['_id'];
                              var accountNumber = response['accountNumber'];
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCurrentId(id);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntitySponsorFormTwo(
                                          id: id,
                                          playerId: accountNumber,
                                        )),
                              );
                            } on DioError catch (e) {
                              Fluttertoast.showToast(
                                  msg: e.response!.data['message'],
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
                          } else {
                            form.markAllAsTouched();
                          }
                        },
                        child: isLoading == true
                            ? const CircularProgressIndicator(
                                color: Colors.white70,
                              )
                            : const Text('Sign Up')),
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
