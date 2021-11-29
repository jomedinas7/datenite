import 'package:datenite/Restaurants/RestaurantsClient.dart';
import 'package:datenite/Restaurants/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets.dart';
import 'RestaurantsList.dart';

var client = RestaurantsClient();

class RestaurantsPage extends StatelessWidget{
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
                                          RestaurantButton(restaurant),
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

  const RestaurantButton(this.res);

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.res);
  }

  Widget _buildButton(restaurant) {
    return ElevatedButton(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 5),
            //Image(image: NetworkImage(restaurant.logoUrl), height: 90, width: 90),
            Icon(Icons.flatware),
            Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(restaurant.name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(restaurant.address, style: TextStyle(color: Colors.white,fontSize: 15))
                  ],))
          ]
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
          fixedSize: MaterialStateProperty.all<Size>(Size(350, 120)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side: BorderSide(color: Colors.red)),
          )),
      onPressed: () {
        client.restaurantId = res.id;
        print(res.id);
        Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => RestaurantsList(client)));
      },);
  }

}