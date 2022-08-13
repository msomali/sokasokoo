import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';

class AddAgent extends StatefulWidget {
  const AddAgent({Key? key}) : super(key: key);

  @override
  _AddAgentState createState() => _AddAgentState();
}

class _AddAgentState extends State<AddAgent> {
  var isLoading = false;
  FormGroup buildForm() => fb.group(<String, Object>{
        'name': ['', Validators.required],
        'phone': [''],
      });

  void onSubmit(payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      await Api().createAgent(payload);
      Fluttertoast.showToast(
          msg: 'Agent added succesfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
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

  @override
  Widget build(BuildContext context) {
    var userId = Provider.of<UserProvider>(context, listen: true).currentUser;
    return Scaffold(
      appBar: AppBar(),
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
                        formControlName: 'name',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The Agent name is required',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Agent Name',
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
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Agent phone number',
                          helperText: '',
                          border: OutlineInputBorder(),
                          hintText: '0756909012',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(180, 50),
                              padding: const EdgeInsets.all(8),
                              textStyle: const TextStyle(
                                  color: Color(0xFFFFFEFE),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              enableFeedback: true),
                          onPressed: () async {
                            if (form.valid) {
                              var formValues = {
                                ...form.value,
                                'associatedBy': userId.sId
                              };
                              onSubmit(formValues);
                            } else {
                              form.markAllAsTouched();
                            }
                          },
                          child: isLoading == true
                              ? const CircularProgressIndicator(
                                  color: Colors.white70,
                                )
                              : Text(
                                  'Submit'.toUpperCase(),
                                  style: const TextStyle(fontSize: 18),
                                ))
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
