// CLI installation with npm (not binary) cf https://firebase.google.com/docs/flutter/setup?platform=android&hl=fr

//import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:secondflutter/completekeyboard.dart';
import 'package:secondflutter/SuperResultBarList.dart';
import 'package:secondflutter/gamecard.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

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
  // real state known at startup; kept up to date by _authSubscription
  bool _isLogged = FirebaseAuth.instance.currentUser != null;
  StreamSubscription<User?>? _authSubscription;
  bool _isCollapsed = true;
  List<ChainResult> _resultList = [];
  bool _requestSubmitDisplay=false;
  bool _chainSubmitted=false;

  @override
  void initState() {
    super.initState();
    // single listener for the whole life of the page, cancelled in dispose()
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!mounted) return;
      setState(() {
        _isLogged = (user != null);
      });
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _updateHomePageState(int num) {
    // add card if not there and return true, or remove and return false
    setState(() {
        if (num != 99) {
          _requestSubmitDisplay = false;
          if (_cardSet.contains(num)) {
            _cardSet.remove(num);
          }
          else {
            _cardSet.add(num);
          }
        }
    });
  }

  void _initCardSet() {
    _cardSet = {};
    _resultList = [];
    _requestSubmitDisplay=false;
    _updateHomePageState(99);
  }



  void _toggleCollapse() {
    _isCollapsed = !_isCollapsed;
    _updateHomePageState(99);
  }

  bool _getStateSearching() {
    return _chainSubmitted;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut(); // _authSubscription updates _isLogged
    _initCardSet();
  }

  Future<void> _checkIn(String email, String pass) async {
    String messAge="";
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
    } on FirebaseAuthException catch(e) {
      // Recent Firebase versions return 'invalid-credential' instead of
      // 'wrong-password' / 'user-not-found' (email enumeration protection)
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          messAge = "Wrong email or password";
        case 'invalid-email':
          messAge = "Invalid email address";
        case 'network-request-failed':
          messAge = "Network request failed";
        case 'too-many-requests':
          messAge = "Too many attempts, try again later";
        case 'user-disabled':
          messAge = "Account disabled";
        default:
          messAge = e.code;
      }
      if (!mounted) return;
      SnackBar sb = SnackBar(
        content: Text("Failed to connect and log ($messAge)"),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
    // on success, _authSubscription updates _isLogged
  }

  void _checkCardSet() {
    String stringToCheck = convCardSet(_cardSet);
    if (!_isLogged) return;
    _resultList = [];
    _requestSubmitDisplay=true;
    _chainSubmitted=true;
    _readIt(stringToCheck);
    _updateHomePageState(99);
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
            final data = docSnapshot.data();
            // Firestore returns whole numbers (e.g. GHG = 0) as int, so read them as num
            _resultList.add(
                ChainResult(sToCheck, (data["Cost"] as num).toDouble(),
                    (data["GHG"] as num).toDouble(),
                    (data["H2O"] as num).toDouble(),
                    (data["Land"] as num).toDouble(),
                    (data["Protest"] as num).toDouble()));
          }
          _resultList = removeDuplicates(_resultList);
        }
        _requestSubmitDisplay=true;
        _isCollapsed=true;
        _chainSubmitted=false;
        _updateHomePageState(99);
      },
      //onError: (e) => print("Error completing: $e"),
    ).catchError((e) {
      // without this, a failed read (network, access rights, bad data) leaves
      // " ... searching ..." on screen forever
      debugPrint("Error reading chain $sToCheck: $e");
      _resultList = [];
      _requestSubmitDisplay = false; // don't claim "No chain" when the read failed
      _chainSubmitted = false;
      _updateHomePageState(99);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Could not read the chains (network or access problem). Please try again."),
        duration: Duration(seconds: 5),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    String varEmail = "";
    String varPass = "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(widget.title,
        style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(onPressed: () async {
            if (_isLogged) {
              _signOut();
            } else {
              final bool? loginPressed = await showDialog<bool>(context: context,
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
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'ABC123',
                            icon: Icon(Icons.password),
                          )),
                      TextButton(
                          child: const Text('Login'),
                          onPressed: () => Navigator.pop(context, true)
                      ), //text button
                    ],
                  ); //alertdialog
                }, // builder
              ); // ShowDialog
              // dialog closed without pressing Login (tap outside / back): do nothing
              if (loginPressed != true || !mounted) return;
              _checkIn(varEmail, varPass);
            }
          }, //async button log
              child: _isLogged ? const Text("Logged") : const Text(
                  "Not logged")),
        ],
      ),
      body: Stack(
        children:<Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CompleteKeyBoard(
                    fuUpdate: _updateHomePageState,
                    cardSet: _cardSet,
                    fuCheck: _checkCardSet,
                    fuInitCard: _initCardSet),
                if (!_requestSubmitDisplay) Container() else DisplaySubmitResultSummary(
                    resultList: _resultList,
                    fu: _getStateSearching),
              ],
            ),
          ),
          if ((_requestSubmitDisplay)&&(_resultList.isNotEmpty))
            AnimatedPositioned(
              duration:const Duration(milliseconds: 300),
              left:0,
              bottom:(_isCollapsed)?(-40-min(_resultList.length,6)*32):-40,
              child: BottomDrawerWidget(resultList: _resultList, isCollapsed: _isCollapsed, fuToggle: _toggleCollapse)
          )
        ]
      )
    );
  } //widget Build
}

List<ChainResult> removeDuplicates(List<ChainResult> listCr){
  List<ChainResult> dummy=[];
  bool testVal=false;
  for(ChainResult cr in listCr){
      testVal=false;
      for(ChainResult xr in dummy){
        if (xr.testEqual(cr)) testVal=true;
      }
      if (!testVal) dummy.add(cr);
    }
  dummy.sort((a, b) => a.cost.compareTo(b.cost));
	return dummy;
}

