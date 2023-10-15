// CLI installation with npm (not binary) cf https://firebase.google.com/docs/flutter/setup?platform=android&hl=fr

//import 'dart:developer';
import 'package:secondflutter/const_cmp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:secondflutter/completekeyboard.dart';
import 'package:secondflutter/SuperResultBarList.dart';
import 'package:secondflutter/gamecard.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
  String _results = "";
  bool _isLogged = false;
  bool _screenIsEnlarged = false;
  List<ChainResult> _resultList = [];

  @override
  void initState() {
    _setIsLogged();
    super.initState();
  }

  void _updateHomePageState(int num) {
    // add card if not there and return true, or remove and return false
    setState(() {
        if (num != 99) {
          if (_cardSet.contains(num)) {
            _cardSet.remove(num);
          }
          else {
            _cardSet.add(num);
          }
          _results=convCardSet(_cardSet);
        }
    });
  }

  void _checkCardSet() {
    String stringToCheck = convCardSet(_cardSet);
    _results = " Checking ...";
    _resultList = [];
    _readIt(stringToCheck);
    _updateHomePageState(99);
  }

  void _initCardSet() {
    _cardSet = {};
    _results = "";
    _resultList = [];
    _updateHomePageState(99);
  }

  void _toggleScreen() {
    _screenIsEnlarged = !_screenIsEnlarged;
    _updateHomePageState(99);
  }

  Future<void> _setIsLogged() async {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        _isLogged = false;
      } else {
        _isLogged = true;
      }
    });
    _updateHomePageState(99);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    _initCardSet();
    _updateHomePageState(99);
  }

  Future<void> _checkIn(String email, String pass) async {
    String messAge="";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
    } on FirebaseAuthException catch(e) {
      messAge="";
      // error codes don't work e.code and e.message
      if (e.code == 'network-request-failed') messAge="Network request failed";
      if (e.code == 'wrong-password') messAge="Wrong password";
      if (e.code == 'user-not-found') messAge="User not found";
      SnackBar sb = SnackBar(
        content: Text("Failed to connect and log ($messAge)"),
        duration: const Duration(seconds: 5),
      );
      //ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
    _setIsLogged();
  }

  Future<void> _readIt(String sToCheck) async {
    var db = FirebaseFirestore.instance;
    //FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    db.collection("Chains").where("Chain Id", isEqualTo: sToCheck)
        .limit(72)
        .get()
        .then(
          (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var docSnapshot in querySnapshot.docs) {
            _resultList.add(
                ChainResult(sToCheck, docSnapshot.data()["Cost"] as double,
                    docSnapshot.data()["GHG"] as double,
                    docSnapshot.data()["H2O"] as double,
                    docSnapshot.data()["Land"] as double,
                    docSnapshot.data()["Protest"] as double));
            _results += _resultList.last.affi();
          }
          _results="$sToCheck found";
          _resultList = removeDuplicates(_resultList);
        } else {
          _results = noSuchChain;
        }
        _updateHomePageState(99);
      },
      //onError: (e) => print("Error completing: $e"),
    );
  }

  /** -----------------------------------------
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
    String varEmail = "";
    String varPass = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          TextButton(onPressed: () async {
            if (_isLogged) {
              _signOut();
            } else {
              await showDialog<String>(context: context,
                builder: (BuildContext context) {
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
              _checkIn(varEmail, varPass);
            }
          }, //async button log
              child: _isLogged ? const Text("Logged") : const Text(
                  "Not logged")),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CompleteKeyBoard(
                fuUpdate: _updateHomePageState,
                cardSet: _cardSet,
                withButtons: _isLogged,
                fuCheck: _checkCardSet,
                fuInitCard: _initCardSet,
                isShortened: _screenIsEnlarged),
            StringDisplayCard(
                //thestring: convCardSet(_cardSet),
                theString: _results,
                isShortened: _screenIsEnlarged),
            SuperResultBarList(
                chainResList: _resultList,
                nMax: 6,
                isShort: !_screenIsEnlarged,
                fuTog: _toggleScreen,
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  } //widget Build
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

List<ChainResult> removeDuplicates(List<ChainResult> listcr){
  List<ChainResult> dummy=[];
  bool testval=false;
  for(ChainResult cr in listcr){
      //if cr not in dummy add
      testval=false;
      for(ChainResult xr in dummy){
        if (xr.testEqual(cr)) testval=true;
      }
      if (!testval) dummy.add(cr);
    }
  dummy.sort((a, b) => a.cost.compareTo(b.cost));
	return dummy;
}

