import 'package:chicken/user_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class GuestHomeScreen extends StatefulWidget  {
  GuestHomeScreen(this.userImage);
  final String userImage;

  @override
  _GuestHomeScreenState createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  UserLocation _userLocation=UserLocation();
  double _longitude;
  double _latitude;
  Future<void> _callUser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsData = FirebaseFirestore.instance
        .collection('usersData')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home',style:TextStyle(
          fontFamily: 'RobotoMedium',
        ),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('usersData').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docsData = snapshot.data.docs;
          if (snapshot.data.docs.isEmpty)
            return Center(
              child: Image.asset('images/No_data.png')
            );
          return ListView(
            children: snapshot.data.docs.map((usersData) {
              return Column(
                children: <Widget>[
                  Container(
                    height: 420,
                    margin: EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(usersData['imageLink']),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usersData['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        size: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                       'address',
                                        style: TextStyle(fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text("${usersData['price']} DH",style:TextStyle(
                                fontFamily: 'RobotoMedium',
                                fontSize: 20
                              ),)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffffe9ce),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                )),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        _userLocation.goToMaps(usersData['latitude'], usersData['longitude']);
                                      }, child: Icon(FontAwesomeIcons.mapMarkerAlt)),
                                  ElevatedButton(
                                    child: Icon(Icons.phone),
                                    onPressed: ()=>setState((){
                                      _callUser('tel:${usersData['userNumber']}');
                                      print(usersData['userNumber']);
                                    })
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

}
