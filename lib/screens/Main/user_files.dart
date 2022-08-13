import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sokasokoo/models/media.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/add_file.dart';
import 'package:sokasokoo/screens/Main/view_media.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyFiles extends StatefulWidget {
  MyFiles({Key? key, this.id}) : super(key: key);

  String? id;

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  var items = [];
  var loading = false;

  Future<void> _showMyDialog(Media data) async {
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
                  await Api().deleteMedia(data.sId);
                  Fluttertoast.showToast(
                      msg: 'Media Deleted Successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  fetchUserFiles();
                } on DioError catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Error deleting Media',
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

  @override
  void initState() {
    super.initState();
    fetchUserFiles();
  }

  void fetchUserFiles() async {
    setState(() {
      loading = true;
    });
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    var data = await Api().getUserMedia(widget.id ?? user.sId);
    if (mounted) {
      setState(() {
        items = data;
        loading = false;
      });
    }
  }

  Widget buildCtn() {
    return items.isNotEmpty
        ? ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewMedia(
                                  url: items[index].url,
                                )),
                      );
                    },
                    leading: items[index].type == 'Image'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(items[index].url),
                          )
                        : const Icon(
                            Icons.web_outlined,
                            size: 60,
                          ),
                    title: Text('${items[index].title}'),
                    subtitle: Text(
                        '${items[index].description} - ${timeago.format(DateTime.parse(items[index].createdAt))}'),
                    trailing: widget.id != null
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewMedia(
                                          url: items[index].url,
                                        )),
                              );
                            },
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.red,
                            ))
                        : IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              _showMyDialog(items[index]);
                            },
                          ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text('No Videos Uploaded Yet'),
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
                  MaterialPageRoute(builder: (context) => const AddFile()),
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
              enablePullUp: false,
              child: buildCtn(),
              physics: const BouncingScrollPhysics(),
              footer: const ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 700),
              ),
              onRefresh: () async {
                fetchUserFiles();
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                fetchUserFiles();
                _refreshController.loadFailed();
              },
            ),
    );
  }
}
