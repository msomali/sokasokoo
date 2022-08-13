import 'media.dart';

class PlayList {
  String? title;
  List<Media>? videos;

  PlayList({required this.title, required this.videos});

  PlayList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['videos'] != null) {
      videos = <Media>[];
      json['videos'].forEach((v) {
        videos!.add(Media.fromJson(v));
      });
    }
  }
}
