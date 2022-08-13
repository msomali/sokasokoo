import 'package:flutter/material.dart';
import 'package:sokasokoo/models/user.dart';

class AllInfo extends StatefulWidget {
  AllInfo({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<AllInfo> createState() => _AllInfoState();
}

class _AllInfoState extends State<AllInfo> {
  Widget buildDetails(key, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('$key'), Text('$value')],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.user.type == 'ACADEMY'
                ? buildDetails('Name', '${widget.user.academyName}')
                : buildDetails(
                    'Name', '${widget.user.firstName} ${widget.user.lastName}'),
            widget.user.type == 'ACADEMY'
                ? buildDetails('Academy Registration',
                    '${widget.user.academyRegistration}')
                : Container(),
            buildDetails('Account Number', '${widget.user.accountNumber}'),
            // buildDetails('Phone', widget.user.phone ?? 'Not Provided'),
            buildDetails('Date of Birth', widget.user.getFormatDob()),
            widget.user.type != 'ACADEMY'
                ? buildDetails(
                    'Nationality', widget.user.nationality ?? 'Not Provided')
                : Container(),
            widget.user.type != 'ACADEMY'
                ? buildDetails('Gender', widget.user.gender ?? 'Not Provided')
                : Container(),
            widget.user.type == 'PLAYER'
                ? buildDetails(
                    'Position', widget.user.position ?? 'Not Provided')
                : Container(),
            widget.user.type == 'PLAYER'
                ? buildDetails('Height', '${widget.user.height}')
                : Container(),
            widget.user.type == 'PLAYER'
                ? buildDetails('Weight', '${widget.user.weight}')
                : Container(),
            widget.user.type == 'PLAYER'
                ? buildDetails(
                    'Preferred Foot', widget.user.foot ?? 'Not Provided')
                : Container(),
            buildDetails('Region', '${widget.user.region}'),
            buildDetails('District', '${widget.user.district}'),
            buildDetails('Ward', '${widget.user.ward}'),
            buildDetails('Street', '${widget.user.street}'),
            buildDetails('Contact Email', '${widget.user.email}'),
            buildDetails('Contact Number', '${widget.user.contactNumber}'),
            buildDetails('Facebook', '${widget.user.facebook}'),
            buildDetails('Twitter', '${widget.user.twitter}'),
            buildDetails('Youtube', '${widget.user.youtube}'),
            buildDetails('Instagram', '${widget.user.instagram}'),
            buildDetails('Linkedin', '${widget.user.linkedin}'),
            buildDetails('FifaId', '${widget.user.fifaId}'),
            buildDetails('License Level', '${widget.user.licenseLevel}'),
            buildDetails('Education Level', '${widget.user.educationLevel}'),
            ['PLAYER', 'COACH'].contains(widget.user.type) &&
                    widget.user.agent != null
                ? buildDetails('Agent Name', widget.user.agent!.getName())
                : Container(),
            ['PLAYER', 'COACH'].contains(widget.user.type) &&
                    widget.user.agent != null
                ? buildDetails('Agent Company', widget.user.agent!.companyName)
                : Container(),
            ['PLAYER', 'COACH'].contains(widget.user.type) &&
                    widget.user.agent != null
                ? buildDetails('Agent Region', widget.user.agent!.region)
                : Container(),
            buildDetails('Registation Number',
                widget.user.coach_registration ?? 'Not Provided'),
          ],
        ),
      ),
    );
  }
}
