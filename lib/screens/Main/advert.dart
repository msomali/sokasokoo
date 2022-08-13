import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/advert.dart';
import 'package:sokasokoo/models/playlist.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/view_media.dart';

class AdvertScreen extends StatefulWidget {
  const AdvertScreen({Key? key}) : super(key: key);

  @override
  _AdvertState createState() => _AdvertState();
}

class _AdvertState extends State<AdvertScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var advertTimer =
        Provider.of<UserProvider>(context).currentUser.advertDuration;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Flexible(
                    child: FutureBuilder(
                        future: Api().getPlayList(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If we got an error
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  '${snapshot.error} occured',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              );

                              // if we got our data
                            } else if (snapshot.hasData) {
                              var data = snapshot.data as PlayList;

                              var header = data.title ?? 'Top Videos';

                              var videos = data.videos;

                              return Container(
                                width: double.infinity,
                                height: 300,
                                child: Column(
                                  children: [
                                    Text(
                                      header,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: videos?.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebViewMedia(
                                                              url: videos![
                                                                      index]
                                                                  .url
                                                                  .toString(),
                                                            )),
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            videos![index]
                                                                .getCoverImage()),
                                                        fit: BoxFit.cover),
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors
                                                            .blue.shade400),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  )
                ],
              )),
          Expanded(
              flex: 4,
              child: FutureBuilder(
                  future: Api().getAdverts(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occured',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        var data = snapshot.data as List<Advert>;

                        return CarouselSlider(
                            items: data.map((payload) {
                              return Builder(builder: (BuildContext context) {
                                return Column(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        child: Image.network(
                                          payload.getCoverImage(),
                                          height: 320,
                                          width: 320,
                                          // fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                            }).toList(),
                            options: CarouselOptions(
                              height: 350,
                              viewportFraction: 0.9,
                              autoPlay: true,
                              autoPlayInterval:
                                  Duration(seconds: advertTimer!.toInt()),
                              enlargeCenterPage: true,
                            ));
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  }))
        ],
      ),
    );
  }
}
