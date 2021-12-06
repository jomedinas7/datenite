import 'package:datenite/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'calendar.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'Authentication/authentication_service.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'Places/nearby.dart';



setMarkedMap() async {
  userCalendarEvents = await globalContext.read<AuthModel>().setMarkedMapEvents();
}

toCalendar(title){
  Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => Calendar(title)));
}

toNearbyPage(){
  Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => NearbyPage()));
}

toMessage() async {
  var status = await Permission.sms.status;
  await Permission.sms.shouldShowRequestRationale;
  if(status.isDenied){
    status = await Permission.sms.request();
    if(await status.isGranted){
      Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => MessageScreen()));
    }
    else{
      Fluttertoast.showToast(msg: "SMS Permissions must be enabled to access this feature.",
      gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: CupertinoColors.white
      );
    }
  }else{
    Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => MessageScreen()));
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() =>  _HomeState();
}

class _HomeState extends State<Home> {
  displayToast(){
    Fluttertoast.showToast(msg: 'Selected');
  }

  signOut() async {
    print("WOOOO");
    String firstName = globalContext.read<AuthModel>().currentUserFirstName;
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

  initState() {
    super.initState();
    loadDataFromModel();
  }

  void loadDataFromModel() async {
    await globalContext.read<AuthModel>().setFirstNameFromCollection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    globalContext.read<AuthModel>().setFirstNameFromCollection();
    String firstName = globalContext.read<AuthModel>().currentUserFirstName;
    setState(() {
     firstName = firstName;
    });
    setMarkedMap();

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
                child: Text('Menu')),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () => signOut(),
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
              MenuOption('Movie Date', 'Keep it simple', toCalendar, 'images/film.png'),
              SizedBox(height: 30),
              MenuOption('Something New', 'Be original', toNearbyPage, 'images/art.png'),
              SizedBox(height: 30),
              MenuOption('Ask Your Date', 'Send them a link', toMessage, 'images/defaultUser.png'),
              SizedBox(height: 50)
            ],)),Positioned(left: 5, top: 35, child: IconButton(icon: Icon(Icons.menu, color: Colors.white, size: 35),
              onPressed: ()=> scaffoldKey.currentState!.openDrawer())),
          Positioned(right: 5, top: 35, child: IconButton(icon: Icon(Icons.favorite, color: Colors.white, size: 35),
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

class MessageScreen extends StatelessWidget{

  final _numberKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                      children: [
                        calendarTopContainer('Ask Your Date', context),
                        SizedBox(height: 20),
                        Column(
                            children: [
                              SizedBox(height: 50),
                              Padding(padding: EdgeInsets.all(20), child:
                              TextFormField(
                                controller: controller,
                                key: this._numberKey,
                                cursorColor: Colors.red,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "(555)-555-5555",
                                    label: Text("Phone Number"),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:BorderRadius.circular(10.0),
                                      borderSide: BorderSide(color: Colors.red, width: 2)
                                    )
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cannot be left empty';
                                  }
                                },
                              )),
                              SizedBox(height: 50),
                              ElevatedButton(onPressed: (){_sendSMS('Hey, let\'s plan a date on DateNite.'
                                  ' https://play.google.com/store/apps/details?id=com.chickfila.cfaflagship&hl=en_US&gl=US', [controller.text.toString()]);},
                                  child: Text('Send'),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red[800]),
                                  fixedSize: MaterialStateProperty.all(Size(200, 50))
                                  ) ,)
                            ]
                        ),])
    ),
            Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                onPressed: (){
                  Navigator.pop(context);
                  // if(this.controller.value != '') {
                  //   controller.dispose();
                  // }
        }))]
        ));
  }
}