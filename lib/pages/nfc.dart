import 'package:billy/pages/components/sidemenu.dart';
import 'package:billy/pages/help.dart';
import 'package:billy/pages/addreceipt.dart';
import 'package:billy/pages/your_receipt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:slide_to_act/slide_to_act.dart';

class NFCPage extends StatefulWidget {
  NFCPage({Key? key}) : super(key: key);
  @override
  State<NFCPage> createState() => _NFCPageState();
}
final user = FirebaseAuth.instance.currentUser!;
class _NFCPageState extends State<NFCPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(title: Text('NFC Manager'), backgroundColor: Color.fromRGBO(236, 144, 5, 100),),
      body: SafeArea(
        child: Column(
          children: [ FutureBuilder(
              future: NfcManager.instance.isAvailable(),
              builder: (context, ss) {
                if (ss.data == true) {
                  if (ss.hasError) {
                    return Center(
                      child: Text('Error: ${ss.error}'),
                    );
                  } else {
                    return Column(
                      children: [
                        Image.asset(
                          'assets/images/e4617d50f40c03c8f3c264d94392d393.gif',
                        alignment: Alignment.topCenter,),
                        const SizedBox(height: 50),
                        Container(
                          child: Text('Your code is '+user.uid),
                        ),
                        const SizedBox(height: 50),
                        SlideAction(
                          alignment: Alignment.bottomCenter,
                          outerColor: Color.fromRGBO(236, 144, 5, 100),
                          innerColor: Colors.black,
                          sliderButtonIcon: const Icon(
                            Icons.nfc_rounded,
                            color: Colors.white,
                          ),
                          text: 'Slide to send NFC',
                          textStyle: const TextStyle(color: Colors.white, fontSize: 24,),
                          onSubmit: () {
                            NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {

                              var ndef = Ndef.from(tag);
                              if (ndef == null || !ndef.isWritable) {
                                showDialog(context: context, builder: (context)=>AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please try again or contact customer service'),
                                  backgroundColor: Color.fromRGBO(236, 144, 5, 100),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NFCPage()));
                                    }, child: Text('Ok')),
                                    TextButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUs()));
                                    }, child: Text('Customer service'),),
                                  ],
                                ),
                                );
                                NfcManager.instance.stopSession();
                                return;
                              }
                              NdefMessage userUid = NdefMessage([
                                NdefRecord.createText(user.uid),
                              ]);

                              try {
                                await ndef.write(userUid);
                                showDialog(context: context, builder: (context)=>AlertDialog(
                                  title: Text('Success'),
                                  content: Text('Your code has been loaded successfully, you can view your accounts in the accounts folder!!'),
                                  backgroundColor: Colors.green,
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NFCPage()));
                                    }, child: Text('Ok')),
                                    TextButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptPage()));
                                    }, child: Text('Your receipts'),),
                                  ],
                                ),
                                );
                                NfcManager.instance.stopSession();
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                  ),
                                );
                                return;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  }
                } else {
                  return Container(
                    height: 700,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Opps!..",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 32),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Something went wrong with your NFC, Please make sure that it is on and RETRY",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text('or you can enter the code manually '),
                            Text(user.uid, style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),),
                            const SizedBox(height: 32),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>NFCPage()));
                              },
                              child: const Text(
                                "RETRY",
                                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
                              ),
                              color: Theme.of(context).cardColor,
                              elevation: 30,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            )
                          ],
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomCenter,
                        image: AssetImage('assets/images/pngfind.com-nfc-logo-png-5780020 (1).png'),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
