// CLI installation with npm (not binary) cf https://firebase.google.com/docs/flutter/setup?platform=android&hl=fr
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chain me Up Check',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
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

class _MyHomePageState extends State<MyHomePage> {
  Set<int> _cardSet = {};
  String _results="";
  bool _isLogged=false;
  List<ChainResult> _resultList=[];

  @override
  void initState() {
    _setIsLogged();
    super.initState();
  }

 void _updatHomePageState(int num){
    // add card if not there and return true, or remove and return false
    setState(() {
      if (num!=99) {
        if (_cardSet.contains(num)) {_cardSet.remove(num);}
        else {_cardSet.add(num);}
      }
    });
  }

 void _checkCardSet () {
    String stringToCheck=convCardSet(_cardSet);
    _results=" Checking ...";
    _resultList=[];
    _readIt(stringToCheck);
    _updatHomePageState(99);
  }

 void _initCardSet () {
    _cardSet={};
    _results="";
    _resultList=[];
    _updatHomePageState(99);
 }

  Future<void> _setIsLogged() async {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {_isLogged=false;
      } else {_isLogged=true;}
    });
    _updatHomePageState(99);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    _initCardSet();
    _updatHomePageState(99);
  }

  Future<void> _checkin(String email, String pass) async {
      try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
    } on FirebaseAuthException {
          const SnackBar sb = SnackBar(
            content: Text('Invalid credentials'),
            duration: Duration(seconds: 5),
          );
          //ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    _setIsLogged();
  }

  Future<void> _readIt(String sToCheck) async {
    var db = FirebaseFirestore.instance;
    //FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    db.collection("Chains").where("Chain Id", isEqualTo: sToCheck).limit(20).get().then(
          (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty){
          _results="Cost    GHG    H20   Land  Protest          \n";
          for (var docSnapshot in querySnapshot.docs){
            _resultList.add(ChainResult(sToCheck,docSnapshot.data()["Cost"] as double,
                docSnapshot.data()["GHG"] as double,
                docSnapshot.data()["H2O"] as double,
                docSnapshot.data()["Land"] as double,
                docSnapshot.data()["Protest"] as double));
            _results += _resultList.last.affi();
          }
        } else {_results=EMPTYSTRING; }
        _updatHomePageState(99);
      },
      //onError: (e) => print("Error completing: $e"),
    );

  }
  /**
  void _fillDB(){
  _pickFile();
  }
  Future<void>  _pickFile() async {
   // read csv file with all the solutions and upload
    final input = await  rootBundle.loadString('assets/CMPsol.csv');
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(input);
    var db = FirebaseFirestore.instance;
    var imin=169000; // ok
    var imax=csvTable.length; // up 169736
    for (var i = imin; i < imax; i++){
      db.collection("Chains").add(ChainResult.short(csvTable[i]).toMap());
      }
     //print("Uploade de $imin à $imax");
    }
   **/

  @override
  Widget build(BuildContext context) {
    String varEmail="";
    String varPass="";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          TextButton(onPressed: () async {
            if (_isLogged) {_signOut();} else {
              await showDialog<String>(context: context,
              builder : (BuildContext context) {
                return AlertDialog(
                  content: const Text('Please enter you credentials'),
                  actions: <Widget>[
                  TextField(
                     onChanged: (String val) => varEmail = val,
                     decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@email.com',
                    icon: Icon(Icons.contact_mail),
                  )),
                    TextField(
                        onChanged: (String val) => varPass = val,
                        //controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'ABC123',
                          icon: Icon(Icons.password),
                        )),
                    TextButton(
                        child: const Text('Login'),
                        onPressed: () => Navigator.pop(context, "")
                     ), //text button
                  ],
                ); //alertdialog
              }, // builder
            ); // ShowDialog
            _checkin(varEmail, varPass);
            }}, //async button log
              child:  _isLogged ? const Text( "Logged"): const Text("Not logged")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            KeyBoard(fu: _updatHomePageState, cardSet: _cardSet),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _isLogged ? _checkCardSet():null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                  child: const Text('Submit')
                  ),
                  ElevatedButton(
                      onPressed: () => _initCardSet(),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: const Text('Clear')
                  ),
                  ]
            ),
            Text(convCardSet(_cardSet)),
            Container(
                margin:const EdgeInsets.only(top:15.0),
                child: (_resultList.isEmpty) ?
                  Text(_results,
                        style: const TextStyle(fontSize: 14)
                    ):
                    ResultBarList(chainresultlist: _resultList)
            ),
            /**ElevatedButton(
                onPressed: () {
                  _fillDB();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text('Fill')
            ),**/
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
    if ((carddecknumber+1)>(cardDeck.length)) return Container();
    return Container(
        margin: const EdgeInsets.all(2),
        child : ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          child:ElevatedButton(
              onPressed: () {fu(cardDeck[carddecknumber].num);},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero, // Set this
                  padding: EdgeInsets.zero, // and this
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                    backgroundColor: cardDeck[carddecknumber].color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: (isPressed) ? Colors.grey.shade500 : cardDeck[carddecknumber].color ,width: 5)
                )
              ),
                child: Text('${cardDeck[carddecknumber].num}', style: const TextStyle(color: Colors.white))
          )
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
    return Container(
      margin:const EdgeInsets.only(top:15, bottom:15.0),
      child : Column(
        children: <Widget>[
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 0),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 10),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 20),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 30),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 40),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 50),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 60),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 70),
        RowKeyBoard(fu: fu, cardSet: cardSet, i0: 80),
          //Text(convCardSet(cardSet),style: TextStyle(fontSize: 18)),
        ]
      )
    )
    ;
  }
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
        children:
          //_widget
          <Widget>[
            ((i0+1)<cardDeck.length) ? CardButton(carddecknumber: i0, fu: fu,isPressed: cardSet.contains(cardDeck[i0].num)) : Container(),
            ((i0+2)<cardDeck.length) ? CardButton(carddecknumber: i0+1, fu: fu,isPressed: cardSet.contains(cardDeck[i0+1].num)) : Container(),
            ((i0+3)<cardDeck.length) ? CardButton(carddecknumber: i0+2, fu: fu,isPressed: cardSet.contains(cardDeck[i0+2].num)) : Container(),
            ((i0+4)<cardDeck.length) ? CardButton(carddecknumber: i0+3, fu: fu,isPressed: cardSet.contains(cardDeck[i0+3].num)) : Container(),
            ((i0+5)<cardDeck.length) ? CardButton(carddecknumber: i0+4, fu: fu,isPressed: cardSet.contains(cardDeck[i0+4].num)) : Container(),
            ((i0+6)<cardDeck.length) ? CardButton(carddecknumber: i0+5, fu: fu,isPressed: cardSet.contains(cardDeck[i0+5].num)) : Container(),
            ((i0+7)<cardDeck.length) ? CardButton(carddecknumber: i0+6, fu: fu,isPressed: cardSet.contains(cardDeck[i0+6].num)) : Container(),
            ((i0+8)<cardDeck.length) ? CardButton(carddecknumber: i0+7, fu: fu,isPressed: cardSet.contains(cardDeck[i0+7].num)) : Container(),
            ((i0+9)<cardDeck.length) ? CardButton(carddecknumber: i0+8, fu: fu,isPressed: cardSet.contains(cardDeck[i0+8].num)) : Container(),
            ((i0+10)<cardDeck.length) ? CardButton(carddecknumber: i0+9, fu: fu,isPressed: cardSet.contains(cardDeck[i0+9].num)) : Container(),
        ]
    );
  }
}

