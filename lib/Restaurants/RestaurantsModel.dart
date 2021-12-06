import 'package:datenite/Restaurants/RestaurantsClient.dart';
import 'package:datenite/Restaurants/restaurant.dart';
import 'package:datenite/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets.dart';
import 'package:datenite/date_creation.dart';
import '../appointment.dart';

var client = RestaurantsClient();

class RestaurantsPage extends StatelessWidget{

  final includesMovie;

  RestaurantsPage(this.includesMovie);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
        future: client.getRestaurantsByZIP(79912),
        builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Column(
                              children: [
                                calendarTopContainer('Restaurants Near You', context),
                                SizedBox(height: 20),
                                Column(
                                    children:
                                    snapshot.data!.map((restaurant) =>
                                        Column(children: [
                                          RestaurantButton(restaurant, includesMovie),
                                          SizedBox(height: 20)
                                        ])).toList()
                                )])),
                      Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                          onPressed: ()=> Navigator.pop(context))),]));
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

class RestaurantButton extends StatelessWidget{

  final Restaurant res;
  final includesMovie;

  const RestaurantButton(this.res, this.includesMovie);

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.res);
  }

  Widget _buildButton(restaurant) {
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
                    Text(restaurant.name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(restaurant.address, style: TextStyle(color: Colors.white,fontSize: 15)),
                    SizedBox(height: 10),
                    Container(
                        height: 80,
                        child: client.createFoodWidget(restaurant.cuisine)),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: (){
                      Appointment currentApt = Appointment(restaurant.name, currentDate, '3:00 PM', restaurant.address, 'Food');
                      Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => DateCreation(currentApt, includesMovie)));
                    }, child: Text(
                      'Eat Here', style: TextStyle(color: Colors.red[800]),
                    ), style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(CupertinoColors.white)
                    ),)
                  ],))
          ]
      ));
      // style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
      //     fixedSize: MaterialStateProperty.all<Size>(Size(350, 120)),
      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side: BorderSide(color: Colors.red)),
      //     )),
      // onPressed: () {
      //   client.restaurantId = res.id;
      //   print(res.id);
      //   Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => RestaurantsList(client)));
      // },);
  }

}