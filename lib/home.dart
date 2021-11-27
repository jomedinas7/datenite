import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'calendar.dart';
import 'sign_up_page.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

toCalendar(title){
  Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => Calendar(title)));
}

class Home extends StatelessWidget{
  displayToast(){
    Fluttertoast.showToast(msg: 'Selected');
  }

  signOut() async {
    print("WOOOO");
    String firstName = globalContext.read<AuthModel>().currentUserFirstName;
    // List collections = await globalContext.read<AuthModel>().getCollectionList();
    // for (int i =0; i<collections.length; i++){
    //   print(collections[0].get('firstName'));
    // }
    print("____________________________________________");
    print(firstName);
    print("________________________________________");
    print(globalContext.read<AuthModel>().isSignedIn);
    print(globalContext.read<AuthModel>().currentUser);
    print(globalContext.read<AuthModel>().currentUserInfo);
    globalContext.read<AuthModel>().signOut();

    Navigator.push(globalContext, MaterialPageRoute(builder: (globalContext) => MyApp()));
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    globalContext = context;
    globalContext.read<AuthModel>().setFirstNameFromCollection();
    String firstName = globalContext.read<AuthModel>().currentUserFirstName;


    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Text('Drawer Header')),
            ListTile(
              title: const Text('Item 1'),
              onTap: (){
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
        SingleChildScrollView(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20,90,10,40),
                decoration: BoxDecoration(
                color: Colors.red[800],
                borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 225,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(backgroundImage: AssetImage('images/defaultUser.png'),
                        minRadius: 40,),
                        SizedBox(width: 10),
                        Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                          Container(height: 30, child: Text('Hello',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28))),
                            Container(height: 30, child: Text(' $firstName!',
                                style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 28))),
                           ]),
                          SizedBox(height: 10),
                          Container(width: 200, height: 50,child: Text('What are you in the mood for?',
                          style: TextStyle(color: Colors.white, fontSize: 20))),
                        ])],),),])),
              SizedBox(height: 30),
              MenuOption('Dinner + Show', 'A timeless classic', toCalendar, 'images/wineHearts.png'),
              SizedBox(height: 30),
              MenuOption('Movie Date', 'Keep it simple', signOut, 'images/film.png'),
              SizedBox(height: 30),
              MenuOption('Something New', 'Be original', toCalendar, 'images/art.png'),
              SizedBox(height: 30),
              MenuOption('Ask Your Date', 'Send them a link', toCalendar, 'images/defaultUser.png'),
              SizedBox(height: 50)
            ],)),Positioned(left: 5, top: 35, child: IconButton(icon: Icon(Icons.menu, color: Colors.white, size: 35),
              onPressed: ()=> scaffoldKey.currentState!.openDrawer())),
        ]));
  }
}


class MenuOption extends StatelessWidget{

  final String text;
  final String subtext;
  final Function function;
  final String image;

  const MenuOption( this.text, this.subtext, this.function, this.image);

  @override
  Widget build(BuildContext context) {
    return _buildOption(this.text, this.subtext, this.function, this.image);
  }

  Widget _buildOption(text, subtext, Function f, String img){
    return ElevatedButton(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 5),
            Image(image: AssetImage(img), height: 90, width: 90),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                  Text(subtext, style: TextStyle(color: Colors.white,fontSize: 15))
              ],))
          ]
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
          fixedSize: MaterialStateProperty.all<Size>(Size(350, 120)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side: BorderSide(color: Colors.red)),
          )
      ), onPressed: () {
      if (f.toString() == 'Closure: (dynamic) => dynamic from Function \'toCalendar\': static.'){
        f(this.text);
      }
    if (f.toString() == 'Closure: (Cinema) => dynamic from Function \'printID\':.'){
      f();
    }
      else{f();}
      },
    );
  }
}