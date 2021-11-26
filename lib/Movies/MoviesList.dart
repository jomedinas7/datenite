import 'package:datenite/Movies/film.dart';
import 'package:datenite/Movies/moviesClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets.dart';
import 'cinema.dart';
import 'moviesModel.dart';

class MoviesList extends StatelessWidget{

  MoviesList(MoviesClient client);

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
                                          FilmButton(film),
                                          SizedBox(height: 20)
                                        ])).toList()
                                )]))]));
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

  const FilmButton(this.film);

  @override
  Widget build(BuildContext context) {
    return _buildButton(this.film);
  }
  Widget _buildButton(film) {
    return ElevatedButton(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 5),
            Image(image: AssetImage('images/film.png'), height: 90, width: 90),
            Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(film.name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(film.showtimes[0].start, style: TextStyle(color: Colors.white,fontSize: 15))
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
        //print(film.id);
        Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => Scaffold()));
      },);
  }

}