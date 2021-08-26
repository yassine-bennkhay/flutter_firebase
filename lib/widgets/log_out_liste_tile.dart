import 'package:chicken/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogOutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8, right: 0.0, bottom: 0, top: 0),
        minLeadingWidth: 0.5,
        visualDensity: VisualDensity(
          horizontal: -4,
        ),
        title: new Text(
          "LogOut",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        leading: Icon(
          FontAwesomeIcons.signOutAlt,
          size: 25,
        ),
      ),
    );
  }
}
