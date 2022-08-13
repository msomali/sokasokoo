import 'package:intl/intl.dart';
import 'package:sokasokoo/models/academy.dart';
import 'package:sokasokoo/repositories/api.dart';

class User {
  String? firstName;
  String? middleName;
  String? lastName;
  String? accountNumber;
  String? phone;
  String? region;
  String? district;
  String? type;
  String? ward;
  String? dob;
  String? profileImage;
  String? sId;
  String? updatedAt;
  String? createdAt;
  String? gender;
  String? nationality;
  String? position;
  String? foot;
  String? street;
  double? height;
  double? weight;
  String? academyName;
  String? academyDescription;
  String? academyRegistration;
  String? companyName;
  String? companyTitle;
  String? companyDescription;
  String? tafoca;
  String? email;
  String? facebook;
  String? youtube;
  String? instagram;
  String? twitter;
  String? linkedin;
  String? fifaId;
  String? licenseLevel;
  String? educationLevel;
  String? contactNumber;
  String? refereeLicenseLevel;
  String? sponsorType;
  String? entityName;
  String? vendorType;
  String? advertVideo;
  Academy? academy;
  double? national_team_call;
  double? national_youth_call;
  String? umiseta_games;
  String? umitashumta_games;
  String? short_bio;
  String? coach_registration;
  User? agent;
  double? advertDuration;
  String? mandatory;

  User(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.accountNumber,
      this.phone,
      this.region,
      this.district,
      this.type,
      this.ward,
      this.dob,
      this.profileImage,
      this.sId,
      this.updatedAt,
      this.createdAt,
      this.gender,
      this.nationality,
      this.position,
      this.foot,
      this.street,
      this.height,
      this.weight,
      this.academyName,
      this.academyRegistration,
      this.academyDescription,
      this.tafoca,
      this.email,
      this.contactNumber,
      this.facebook,
      this.youtube,
      this.instagram,
      this.twitter,
      this.linkedin,
      this.sponsorType,
      this.fifaId,
      this.vendorType,
      this.entityName,
      this.licenseLevel,
      this.educationLevel,
      this.advertVideo,
      this.national_team_call,
      this.national_youth_call,
      this.umiseta_games,
      this.umitashumta_games,
      this.short_bio,
      this.coach_registration,
      this.agent,
      this.advertDuration,
      this.mandatory});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    accountNumber = json['accountNumber'];
    height = double.tryParse(json['height'].toString());
    weight = double.tryParse(json['weight'].toString());
    phone = json['phone'];
    position = json['position'];
    region = json['region'];
    district = json['district'];
    type = json['type'];
    ward = json['ward'];
    dob = json['dob'];
    gender = json['gender'];
    foot = json['foot'];
    street = json['street'] ?? 'Not Provided';
    email = json['email'] ?? 'Not Provided';
    facebook = json['facebook'] ?? 'Not Provided';
    youtube = json['youtube'] ?? 'Not Provided';
    instagram = json['instagram'] ?? 'Not Provided';
    twitter = json['twitter'] ?? 'Not Provided';
    linkedin = json['linkedin'] ?? 'Not Provided';
    fifaId = json['fifaId'] ?? 'Not Provided';
    licenseLevel = json['license_level'] ?? 'Not Provided';
    educationLevel = json['education_level'] ?? 'Not Provided';
    contactNumber = json['contact_number'] ?? 'Not Provided';
    nationality = json['nationality'];
    profileImage = json['profileImage'];
    academyName = json['academy_name'];
    academyRegistration = json['academy_registration'];
    academyDescription = json['academy_description'];
    tafoca = json['tafoca'];
    companyName = json['company_name'];
    companyTitle = json['company_title'];
    companyDescription = json['company_description'];
    refereeLicenseLevel = json['referee_license_level'];
    sId = json['_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    sponsorType = json['sponsor_type'];
    entityName = json['entity_name'];
    vendorType = json['vendor_type'];
    advertVideo = json['advertVideo'];
    national_team_call = double.tryParse(json['national_team_call'].toString());
    national_youth_call =
        double.tryParse(json['national_youth_call'].toString());
    umiseta_games = json['umiseta_games'];
    umitashumta_games = json['umitashumta_games'];
    short_bio = json['short_bio'];
    coach_registration = json['coach_registration'];
    agent = json['agent'] != null ? User.fromJson(json['agent']) : null;
    advertDuration = double.tryParse(json['advertDuration'].toString());
    academy =
        json['academy'] != null ? Academy.fromJson(json['academy']) : null;
    mandatory = json['is_mandatory'] != null
        ? json['is_mandatory'] == true
            ? 'YES'
            : 'NO'
        : 'NO';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['accountNumber'] = accountNumber;
    data['phone'] = phone;
    data['region'] = region;
    data['district'] = district;
    data['height'] = height;
    data['weight'] = weight;
    data['type'] = type;
    data['ward'] = ward;
    data['dob'] = dob;
    data['profileImage'] = profileImage;
    data['_id'] = sId;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['position'] = position;
    data['foot'] = foot;
    data['street'] = street;
    return data;
  }

  String getFormatDob() {
    final df = DateFormat('yyyy-MM-dd');
    var outputData = DateTime.parse(dob.toString());
    var value = df.format(outputData);
    return value;
  }

  String getDobYear() {
    final df = DateFormat('yyyy');
    var data = DateTime.parse(dob.toString());
    var value = df.format(data);
    return value;
  }

  String getProfileImage() {
    var values = profileImage?.split('/');
    var newProfile = values![3];
    var cacheImage = 'https://d3v1v7ebx2k3qm.cloudfront.net/$newProfile';

    return cacheImage;
  }

  int getAdvertDuration() {
    return advertDuration!.toInt();
  }

  String? getName() {
    return type == 'SPONSOR' && sponsorType == 'Entity'
        ? entityName
        : type != 'ACADEMY'
            ? '$firstName $lastName'
            : '$academyName';
  }
}
