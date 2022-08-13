import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/agent/agent_form_two.dart';

class AgentFormOne extends StatefulWidget {
  const AgentFormOne({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  _AgentFormOneState createState() => _AgentFormOneState();
}

final ButtonStyle mainButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    enableFeedback: true);

class _AgentFormOneState extends State<AgentFormOne> {
  late FocusNode _focusNode;
  var isLoading = false;

  FormGroup buildForm() => fb.group(<String, Object>{
        'company_name': FormControl<String>(value: ''),
        'company_title': FormControl<String>(value: ''),
        'company_description': FormControl<String>(value: ''),
        'firstName': FormControl<String>(
          validators: [Validators.required],
        ),
        'lastName': FormControl<String>(
          validators: [Validators.required],
        ),
        'dob': FormControl<DateTime>(value: null),
        'phone': FormControl<String>(
          validators: [
            Validators.required,
            Validators.minLength(10),
            Validators.maxLength(10)
          ],
        ),
        'password': ['', Validators.required, Validators.minLength(4)],
        'confirmPassword': ''
      }, [
        Validators.mustMatch('password', 'confirmPassword')
      ]);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
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
        actions: const [],
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
                    formControlName: 'company_name',
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'The Company name is required',
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '',
                      helperStyle: TextStyle(height: 0.7),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveTextField<String>(
                    formControlName: 'company_title',
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'The Company title is required',
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Company Title',
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '',
                      helperStyle: TextStyle(height: 0.7),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveTextField<String>(
                    formControlName: 'company_description',
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Company Bio',
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '',
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

                          Future.delayed(const Duration(milliseconds: 100), () {
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
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Company Start Date',
                          border: const OutlineInputBorder(),
                          suffixIcon: suffix,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveTextField<String>(
                    formControlName: 'firstName',
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'Agent first name is required',
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Agent\'s First Name',
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '',
                      helperStyle: TextStyle(height: 0.7),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveTextField<String>(
                    formControlName: 'lastName',
                    validationMessages: (control) => {
                      ValidationMessage.required:
                          'Agent\'s last name is required',
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Agent\'s Last Name',
                      border: OutlineInputBorder(),
                      helperText: '',
                      hintText: '',
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
                      ValidationMessage.mustMatch: 'The Password does not match'
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

                          var dob = form.control('dob').value.toString();

                          var formValues = {
                            ...form.value,
                            'dob': dob,
                            'type': widget.type
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
                                  builder: (context) => AgentFormTwo(
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
                          ? const CircularProgressIndicator()
                          : const Text('Sign Up'))
                ],
              );
            },
          ),
        ),
      )),
    );
  }
}
