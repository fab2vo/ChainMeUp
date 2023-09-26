// CLI installation with npm (not binary) cf https://firebase.google.com/docs/flutter/setup?platform=android&hl=fr

//import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
//import 'dart:convert' show utf8;

import 'package:secondflutter/const_cmp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondflutter/gamecard.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    checkin();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chain me Up check'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> checkin() async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'fabdevaux@gmail.com',
        password: 'NRJChain!'
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Set<int> _cardSet = {};
  String _results="";

 void _updateCardState(int num){ // add card if not there and return true, or remove and return false
    setState(() {
      if (_cardSet.contains(num)) {
        _cardSet.remove(num);
      } else {
        _cardSet.add(num);
        }
    });
  }
void _checkCardSet () {
    String stringToCheck="";
    _results="";
    List<int> toSort=List<int>.from(_cardSet);
    toSort.sort();
    for(int i in toSort){
      stringToCheck += "-${i.toString().padLeft(2, '0')}";
    }
    stringToCheck=stringToCheck.substring(1);
    /**FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {print('User is currently signed out!');
      } else {print('User is signed in!');}
    }); **/
    _readIt(stringToCheck);
  }

Future<void> _readIt(String sToCheck)async {
    var db = FirebaseFirestore.instance;
    db.collection("Chains").where("Chain Id", isEqualTo: sToCheck).get().then(
          (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty){
          _results="Cost    GHG    H20   Land  Protest\n";
          for (var docSnapshot in querySnapshot.docs) {
            _results+=docSnapshot.data()["Cost"].toString().padRight(9," ");
            _results+=docSnapshot.data()["GHG"].toString().padRight(9," ");
            _results+=docSnapshot.data()["H20"].toString().padRight(9," ");
            _results+=docSnapshot.data()["Land"].toString().padRight(9," ");
            _results+=docSnapshot.data()["Protest"].toString().padRight(9," ");
            _results+="\n";
            _updateCardState(99);
          }
        } else {_results="No such chain"; _updateCardState(99);}
      },
      onError: (e) => print("Error completing: $e"),
    );

  }
void _fillDB(){
   //fill data in firestore
  /**var db = FirebaseFirestore.instance;
  final ChainResult data1=ChainResult("01-02",25,2,0,0,8);
  final ChainResult data2=ChainResult("02-12",20,3,0.2,20,0);
  db.collection("Chains").add(data1.toMap()); **/
  _pickFile();
  }

Future<void>  _pickFile() async {
   // read csv file with all the solutions
    final input = await  rootBundle.loadString('assets/CMPsol.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);
    //print(csvTable[0]);
    //print(csvTable.length);
    // add to firestore
    var db = FirebaseFirestore.instance;
    var imin=51938; // ok 51571(delta de 2025)
    var imax=55000; // n'a pas fonctionne
    for (var i = imin; i < imax; i++){
      db.collection("Chains").add(ChainResult.short(csvTable[i]).toMap());
      //print(ChainResult.short(csvTable[i]).toMap());
      }
     print("Uploade de $imin à $imax");
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             //KeyBoard(fu: _updateCardState, cardSet: _cardSet),
            GridCard(fu: _updateCardState, cardSet: _cardSet),
            ElevatedButton(
                onPressed: () {
                  _checkCardSet();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text('Submit')
            ),
            Text(_results),
            ElevatedButton(
                onPressed: () {
                  _fillDB();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text('Fill')
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class CardButton extends StatelessWidget {
  const CardButton({super.key, required this.carddecknumber, required this.fu, required this.isPressed});
  final int carddecknumber;
  final bool isPressed;
  final Function fu; // function to add the card to the card set, return true if the card is already in it
  @override
  Widget build(BuildContext context) {
    return Container(
         child: ElevatedButton(
              onPressed: () {fu(cardDeck[carddecknumber].num);},
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
                  backgroundColor: cardDeck[carddecknumber].color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: (isPressed) ? Colors.black : cardDeck[carddecknumber].color ,width: 2)
                )
              ),
                child: Text('${cardDeck[carddecknumber].num}', style: const TextStyle(color: Colors.white))
          )
        )
    ;
  }
}

class KeyBoard extends StatelessWidget {
  const KeyBoard({super.key, required this.fu, required this.cardSet});
  final Set<int> cardSet ;
  final Function fu;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 0),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 7),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 14),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 21),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 28),
    ]);
  }
}

class GridCard extends StatelessWidget{
  const GridCard({super.key, required this.fu, required this.cardSet});
  final Function fu;
  final Set<int> cardSet;
  Widget build(BuildContext context){
    final List<Widget> _widget = List.generate(
       // cardDeck.length,
            20,
            (index) => CardButton(carddecknumber: cardDeck[index].num, fu: fu,isPressed: cardSet.contains(cardDeck[index].num))
    );
    return GridView.extent(
      maxCrossAxisExtent: 30,
      children: _widget
    );
  }
//Vertical viewport was given unbounded height.
// Viewports expand in the scrolling direction to fill their container.
// In this case, a vertical viewport was given an unlimited amount of vertical space in which to expand. This situation typically happens when a scrollable widget is nested inside another scrollable widget.
}

class RowKeyBoard extends StatelessWidget {
  const RowKeyBoard({super.key, required this.fu, required this.cardSet, required this.i0});
  final Set<int> cardSet ;
  final Function fu;
  final int i0;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CardButton(carddecknumber: i0, fu: fu,isPressed: cardSet.contains(cardDeck[i0].num)),
          CardButton(carddecknumber: i0+1, fu: fu,isPressed: cardSet.contains(cardDeck[i0+1].num)),
          CardButton(carddecknumber: i0+2, fu: fu,isPressed: cardSet.contains(cardDeck[i0+2].num)),
          CardButton(carddecknumber: i0+3, fu: fu,isPressed: cardSet.contains(cardDeck[i0+3].num)),
          CardButton(carddecknumber: i0+4, fu: fu,isPressed: cardSet.contains(cardDeck[i0+4].num)),
          CardButton(carddecknumber: i0+5, fu: fu,isPressed: cardSet.contains(cardDeck[i0+5].num)),
        ]
    );
  }
}

/**
bool checkCardSet (Set<int> cardSet) {
  String stringToCheck="";
  List<int> toSort=List<int>.from(cardSet);
  toSort.sort();
  for(int i in toSort){
    stringToCheck += "-${i.toString().padLeft(2, '0')}";
  }
  stringToCheck=stringToCheck.substring(1);
  FirebaseAuth.instance
      .userChanges()
      .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  return checkInDB(stringToCheck);
}

bool checkInDB(String sToCheck) {
  // Create a new user with a first and last name
  //final chain = <String, dynamic>{
  //  "Chain Id": "12-20-41",
  //  "Cost": 27.2,
  //  "GHG": 1.97,
  //  "H2O":4.5,
  //  "Land":1.86,
  //  "Protest": 1.8
  //};
  readIt(sToCheck);
  return true;
}

Future<void> readIt(String sToCheck)async {
  var db = FirebaseFirestore.instance;
  db.collection("Chains").where("Chain Id", isEqualTo: sToCheck).get().then(
        (querySnapshot) {
      if (querySnapshot.docs.isNotEmpty){
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      } else {print("Not found");}
    },
    onError: (e) => print("Error completing: $e"),
  );
}
    **/