class ResultBar extends StatelessWidget{
  const ResultBar({super.key, required this.chainresult});
  final ChainResult chainresult;
    @override
  Widget build(BuildContext context) {
    return Container(
        margin:const EdgeInsets.only(left:15.0, right:15.0),
        child : Card(child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children :<Widget>[
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_Cost_icon.png'), width:30),
            Text(chainresult.getCost()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_GHG_icon.png'), width:30),
            Text(chainresult.getGHG()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_H2O_icon.png'), width:30),
            Text(chainresult.getH2O()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_land_icon.png'), width:30),
            Text(chainresult.getLand()),
            const Image(image:AssetImage('assets/Chain_Me_Up_Cover_protest_icon.png'), width:30),
            Text(chainresult.getProtest()),
            Text(" > ${chainresult.getChallengeresult()}"),
        ]
      )
        )
    );
  }
}

class ResultBarList extends StatelessWidget{
  const ResultBarList({super.key, required this.chainresultlist});
  final List<ChainResult> chainresultlist;
  @override
  Widget build(BuildContext context) {
  List<ChainResult> crl=chainresultlist.toSet().toList();  //eliminer odublons
  final List<Widget> internalWidget = List.generate(
      (chainresultlist.length<7)?chainresultlist.length:6,
        (index) => ResultBar(chainresult: crl[index])
    );
  if (chainresultlist.length>6){
    internalWidget.add(const Card(child:Text("         ...         ")));
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: internalWidget,
    );
  }
}

String convCardSet (Set<int> cardSet) {
  if (cardSet.isEmpty) return "";
  String stringToCheck="";
  List<int> toSort=List<int>.from(cardSet);
  toSort.sort();
  for(int i in toSort){
    stringToCheck += "-${i.toString().padLeft(2, '0')}";
  }
  return stringToCheck.substring(1);
}
