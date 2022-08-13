class Media {
  String? title;
  String? description;
  String? type;
  String? createdBy;
  String? sId;
  String? url;
  String? updatedAt;
  String? createdAt;
  String? coverImage;

  Media(
      {this.title,
      this.description,
      this.type,
      this.createdBy,
      this.sId,
      this.coverImage,
      this.updatedAt,
      this.createdAt});

  Media.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    type = json['type'];
    createdBy = json['createdBy']['_id'];
    url = json['url'];
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    coverImage = json['createdBy']['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['createdBy'] = createdBy;
    data['_id'] = sId;
    data['url'] = url;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }

  String getCoverImage() {
    var values = coverImage?.split('/');
    var url = values![3];
    var cacheImage = 'https://d3v1v7ebx2k3qm.cloudfront.net/$url';

    return cacheImage;
  }
}
