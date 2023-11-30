import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';


class AddReceiptPage extends StatefulWidget {
  @override
  _AddReceiptPageState createState() => _AddReceiptPageState();
}

class _AddReceiptPageState extends State<AddReceiptPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _collectionNameController =
  TextEditingController();
  late List<File> _selectedImages = [];

  late String lat;
  late String long;

  String locationMessage = 'Curent location';

  Future<void> _addFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      final file = result.files.single.path!;
      setState(() {
        _selectedImages.add(File(file));
      });
    }
  }
  Future<Position> _addLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permission');
    }
    return await Geolocator.getCurrentPosition();
  }
  Future<void> _addImage2() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _saveCollection() async {
    final String collectionName = _collectionNameController.text.trim();
    for (final imageFile in _selectedImages) {
      // Upload each image file to Firebase Storage
      final storageReference =
      FirebaseStorage.instance.ref().child('images/${Uuid().v4()}');
      final uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      // Get the download URL for each uploaded image
      final downloadUrl = await storageReference.getDownloadURL();
      final metadata = {
        'firm': collectionName,
        'imageUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'useruid': user.uid,
        'Latitude': lat,
        'Longitude': long,
      };
      await FirebaseFirestore.instance.collection('Receipts').doc(user.uid)
          .collection('AllReceipts').doc(Uuid().v4())
          .set(metadata);
    }
    // Navigate back to the previous page
    Navigator.pop(context);
  }
  void _deleteImage() {
    setState(() {
      _selectedImages = [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Receipt'), backgroundColor: Color.fromRGBO(236, 144, 5, 100),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _collectionNameController,
                decoration: InputDecoration(
                  labelText: 'Which store is the receipt from?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),

                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selected Receipts:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(width: 70,),
                  ElevatedButton(
                      onPressed: _deleteImage,
                      child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // button padding
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ), // button text style
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: _selectedImages
                    .map(
                      (file) => Image.file(
                    file,
                    height: 100.0,
                    width: 100.0,
                    fit: BoxFit.cover,
                  ),
                )
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addFile,
                    child: Text('From gallery'),
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
                  SizedBox( width: 10),
                  ElevatedButton(
                    onPressed: _addImage2,
                    child: Text('From camera'),
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
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(locationMessage, textAlign: TextAlign.center,)
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _addLocation().then((value) {
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationMessage = 'Latitude $lat , Longitude: $long';
                    });
                  });
                },
                child: Text('Add location'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCollection,
                child: Text('Save Receipt'),
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
                  alignment: Alignment.bottomCenter
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}