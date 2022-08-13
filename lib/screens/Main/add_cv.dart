import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/models/cv.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';

class AddCv extends StatefulWidget {
  AddCv({Key? key, this.cv, required this.type}) : super(key: key);
  Cv? cv;
  String type;

  @override
  _AddCvState createState() => _AddCvState();
}

final ButtonStyle mainButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    enableFeedback: true);

class _AddCvState extends State<AddCv> {
  late FocusNode _focusNode;
  var isLoading = false;
  var isChecked = true;
  List<String> options = ['Yanga Sc', 'Simba Fc'];

  FormGroup buildForm() => fb.group(<String, Object>{
        'name': [widget.cv?.name ?? '', Validators.required],
        'description': [''],
        'start_date': FormControl<DateTime>(
            value: null, validators: [Validators.required]),
        'end_date': FormControl<DateTime>(value: null),
        'isCurrent': FormControl<String>(
            value: widget.cv?.isCurrent ?? '',
            validators: [Validators.required]),
        'person': [widget.cv?.person ?? '', Validators.required],
        'type': [widget.cv?.type ?? '', Validators.required],
        'phone': FormControl<String>(
          value: widget.cv?.phone ?? '',
          validators: [
            Validators.required,
            Validators.minLength(10),
            Validators.maxLength(10)
          ],
        ),
      });

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
    getTeams();
  }

  Future getTeams() async {
    try {
      var data = await Api().getAllCvs();
      options.clear();
      setState(() {
        options = data;
      });
      return Future.value(data);
    } on DioError catch (e) {
      print(e);
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    return Colors.blue;
  }

  void onEditFormSubmit(data) async {
    try {
      await Api().editCv(widget.cv!.sId.toString(), data);
      Fluttertoast.showToast(
          msg: 'Cv Edited Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: 'Error editing information',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onFormSubmit(data) async {
    try {
      await Api().createCv(data);

      Fluttertoast.showToast(
          msg: 'Cv Submited Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: 'Error submitting information',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ReactiveFormBuilder(
              builder: (context, form, child) {
                return Column(
                  children: [
                    ReactiveTextField<String>(
                      formControlName: 'name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Team Name',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: 'Kagera Fc',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'person',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Team Contact Person',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ReactiveTextField<String>(
                      formControlName: 'phone',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person Number',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '255754-XXX-XXX',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ReactiveDropdownField(
                        decoration: const InputDecoration(
                          labelText: 'Contact Person Role',
                          border: OutlineInputBorder(),
                          helperText: '',
                          hintText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                        formControlName: 'type',
                        items: <String>['Manager', 'Coach']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                    ReactiveDatePicker<DateTime>(
                      formControlName: 'start_date',
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

                        if (widget.cv?.startDate != null) {
                          picker.control.value =
                              DateTime.tryParse(widget.cv!.startDate ?? '');
                        }

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
                          formControlName: 'start_date',
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            border: const OutlineInputBorder(),
                            suffixIcon: suffix,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ReactiveDropdownField(
                        decoration: const InputDecoration(
                          labelText: 'Is My Current Team',
                          border: OutlineInputBorder(),
                          helperText: '',
                          hintText: '',
                          helperStyle: TextStyle(height: 0.7),
                          errorStyle: TextStyle(height: 0.7),
                        ),
                        formControlName: 'isCurrent',
                        onChanged: (value) {
                          if (value == 'YES') {
                            form.control('end_date').markAsDisabled();
                          } else {
                            form.control('end_date').markAsEnabled();
                          }
                        },
                        items: <String>['YES', 'NO']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ReactiveDatePicker<DateTime>(
                      formControlName: 'end_date',
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

                        if (widget.cv?.endDate != null) {
                          picker.control.value =
                              DateTime.tryParse(widget.cv!.endDate ?? '');
                        }

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
                          formControlName: 'end_date',
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            border: const OutlineInputBorder(),
                            suffixIcon: suffix,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () async {
                          if (form.valid) {
                            var formValues = {
                              ...form.value,
                              'isCurrent':
                                  form.control('isCurrent').value == 'YES'
                                      ? true
                                      : false,
                              'start_date':
                                  form.control('start_date').value.toString(),
                              'end_date':
                                  form.control('end_date').value.toString(),
                              'createdBy': user.sId.toString()
                            };

                            if (widget.type == 'EDIT') {
                              onEditFormSubmit(formValues);
                            } else {
                              onFormSubmit(formValues);
                            }
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
              },
              form: buildForm),
        ),
      )),
    );
  }
}
