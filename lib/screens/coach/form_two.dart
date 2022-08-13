import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/models/districts.dart';
import 'package:sokasokoo/models/wards.dart' as wards_features;
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/repositories/districts_repository.dart';
import 'package:sokasokoo/repositories/regions_repository.dart';
import 'package:sokasokoo/repositories/wards_repository.dart';
import 'package:sokasokoo/screens/Main/main_home.dart';
import 'package:sokasokoo/screens/coach/form_three.dart';

class CoachFormTwo extends StatefulWidget {
  CoachFormTwo({Key? key, required this.id, required this.playerId})
      : super(key: key);
  String id;
  String playerId;

  @override
  _CoachFormTwoState createState() => _CoachFormTwoState();
}

class _CoachFormTwoState extends State<CoachFormTwo> {
  late var regions = <String>[];
  late var districts = <Features>[];
  late var wards = <wards_features.Features>[];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future fetchData() async {
    try {
      List<dynamic> data = Future.wait([
        RegionRepository().fetchRegions(),
        DistrictsRepository().fetchDistricts(),
        WardsRepository().fetchWards()
      ]) as List;

      var payload = data[0];
      print('Payload $payload');
      return data;
    } catch (e) {
      rethrow;
    }
  }

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
        MaterialPageRoute(
            builder: (context) => CoachFromThree(
                  id: widget.id,
                )),
      );
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        'gender': ['', Validators.required],
        'nationality': ['', Validators.required],
        'region': ['', Validators.required],
        'district': ['', Validators.required],
        'ward': ['', Validators.required],
        'license_level': [''],
        'education_level': [''],
        'coach_registration': [''],
        'street': ['']
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: TextButton(
          //       onPressed: () {
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(builder: (context) => MainHome()),
          //         );
          //       },
          //       child: const Text(
          //         'SKIP',
          //         style: TextStyle(fontSize: 20, color: Colors.white),
          //       )),
          // )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder(
                future: Future.wait([
                  RegionRepository().fetchRegions(),
                  DistrictsRepository().fetchDistricts(),
                  WardsRepository().fetchWards()
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final data = snapshot.data as List;
                    regions = data[0];
                    districts = data[1];
                    wards = data[2];
                    return ReactiveFormBuilder(
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
                                items: <String>[
                                  'FEMALE',
                                  'MALE'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
                            ReactiveDropdownField(
                                decoration: const InputDecoration(
                                  labelText: 'Nationality',
                                  border: OutlineInputBorder(),
                                  helperText: '',
                                  hintText: '',
                                  helperStyle: TextStyle(height: 0.7),
                                  errorStyle: TextStyle(height: 0.7),
                                ),
                                formControlName: 'nationality',
                                items: <String>[
                                  'Tanzanian',
                                  'Kenyan'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
                            ReactiveDropdownSearch<String>(
                              formControlName: 'region',
                              mode: Mode.DIALOG,
                              decoration: const InputDecoration(
                                helperText: '',
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              maxHeight: 300,
                              items: data[0],
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
                            ReactiveDropdownSearch<String>(
                              formControlName: 'district',
                              mode: Mode.DIALOG,
                              decoration: const InputDecoration(
                                helperText: '',
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              maxHeight: 300,
                              items: districts.map((e) {
                                return e.district.toString();
                              }).toList(),
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
                            ReactiveDropdownSearch<String>(
                              formControlName: 'ward',
                              mode: Mode.DIALOG,
                              decoration: const InputDecoration(
                                helperText: '',
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              maxHeight: 300,
                              items: wards.map((e) {
                                return e.ward.toString();
                              }).toList(),
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
                            const SizedBox(height: 16.0),
                            ReactiveTextField<String>(
                              formControlName: 'street',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Street',
                                helperText: '',
                                border: OutlineInputBorder(),
                                hintText: 'Mtaa/Street',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ),
                            ),
                            const SizedBox(height: 16.0),
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
                                  'Masters',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
                            const SizedBox(height: 16.0),
                            ReactiveDropdownField(
                                decoration: const InputDecoration(
                                  labelText: 'License Level',
                                  border: OutlineInputBorder(),
                                  helperText: '',
                                  hintText: '',
                                  helperStyle: TextStyle(height: 0.7),
                                  errorStyle: TextStyle(height: 0.7),
                                ),
                                formControlName: 'license_level',
                                items: <String>[
                                  'Preliminary',
                                  'Intermediate',
                                  'Advanced'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
                            ReactiveTextField<String>(
                              formControlName: 'coach_registration',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Registration Number',
                                helperText: '',
                                border: OutlineInputBorder(),
                                hintText: 'XXX-XXX-XX',
                                helperStyle: TextStyle(height: 0.7),
                                errorStyle: TextStyle(height: 0.7),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                child: Text(
                                  'Submit'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 20, letterSpacing: 2),
                                ),
                                onPressed: () {
                                  if (form.valid) {
                                    onSubmit(form.value);
                                  } else {
                                    form.markAllAsTouched();
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
        ),
      ),
    );
  }
}
