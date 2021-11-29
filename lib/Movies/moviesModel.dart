import 'package:datenite/Movies/MoviesList.dart';
import 'package:datenite/Movies/moviesClient.dart';
import 'package:datenite/home.dart';
import 'package:datenite/main.dart';
import 'package:datenite/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cinema.dart';

var client = MoviesClient();


class CinemasPage extends StatelessWidget{
  

  printID(Cinema cine){
    print(cine.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cinema>>(
        future: client.getCinemas(),
        builder: (context, AsyncSnapshot<List<Cinema>> snapshot) {
          if (snapshot.hasData) {
           return Scaffold(
               body: Stack(
                   children: [
                     SingleChildScrollView(
                       child: Column(
                           children: [
                             calendarTopContainer('Theaters Near You', context),
                             SizedBox(height: 20),
                             Column(
                              children:
                                snapshot.data!.map((cinema) =>
                                  Column(children: [
                                  CinemaButton(cinema),
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

class CinemaButton extends StatelessWidget{

  final Cinema cine;

  const CinemaButton(this.cine);

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.cine);
  }
  Widget _buildButton(cinema) {
    return ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 5),
            Image(image: NetworkImage(cinema.logoUrl), height: 90, width: 90),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cinema.name, style: TextStyle(color: Colors.white, fontSize: 25,
                      fontWeight: FontWeight.bold)),
                  Text(cinema.address, style: TextStyle(color: Colors.white,fontSize: 15))
                ],))
              ]
            ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
            fixedSize: MaterialStateProperty.all<Size>(Size(350, 120)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side:
            BorderSide(color: Colors.red)),
        )),
        onPressed: () {
          client.cinemaId = cinema.id;
          print(cinema.id);
          Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => MoviesList(client)));
        },);
  }

}