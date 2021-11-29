import 'package:datenite/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'calendar.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool get isSignedIn => _auth.currentUser != null;
  User? get currentUser => _auth.currentUser;
  String currentUserFirstName = "Persephone";
  String? get currentUid => _auth.currentUser!.uid;
  List get currentUserInfo => [_auth.currentUser!.uid, _auth.currentUser!.displayName];
  // var get currentUserName => _auth.currentUser!.firstName;

  Future<List> getCollectionList() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    var list = querySnapshot.docs;
    return list;
  }

  Future<void> setFirstNameFromCollection() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    var collections = querySnapshot.docs;
    for (int i = 0; i<collections.length; i++){
      if(collections[i].get('uid') == currentUid){
        currentUserFirstName = collections[i].get('firstName');
        break;
      }
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    var collections = querySnapshot.docs;
    for (int i = 0; i<collections.length; i++){

      if(collections[i].get('uid') == currentUid){
        Map aptMap = collections[i].get('Appointments');

        aptMap['appointment${aptMap.length.toString()}'] =

          {'title' : appointment.title,
            'date' : appointment.date,
            'type' : appointment.type,
            'time' : appointment.time,
            'address' : appointment.address,
          };

        firestore.collection('users')
            .doc(collections[i].id)
            .set({
          'Appointments': aptMap
        },SetOptions(merge: true)).then((value){
        });

        break;
      }
    }
  }

  Future<List> setMarkedMapEvents() async {
    QuerySnapshot querySnapshot = await firestore.collection("users").get();
    var collections = querySnapshot.docs;
    List appointmentList = [];
    for (int i = 0; i<collections.length; i++){
      if(collections[i].get('uid') == currentUid){
        Map aptMap = collections[i].get('Appointments');

        for(var v in aptMap.keys) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(aptMap[v]['date'].seconds * 1000);
          appointmentList.add(
              Appointment(
                  aptMap[v]['title'],
                  date,
                  aptMap[v]['time'],
                  aptMap[v]['address'],
                  aptMap[v]['type'])
          );
        }

        return appointmentList;

      }
    }
    return appointmentList;
  }


  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      signedIn = true;
      print("Signed in");
      notifyListeners();
      Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => Home()));
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());


      Fluttertoast.showToast(msg: e.message.toString());
      // showDialog(context: globalContext, builder: (_) => CupertinoAlertDialog(
      //   title: Text(e.message.toString()),
      // ),
      // );
    }
  }

  Future<void> signUp(
      {required String email, required String password,
        required String firstName, required String lastName}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = _auth.currentUser;
      firestore.collection("users").add({
        'uid': user?.uid,
        'firstName': firstName,
        'lastName': lastName,
      }
      );
      print("Signed Up");
      notifyListeners();
      Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => MyApp()));
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}