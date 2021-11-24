import 'package:datenite/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'home.dart';
import 'calendar.dart';

late BuildContext globalContext;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DateNite',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'DateNite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  verifyUser(){
    print(usernameController.text);
    globalContext = context;
    Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => Home()));
  }

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
              child: TextField(
                controller: passwordController,
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
                onPressed: () {
                  verifyUser();
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
