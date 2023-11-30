import 'package:billy/pages/components/sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';



class ReceiptPage extends StatefulWidget {
  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _itemsStream;
  bool _isAscending = true;
  String _sortBy = 'timestamp';

  @override
  void initState() {
    super.initState();
    _itemsStream = FirebaseFirestore.instance.collection('Receipts').doc(user.uid).collection('AllReceipts').snapshots();
  }

  void _sortData(String field, bool isAscending) {
    setState(() {
      _sortBy = field;
      _isAscending = isAscending;
      _itemsStream = FirebaseFirestore.instance.collection('Receipts')
          .doc(user.uid).collection('AllReceipts')
          .orderBy(field, descending: !isAscending)
          .snapshots();
    });
  }
  Future<void> _openMap(String lat, String long) async {
    final Uri _url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$long');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
  deletedata(id) async {
    await FirebaseFirestore.instance.collection('Receipts').doc(user.uid).collection('AllReceipts').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text('Your Receipts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort by:'),
                DropdownButton<String>(
                  value: _sortBy,
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('Date'),
                      value: 'timestamp',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Store'),
                      value: 'firm',
                    ),
                  ],
                  onChanged: (value) {
                    _sortData(value!, _isAscending);
                  },
                ),
                IconButton(
                  icon: _isAscending ? Icon(Icons.arrow_upward) : Icon(Icons.arrow_downward),
                  onPressed: () {
                    _sortData(_sortBy, !_isAscending);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _itemsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> dataList = [];
                  snapshot.data!.docs.forEach((doc) {
                    Map<String, dynamic>
                    map = doc.data();
                    map['key'] = doc.id;
                    dataList.add(map);
                  });
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dataList[index]['firm']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd – kk:mm').format(
                                dataList[index]['timestamp'].toDate(),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Scaffold(
                                              appBar: AppBar(title: Text(dataList[index]['firm'])),
                                              body: Center(
                                                child: Image.network(dataList[index]['imageUrl']),
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    child: Image.network(dataList[index]['imageUrl']),
                                    width: 100,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _openMap(dataList[index]['Latitude'], dataList[index]['Longitude']);
                                  },
                                  child: Text('Show Location'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(236, 144, 5, 100), // text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20), // rounded corners
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), // button padding
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ), // button text style
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deletedata(snapshot.data?.docs[index].id);
                          },
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
        ],
      ),
    );
  }
}
