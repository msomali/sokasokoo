class Regions {
  late String country;
  late String name;
  late List<String> features;

  Regions({required this.country, required this.name, required this.features});

  Regions.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    name = json['name'];
    if (json['features'] != null) {
      features = <String>[];
      json['features'].forEach((v) {
        features.add(v['properties']['region']);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Country'] = country;
    data['name'] = name;
    return data;
  }
}
