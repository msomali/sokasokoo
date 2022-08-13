class Wards {
  late String name;
  late List<Features> features;

  Wards({required this.name, required this.features});

  Wards.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['features'] = features.map((v) => v.toJson()).toList();
    return data;
  }
}

class Features {
  late String district;
  late String ward;

  Features({required this.district, required this.ward});

  Features.fromJson(Map<String, dynamic> json) {
    ward = json['properties']['Ward'];
    district = json['properties']['District'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Ward'] = ward;
    data['District'] = district;
    return data;
  }
}
