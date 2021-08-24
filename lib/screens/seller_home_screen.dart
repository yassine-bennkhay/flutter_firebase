import 'package:chicken/screens/about_us.dart';
import 'package:chicken/screens/auth_screen.dart';
import 'package:chicken/user_location.dart';
import 'package:chicken/widgets/user_post_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'new_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerScreen extends StatefulWidget {
  static const routeName = 'seller-home-page';

  SellerScreen(this.documentId);
  String documentId;
  String docItem;
  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  UserLocation _userLocation = UserLocation();

  Function imagePick;
  CollectionReference users =
      FirebaseFirestore.instance.collection('usersData');
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  Widget aboutUsListTile() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutUs()));
      },
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 8, right: 0.0, bottom: 0, top: 0),
        minLeadingWidth: 0.5,
        visualDensity: VisualDensity(
          horizontal: -4,
        ),
        title: new Text(
          "About Us",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        leading: Icon(
          FontAwesomeIcons.infoCircle,
          size: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(data['username']),
                        accountEmail: Text(data['email']),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage:
                              AssetImage('images/default_user_img.jpg'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SellerScreen(widget.documentId)));
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 8, right: 0.0, bottom: 0, top: 0),
                          minLeadingWidth: 0.5,
                          visualDensity: VisualDensity(
                            horizontal: -4,
                          ),
                          title: new Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          leading: Icon(
                            Icons.home,
                            size: 25,
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      InkWell(
                        onTap: () async {
                          await _userLocation.goToMaps(
                              data['latitude'], data['longitude']);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 8, right: 0.0, bottom: 0, top: 0),
                          minLeadingWidth: 0.5,
                          visualDensity: VisualDensity(
                            horizontal: -4,
                          ),
                          title: new Text(
                            "My Address",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          leading: Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 25,
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      aboutUsListTile(),
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()));
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 8, right: 0.0, bottom: 0, top: 0),
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
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Home',
            textAlign: TextAlign.center,
          ),
        ),
        body: FutureBuilder(
          future: users
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .get(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
            if (snapShot.data.docs.isEmpty) {
              return Center(
                child:Image.asset('images/No_data.png')
              );
            }

            return ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Card(
                        child: Container(
                      color: Colors.red,
                      height: 200,
                    )),
                    direction: DismissDirection.endToStart,
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      await users.doc(snapShot.data.docs[index].id).delete();
                      FirebaseStorage.instance
                          .refFromURL(
                            snapShot.data.docs[index].data()['imageLink'],
                          )
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('deleted successfully!'),
                        ),
                      );
                    },
                    child: UserPostWidget(
                      snapShot.data.docs[index].data()['title'],
                      snapShot.data.docs[index].data()['imageLink'],
                      snapShot.data.docs[index].data()['price'],
                      snapShot.data.docs[index].id,
                      snapShot.data.docs[index].data()['address'],
                      snapShot.data.docs[index],
                    ),
                  );
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            /* showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return NewPost();
              });*/
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewPost()));
          },
        ));
  }
}
