import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sokasokoo/models/cv.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/add_cv.dart';
import 'package:sokasokoo/utils.dart';

class MyCv extends StatefulWidget {
  MyCv({Key? key, this.id}) : super(key: key);

  String? id;

  @override
  _MyCvState createState() => _MyCvState();
}

class _MyCvState extends State<MyCv> {
  var items = [];
  var loading = false;

  @override
  void initState() {
    super.initState();
    fetchUserCvs();
  }

  void fetchUserCvs() async {
    setState(() {
      loading = true;
    });
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    var data = await Api().getUserCvs(widget.id ?? user.sId);
    if (mounted) {
      setState(() {
        items = data;
        loading = false;
      });
    }
  }

  Future<void> _showMyDialog(Cv data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () async {
                try {
                  await Api().deleteCv(data.sId);
                  Fluttertoast.showToast(
                      msg: 'Cv Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  fetchUserCvs();
                } on DioError catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Error deleting Cv',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } finally {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildCtn() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            color: Colors.grey[300],
            elevation: 8.0,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                height: 160,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${items[index].name}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        items[index].isCurrent == 'YES'
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Container()
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${items[index].person}-${items[index].type}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Start Date:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(Utils.getFormattedDate(items[index].startDate),
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                    items[index].isCurrent == 'NO'
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('End Date:',
                                  style: TextStyle(fontSize: 18)),
                              Text(Utils.getFormattedDate(items[index].endDate),
                                  style: const TextStyle(fontSize: 18))
                            ],
                          )
                        : const Text(
                            'Current Team',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                    widget.id == null
                        ? Row(
                            children: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddCv(
                                                cv: items[index],
                                                type: 'EDIT',
                                              )),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.green),
                                  ),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.green),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              OutlinedButton(
                                  onPressed: () async {
                                    _showMyDialog(items[index]);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        width: 1.0, color: Colors.red),
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          )
                        : Container()
                  ],
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    GlobalKey _refresherKey = GlobalKey();

    return Scaffold(
      floatingActionButton: widget.id == null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCv(type: 'CREATE')),
                );
              },
              icon: const Icon(Icons.post_add),
              label: Text('Create'.toUpperCase()),
            )
          : Container(),
      appBar: AppBar(),
      body: loading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              key: _refresherKey,
              controller: _refreshController,
              enablePullUp: true,
              child: buildCtn(),
              physics: const BouncingScrollPhysics(),
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 700),
              ),
              onRefresh: () async {
                fetchUserCvs();
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                fetchUserCvs();
                _refreshController.loadFailed();
              },
            ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   var user = Provider.of<UserProvider>(context, listen: true).currentUser;
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: const [],
  //     ),
  //     floatingActionButton: FloatingActionButton.extended(
  //       onPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => AddCv(
  //                     type: 'CREATE',
  //                   )),
  //         );
  //       },
  //       icon: const Icon(Icons.add_circle),
  //       label: Text('Create'.toUpperCase()),
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(
  //           flex: 1,
  //           child: FutureBuilder(
  //             future: Api().getUserCvs(user.sId),
  //             builder: (
  //               BuildContext context,
  //               snapshot,
  //             ) {
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Center(child: CircularProgressIndicator());
  //               } else if (snapshot.connectionState == ConnectionState.done) {
  //                 if (snapshot.hasError) {
  //                   return const Text('Error');
  //                 } else if (snapshot.hasData) {
  //                   var items = snapshot.data as List;
  //                   return ListView.builder(
  //                     itemCount: items.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Card(
  //                           color: Colors.grey[300],
  //                           elevation: 8.0,
  //                           child: Container(
  //                               padding: const EdgeInsets.symmetric(
  //                                   vertical: 10, horizontal: 16),
  //                               height: 160,
  //                               width: double.infinity,
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Row(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       Text(
  //                                         '${items[index].name}',
  //                                         style: const TextStyle(
  //                                             fontSize: 24,
  //                                             fontWeight: FontWeight.bold),
  //                                       ),
  //                                       items[index].isCurrent == 'YES'
  //                                           ? const Icon(
  //                                               Icons.check_circle,
  //                                               color: Colors.green,
  //                                             )
  //                                           : Container()
  //                                     ],
  //                                   ),
  //                                   const SizedBox(
  //                                     height: 16,
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       const Text(
  //                                         'Start Date:',
  //                                         style: TextStyle(fontSize: 18),
  //                                       ),
  //                                       Text(
  //                                           Utils.getFormattedDate(
  //                                               items[index].startDate),
  //                                           style:
  //                                               const TextStyle(fontSize: 18))
  //                                     ],
  //                                   ),
  //                                   items[index].isCurrent == 'NO'
  //                                       ? Row(
  //                                           crossAxisAlignment:
  //                                               CrossAxisAlignment.center,
  //                                           children: [
  //                                             const Text('End Date:',
  //                                                 style:
  //                                                     TextStyle(fontSize: 18)),
  //                                             Text(
  //                                                 Utils.getFormattedDate(
  //                                                     items[index].endDate),
  //                                                 style: const TextStyle(
  //                                                     fontSize: 18))
  //                                           ],
  //                                         )
  //                                       : const Text(
  //                                           'Current Team',
  //                                           style: TextStyle(
  //                                               fontSize: 15,
  //                                               fontWeight: FontWeight.w700),
  //                                         ),
  //                                   Row(
  //                                     children: [
  //                                       OutlinedButton(
  //                                           onPressed: () {
  //                                             Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                   builder: (context) => AddCv(
  //                                                         cv: items[index],
  //                                                         type: 'EDIT',
  //                                                       )),
  //                                             );
  //                                           },
  //                                           style: OutlinedButton.styleFrom(
  //                                             side: const BorderSide(
  //                                                 width: 1.0,
  //                                                 color: Colors.green),
  //                                           ),
  //                                           child: const Text(
  //                                             'Edit',
  //                                             style: TextStyle(
  //                                                 color: Colors.green),
  //                                           )),
  //                                       const SizedBox(
  //                                         width: 10,
  //                                       ),
  //                                       OutlinedButton(
  //                                           onPressed: () async {
  //                                             _showMyDialog(items[index]);
  //                                           },
  //                                           style: OutlinedButton.styleFrom(
  //                                             side: const BorderSide(
  //                                                 width: 1.0,
  //                                                 color: Colors.red),
  //                                           ),
  //                                           child: const Text(
  //                                             'Delete',
  //                                             style:
  //                                                 TextStyle(color: Colors.red),
  //                                           ))
  //                                     ],
  //                                   )
  //                                 ],
  //                               )),
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 } else {
  //                   return const Text('Empty data');
  //                 }
  //               } else {
  //                 return Text('State: ${snapshot.connectionState}');
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
