import 'package:sokasokoo/models/user.dart';

class Advert {
  String? title;
  String? description;
  String? photo;
  String? sId;

  Advert({this.title, this.description, this.photo, this.sId});

  Advert.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    photo = json['photo'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;

    data['photo'] = photo;

    data['_id'] = sId;
    return data;
  }

  String getCoverImage() {
    var values = photo?.split('/');
    var newProfile = values![3];
    var cacheImage = 'https://d3v1v7ebx2k3qm.cloudfront.net/$newProfile';

    return cacheImage;
  }
}
