class Academy {
  String? sId;
  String? academyName;
  String? academyRegistration;
  String? academyDescription;
  String? tafoca;

  Academy(
      {this.sId,
      this.academyName,
      this.academyRegistration,
      this.academyDescription,
      this.tafoca});

  Academy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    academyName = json['addedBy']['academy_name'];
    academyRegistration = json['addedBy']['academy_registration'];
    academyDescription = json['addedBy']['academy_description'];
    tafoca = json['addedBy']['tafoca'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['academy_name'] = academyName;
    data['academy_registration'] = academyRegistration;
    data['academy_description'] = academyDescription;
    data['tafoca'] = tafoca;
    return data;
  }
}
