import 'package:billy/pages/addreceipt.dart';
import 'package:billy/pages/components/sidemenu.dart';
import 'package:billy/pages/nfc.dart';
import 'package:billy/pages/your_receipt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {

  final Stream<QuerySnapshot<Map<String, dynamic>>> _imagesStream =
  FirebaseFirestore.instance.collection('Receipts').doc(user.uid).collection('AllReceipts').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
        appBar: AppBar(
          title: Text('Home'),backgroundColor: Color.fromRGBO(236, 144, 5, 100),),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Recently Added Receipts',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _imagesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          int itemCount = snapshot.data!.docs.length > 5 ? 5 : snapshot.data!.docs.length;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final data = snapshot.data!.docs[index].data();
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Scaffold(
                                                appBar: AppBar(title: Text(data['firm']),),
                                                body: Center(
                                                  child: Image.network(data['imageUrl']),
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Image.network(
                                        data['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NFCPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(236, 144, 5, 100), side: BorderSide.none, shape: const StadiumBorder()),
                          child: Text('NFC'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddReceiptPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(236, 144, 5, 100), side: BorderSide.none, shape: const StadiumBorder()),
                          child: Text('Add Receipt'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ReceiptPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(236, 144, 5, 100), side: BorderSide.none, shape: const StadiumBorder()),
                          child: Text('Your Receipts'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color.fromRGBO(236, 144, 5, 100),
                            width: 3.0,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'News',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 15.0,
                          ),
                          top: BorderSide(
                            color: Colors.blueAccent,
                            width: 10.0,
                          ),
                          right: BorderSide(
                            color: Colors.blue,
                            width: 5.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.blueGrey,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Text(
                          'On July 4, 2023, the Favorites function will be enabled. \nYou will also be able to order your cards on November 23, 2023.\nFor any difficulties, feel free to contact us, Your Billy Team.',
                        style: TextStyle(fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 20),),
                    ),
                  ),
                ])
        )
    );
  }
  }