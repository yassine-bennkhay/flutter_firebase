import 'package:chicken/widgets/user_post_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'new_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sellerScreen extends StatefulWidget {
  static const routeName = 'seller-home-page';
  sellerScreen(this.documentId);
  final String documentId;

  @override
  _sellerScreenState createState() => _sellerScreenState();
}

class _sellerScreenState extends State<sellerScreen> {
  Function imagePick;
  CollectionReference users =
      FirebaseFirestore.instance.collection('usersData');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chicken',
          ),
          actions: [
            DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app,
                            color: Theme.of(context).primaryColor),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Logout'),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: users
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
              .get(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (snapShot.data.docs.isEmpty) {
              return Center(
                child: Text('no posts yet, try to add one!'),
              );
            }
            var items = snapShot.data.docs;
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
                            content: const Text("Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text("DELETE")
                              ),
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Card(child: Container(color: Colors.red,

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
