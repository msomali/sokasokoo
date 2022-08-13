import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';

class FilterToolAcademy extends StatefulWidget {
  FilterToolAcademy({Key? key}) : super(key: key);

  @override
  _FilterToolState createState() => _FilterToolState();
}

class _FilterToolState extends State<FilterToolAcademy> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  FormGroup buildForm() => fb.group({
        'region': FormControl(value: ''),
        'district': FormControl(value: ''),
        'ward': FormControl(value: ''),
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
                          var data = {...form.value, 'type': 'ACADEMY'};

                          data.remove('dob');
                          form.value.forEach((k, v) {
                            if (v == '') {
                              data.remove(k);
                            }
                          });

                          print(data);
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
