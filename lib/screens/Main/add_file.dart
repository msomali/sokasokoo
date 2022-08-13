import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_image_picker/image_file.dart';
import 'package:reactive_image_picker/reactive_image_picker.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';

class AddFile extends StatefulWidget {
  const AddFile({Key? key}) : super(key: key);

  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  var isLoading = false;
  FormGroup buildForm() => fb.group(<String, Object>{
        'title': ['', Validators.required],
        'description': [''],
        'type': ['Link', Validators.required],
        'content': FormControl<ImageFile>(),
        'url': ['']
      });

  void onSubmit(payload) async {
    setState(() {
      isLoading = true;
    });
    FormData formData = FormData.fromMap({
      ...payload,
      'url': payload['content'] != null
          ? await MultipartFile.fromFile(payload['content'].image.path)
          : payload['url']
    });

    try {
      await Api().uploadFile(formData);
      Fluttertoast.showToast(
          msg: 'File uploaded succesfully',
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
    var fileType = Provider.of<UserProvider>(context, listen: true).fileType;
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
                        formControlName: 'title',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'The Content title is required',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          helperText: '',
                          hintText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ReactiveTextField<String>(
                        formControlName: 'description',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Content Description',
                          helperText: '',
                          border: OutlineInputBorder(),
                          hintText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ReactiveDropdownField(
                          decoration: const InputDecoration(
                            labelText: 'File Type',
                            border: OutlineInputBorder(),
                            helperText: '',
                            hintText: '',
                            helperStyle: TextStyle(height: 0.7),
                            errorStyle: TextStyle(height: 0.7),
                          ),
                          onChanged: (value) {
                            Provider.of<UserProvider>(context, listen: false)
                                .setUserFileType(value);
                          },
                          formControlName: 'type',
                          items: <String>['Image', 'Link']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      const SizedBox(
                        height: 16,
                      ),
                      fileType == 'Link'
                          ? ReactiveTextField<String>(
                              formControlName: 'url',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Youtube Link',
                                helperText: '',
                                border: OutlineInputBorder(),
                                hintText: '',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ),
                            )
                          : ReactiveImagePicker(
                              formControlName: 'content',
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Image',
                                  filled: false,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  helperText: ''),
                              inputBuilder: (onPressed) => TextButton.icon(
                                onPressed: onPressed,
                                icon: const Icon(Icons.add),
                                label: const Text('Add a File'),
                              ),
                            ),
                      const SizedBox(height: 16.0),
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
                                'createdBy': userId.sId
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
