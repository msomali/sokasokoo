class Districts {
  late String name;
  late List<Features> features;

  Districts({required this.name, required this.features});

  Districts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        print(v);
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
  late String region;
  late String district;

  Features({required this.region, required this.district});

  Features.fromJson(Map<String, dynamic> json) {
    region = json['properties']['region'];
    district = json['properties']['District'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region'] = region;
    data['District'] = district;
    return data;
  }
}
