import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class guestHomeScreen extends StatelessWidget {
  guestHomeScreen(this.userImage);
  final String userImage;
  @override
  Widget build(BuildContext context) {
    final docsData =FirebaseFirestore.instance
        .collection('usersData')
        .orderBy('createdAt', descending: true)
        .snapshots();



    final userDataId=FirebaseFirestore.instance.collection('usersData').doc('userId').get();
    final specificUserId= FirebaseFirestore.instance.collection('users').doc('userId').get();




    return Scaffold(
      appBar: AppBar(
        title: Text('chicken'),
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
              child: Text(
                'No Posts yet!',
                style: TextStyle(fontSize: 20),
              ),
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
                                        Icons.map,
                                        size: 25,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        docsData.length.toString(),
                                        style: TextStyle(fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text('20\$')
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
                                      onPressed: () {}, child: Icon(Icons.map)),
                                  ElevatedButton(
                                    child: Icon(Icons.phone),
                                    onPressed: () {},
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
