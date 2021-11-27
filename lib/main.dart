import 'package:datenite/Movies/moviesClient.dart';
import 'package:datenite/sign_up_page.dart';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'sign_up_page.dart';
import 'home.dart';
import 'calendar.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late BuildContext globalContext;
bool signedIn = false;

// https://stackoverflow.com/questions/62540012/custom-username-and-password-login-using-flutter-firebase
//https://pub.dev/packages/authentication_provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(MyApp());

  runApp(
      ChangeNotifierProvider<AuthModel>(
        create: (_) => AuthModel(),
        child: MaterialApp(
          home: Consumer<AuthModel>(
            builder: (_, auth, __) => auth.isSignedIn ? Home() : MyApp(),
          ),
        ),
      ),
  );
}


class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return
      MaterialApp(
        title: 'DateNite',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: MyAppPage(title: 'DateNite')
    );
  }
}

class MyAppPage extends StatefulWidget {
  MyAppPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // verifyUser(){
  //   DatabaseReference flutterTest = FirebaseDatabase.instance.reference().child('test');
  //   flutterTest.set("This is a flutter test from the database ${Random().nextInt(100)}");
  //   print(usernameController.text);
  //   // globalContext = context;
  //   Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => Home()));
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Image(image: AssetImage('images/Heart.png'), height: 250, width: 250),
            Text('DateNite',
            style: TextStyle(
                fontFamily: 'Typo',
              fontSize: 55,
              color: Colors.white,
            )),
            Text('Go out in style!',
            style: TextStyle(
              fontFamily: 'Typo',
              fontSize: 25,
              color: Colors.white 
            ),),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 4.0),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Enter valid username',
                  hintStyle:  TextStyle(color: Colors.white),

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value != null && value.length<1) {
                    return 'Enter Something';
                  }
                },
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 4.0),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: 'Enter your secure password',
                    hintStyle:  TextStyle(color: Colors.white),

                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.fromLTRB(125, 12, 125, 12),
                  textStyle: TextStyle(fontFamily: 'Typo', fontSize: 25)
                ),
                onPressed: () async {
                  // verifyUser();

                  globalContext = context;
                  globalContext.read<AuthModel>().signIn(email: usernameController.text.toString(), password: passwordController.text.toString());

                  //notifyListeners();
                  },
                child: Text('Login',
              style: TextStyle(color: Colors.red),
            )
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                globalContext = context;
                Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => SignUp()));
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, fontFamily: 'Typo',fontSize: 20),
              ),
            )
          ]
        ),
      )
    );
  }
}