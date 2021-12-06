import 'package:datenite/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../appointment.dart';
import 'package:permission_handler/permission_handler.dart';
import 'place.dart';
import 'PlacesModel.dart';
import 'package:datenite/date_creation.dart';


class NearbyPage extends StatefulWidget {

  @override
  _NearbyPageState createState() =>  _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  displayToast(){
    Fluttertoast.showToast(msg: 'Selected');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
        future: client.getPlacesByZIP(79938),
        builder: (context, AsyncSnapshot<List<Place>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                          children: [
                            dateCreationTop(
                                'Places Nearby', 'subtitle', context),
                            SizedBox(height: 20),
                            Column(
                                children:
                                snapshot.data!.map((place) =>
                                    Column(children: [
                                      LocationButton(
                                          place),
                                      SizedBox(height: 20)
                                    ])).toList()
                            )
                          ]
                      )
                  ),
                  Positioned(
                    left: -8,
                    top: 55,
                    child: IconButton(
                        icon: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 55),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            );
          }
          else {
            return Scaffold(body:
            Padding(
                padding: const EdgeInsets.all(180),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()]
                )));
          }
        }
    );
  }
}

class LocationButton extends StatelessWidget{

  final Place place;

  const LocationButton(this.place);

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.place,context);
  }

  Widget _buildButton(place,context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.red[700]),
        margin: const EdgeInsets.all(10),
        width: 350,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(place.name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(place.address, style: TextStyle(color: Colors.white,fontSize: 15)),
                      SizedBox(height: 10),
                      Container(
                          height: 80,
                          child: client.createFoodWidget(place.cuisine)),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: (){
                        Appointment currentApt = Appointment(place.name, DateTime.now(), '3:00 PM', place.address, 'Food');
                        Navigator.of(context).push(MaterialPageRoute(builder: (globalContext) => DateCreation(currentApt,false)));
                      }, child: Text(
                        'Eat Here', style: TextStyle(color: Colors.red[800]),
                      ), style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(CupertinoColors.white)
                      ),)
                    ],))
            ]
        ));
  }
}