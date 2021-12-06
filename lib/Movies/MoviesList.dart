import 'package:datenite/Movies/film.dart';
import 'package:datenite/Movies/moviesClient.dart';
import 'package:datenite/date_creation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';
import 'package:datenite/calendar.dart';
import 'moviesModel.dart';
import '../appointment.dart';

class MoviesList extends StatelessWidget{
  bool newDate = true;

  MoviesList(MoviesClient client, [newDate]){
    if (newDate!=null){
      this.newDate = newDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Film>>(
        future: client.getFilms(client.cinemaId),
        builder: (context, AsyncSnapshot<List<Film>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Column(
                              children: [
                                calendarTopContainer('Movies Near You', context),
                                SizedBox(height: 20),
                                Column(
                                    children:
                                    snapshot.data!.map((film) =>
                                        Column(children: [
                                          FilmButton(film, context, newDate),
                                          SizedBox(height: 20)
                                        ])).toList()
                                )])),
                      Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                          onPressed: ()=> Navigator.pop(context))),
                    ]));
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


class FilmButton extends StatelessWidget{

  final Film film;
  final parentContext;
  bool newDate = true;

  FilmButton(this.film, this.parentContext, [newDate]){
    if (newDate!=null){
      this.newDate = newDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.film);
  }

  Widget _buildButton(film) {
    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.red[700],
      ),
          margin: const EdgeInsets.all(10),
          width: 350,
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                        child: Image(image: NetworkImage(film.posterUrl), height: 210)),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                        children: [
                          Text(film.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Runtime: ${film.runtime} Minutes', style: TextStyle(color: Colors.white, fontSize: 14))
                    ])
                )]),
            Divider(color: Colors.white, thickness: 4),
            Container(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5),
                      itemCount: film.showtimes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          onPressed: () {
                            print('okay');
                            print('${film.showtimes[index]}');
                            print(film.posterUrl);
                            String address = client.cinema.address.toString() +
                                ' ' + client.cinema.city.toString() +
                                ', ' + client.cinema.state.toString();
                            Appointment currentApt = Appointment(film.name, currentDate, film.showtimes[index], address, 'Movie',null, film.posterUrl);
                            if (newDate == false){
                               currentApt = Appointment(film.name, currentDate, film.showtimes[index], address, 'Movie', currentAptId, film.posterUrl);
                            }
                            print("FOURTH CALL_________");
                            print(currentAptId);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DateCreation(currentApt, false, newDate)));


                          },
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(Size(95,40)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white as Color)),
                          child: Text(film.showtimes[index], style: TextStyle(color: Colors.red,fontSize: 14)),
                        );
                      })),
            SizedBox(height: 10)
          ])),
            onTap:(){
            print(film.id);
            client.film = film;
            showDialog(context: this.parentContext, builder: (BuildContext) => _filmInfoPopup(this.parentContext));
          },
    );
  }
}

Widget _filmInfoPopup(BuildContext context) {
  return FutureBuilder(
      future: client.getFilmInfo(client.film.id),
      builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
          return GestureDetector(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView (
                  padding: EdgeInsets.fromLTRB(10,50,10,50), // may vary by device
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                  ),
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(client.film.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                                    Divider(thickness: 2),
                                    //could make this an image carousel later since there are often multiple images
                                    Image(image: NetworkImage(snapshot.data.imageUrl)),
                                    Divider(thickness: 2),
                                    Text('Genre: ${snapshot.data.genre}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                    Divider(thickness: 2),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                        children: [
                                          TextSpan(text: 'Synopsis: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          TextSpan(text: snapshot.data.synopsis)
                                        ]
                                      ),),
                                    Divider(thickness: 2),
                                    Text('Cast', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    SizedBox(height: 10),
                                    Container(
                                        height: 80,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder: (BuildContext context, int index) => SizedBox(width: 5),
                                            itemCount: snapshot.data.cast.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ElevatedButton(
                                                onPressed: () { print('okay');},
                                                style: ButtonStyle(
                                                    fixedSize: MaterialStateProperty.all<Size>(Size(95,70)),
                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red as Color)),
                                                child: Text(snapshot.data.cast[index], style: TextStyle(color: Colors.white,fontSize: 14)),
                                              );
                                            })),
                                    SizedBox(height: 20),
                                ],),
                              ))])]
            ))),
          onTap: (){Navigator.pop(context);},
          );}
      else {
        return Scaffold(
          backgroundColor: Colors.transparent,
            body:
        Padding(
            padding: const EdgeInsets.all(180),
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator(color: Colors.white,)]
            )));
      }
      });
}