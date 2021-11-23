import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            Image(image: AssetImage('images/Heart.png'), height: 275, width: 275),
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
            SizedBox(height: 50),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.fromLTRB(125, 12, 125, 12),
                  textStyle: TextStyle(fontFamily: 'Typo', fontSize: 25)
                ),
                onPressed: () {
                  globalContext = context;
                  Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => Home()));
                },
                child: Text('Login',
              style: TextStyle(color: Colors.red),
            )
            ),
            SizedBox(height: 20),
            GestureDetector(
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
