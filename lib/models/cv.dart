class Cv {
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  String? isCurrent;
  String? person;
  String? type;
  String? phone;
  String? sId;
  String? updatedAt;
  String? createdAt;

  Cv(
      {this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.sId,
      this.type,
      this.person,
      this.phone,
      this.updatedAt,
      this.createdAt});

  Cv.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    sId = json['_id'];
    isCurrent = json['isCurrent'] != null
        ? json['isCurrent'] == true
            ? 'YES'
            : 'NO'
        : 'NO';
    person = json['person'];
    phone = json['phone'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['_id'] = sId;
    data['person'] = person;
    data['phone'] = phone;
    data['type'] = type;
    data['isCurrent'] = isCurrent;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
