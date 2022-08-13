import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/edit_contact_info.dart';

class EditIndividualSponsorProfile extends StatefulWidget {
  const EditIndividualSponsorProfile({Key? key, required this.user})
      : super(key: key);
  final User user;

  @override
  _EditIndividualSponsorProfileState createState() =>
      _EditIndividualSponsorProfileState();
}

class _EditIndividualSponsorProfileState
    extends State<EditIndividualSponsorProfile> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        'firstName': [widget.user.firstName ?? ''],
        'lastName': [widget.user.lastName ?? ''],
        'gender': FormControl(
            value: widget.user.gender ?? '', validators: [Validators.required]),
        'phone': FormControl<String>(
          value: widget.user.phone ?? '',
          validators: [
            Validators.required,
            Validators.minLength(10),
            Validators.maxLength(10)
          ],
        ),
        'nationality': [widget.user.nationality ?? '', Validators.required],
        'region': [widget.user.region ?? '', Validators.required],
        'district': [widget.user.district ?? '', Validators.required],
        'ward': [widget.user.ward ?? '', Validators.required],
        'street': [widget.user.street ?? ''],
      });

  void onSubmit(id, payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      var user = await Api().editProfile(id, payload);
      Provider.of<UserProvider>(context, listen: false)
          .setUser(User.fromJson(user));
      Fluttertoast.showToast(
          msg: 'Profile Edited succesfully',
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
    var regions = Provider.of<UserProvider>(context, listen: true).regions;
    var districts = Provider.of<UserProvider>(context, listen: true).districts;
    var wards = Provider.of<UserProvider>(context, listen: true).wards;

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
                        formControlName: 'firstName',
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'First name',
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
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'lastName',
                          helperText: '',
                          border: OutlineInputBorder(),
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
                      const SizedBox(
                        height: 16,
                      ),
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
                      const SizedBox(
                        height: 16,
                      ),
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
                          items: <String>['Tanzanian', 'Kenyan']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      const SizedBox(
                        height: 16,
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
                              };
                              onSubmit(userId.sId, formValues);
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
                                )),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 60),
                              padding: const EdgeInsets.all(2),
                              textStyle: const TextStyle(
                                  color: Color(0xFFFFFEFE),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              enableFeedback: true),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditContactInfo(
                                        user: widget.user,
                                        id: widget.user.sId,
                                      )),
                            );
                          },
                          child: const Text(
                            'EDIT CONTACT INFORMATION',
                            style: TextStyle(fontSize: 16),
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
