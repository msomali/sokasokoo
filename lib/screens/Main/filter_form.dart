import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';

class FilterForm extends StatefulWidget {
  const FilterForm({Key? key}) : super(key: key);

  @override
  _FilterFormState createState() => _FilterFormState();
}

const positions = [
  'GOALKEEPER',
  'CENTER BACK',
  'RIGHT BACK',
  'LEFT BACK',
  'WING BACK',
  'OFFENSIVE MIDFIELD',
  'DEFENSIVE MIDFIELD',
  'STRIKER',
  'WINGER'
];

class _FilterFormState extends State<FilterForm> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  FormGroup buildForm() => fb.group({
        'gender': FormControl(value: ''),
        'position': FormControl(value: ''),
        'height': FormControl(value: ''),
        'region': FormControl(value: ''),
        'district': FormControl(value: ''),
        'education_level': FormControl(value: ''),
        'ward': FormControl(value: ''),
        'foot': FormControl(value: ''),
        'dob': fb.group({
          '\$lte': FormControl<DateTime>(
            value: null,
          ),
        })
      });

  void onSubmit(filters) async {
    Provider.of<UserProvider>(context, listen: false).setLoading(true);
    try {
      var data = await Api().getUser(filters);
      Provider.of<UserProvider>(context, listen: false).setUsers(data);
      Navigator.of(context).pop();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error occured on Filter',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      Provider.of<UserProvider>(context, listen: false).setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loading = Provider.of<UserProvider>(context, listen: true).isLoading;
    var regions = Provider.of<UserProvider>(context, listen: true).regions;
    var districts = Provider.of<UserProvider>(context, listen: true).districts;
    var wards = Provider.of<UserProvider>(context, listen: true).wards;
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
                  ReactiveDropdownField(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                      formControlName: 'gender',
                      items: <String>['FEMALE', 'MALE']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  ReactiveDropdownField(
                      decoration: const InputDecoration(
                        labelText: 'Education Level',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                      formControlName: 'education_level',
                      items: <String>[
                        'Primary',
                        'Secondary',
                        'Diploma',
                        'Degree',
                        'Masters'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  ReactiveDropdownField(
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                      formControlName: 'position',
                      items: positions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  ReactiveDropdownField(
                      decoration: const InputDecoration(
                        labelText: 'Preferred Foot',
                        border: OutlineInputBorder(),
                        helperText: '',
                        hintText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                      formControlName: 'foot',
                      items: <String>['RIGHT', 'LEFT', 'BOTH']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                  ReactiveTextField<String>(
                    formControlName: 'height',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Height',
                      helperText: '',
                      border: OutlineInputBorder(),
                      hintText: '180 cm',
                      helperStyle: TextStyle(height: 0.7),
                      errorStyle: TextStyle(height: 0.7),
                    ),
                  ),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'region',
                    mode: Mode.DIALOG,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: regions,
                    label: 'Region',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Regions',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'district',
                    mode: Mode.DIALOG,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: districts,
                    label: 'District',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'District',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ReactiveDropdownSearch<String>(
                    formControlName: 'ward',
                    mode: Mode.DIALOG,
                    decoration: const InputDecoration(
                      helperText: '',
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    maxHeight: 300,
                    items: wards,
                    label: 'Ward',
                    showSearchBox: true,
                    popupTitle: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Ward',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    popupShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  // ReactiveDatePicker<DateTime>(
                  //   formControlName: 'dob.\$gte',
                  //   firstDate: DateTime(1985),
                  //   lastDate: DateTime(2022),
                  //   initialDatePickerMode: DatePickerMode.year,
                  //   builder: (context, picker, child) {
                  //     Widget suffix = InkWell(
                  //       onTap: () {
                  //         _focusNode.unfocus();
                  //         _focusNode.canRequestFocus = false;

                  //         picker.control.value = null;

                  //         Future.delayed(const Duration(milliseconds: 100), () {
                  //           _focusNode.canRequestFocus = true;
                  //         });
                  //       },
                  //       child: const Icon(Icons.clear),
                  //     );

                  //     if (picker.value == null) {
                  //       suffix = const Icon(Icons.calendar_today);
                  //     }

                  //     return ReactiveTextField(
                  //       onTap: () {
                  //         if (_focusNode.canRequestFocus) {
                  //           _focusNode.unfocus();
                  //           picker.showPicker();
                  //         }
                  //       },
                  //       valueAccessor: DateTimeValueAccessor(
                  //         dateTimeFormat: DateFormat('dd MMM yyyy'),
                  //       ),
                  //       focusNode: _focusNode,
                  //       formControlName: 'dob.\$gte',
                  //       readOnly: true,
                  //       decoration: InputDecoration(
                  //         labelText: 'Start Range',
                  //         border: const OutlineInputBorder(),
                  //         suffixIcon: suffix,
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  ReactiveDatePicker<DateTime>(
                    formControlName: 'dob.\$lte',
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
                          dateTimeFormat: DateFormat('yyyy'),
                        ),
                        focusNode: _focusNode,
                        formControlName: 'dob.\$lte',
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Dob',
                          border: const OutlineInputBorder(),
                          suffixIcon: suffix,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Color(0xffFEFEFF),
                            )
                          : Text(
                              'Submit'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, letterSpacing: 2),
                            ),
                      onPressed: () {
                        if (form.valid) {
                          var data = {...form.value, 'type': 'PLAYER'};

                          form.value.forEach((k, v) {
                            if (v == '') {
                              data.remove(k);
                            }
                          });

                          var checkDob = form.control('dob.\$lte').value;

                          if (checkDob == null) {
                            data.remove('dob');
                          }

                          onSubmit(data);
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
      )),
    );
  }
}
