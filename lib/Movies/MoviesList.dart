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
            Image(image: NetworkImage(film.posterUrl), height: 165),
            SizedBox(width: 20),
            Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(film.name, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(film.showtimes[0], style: TextStyle(color: Colors.white,fontSize: 15))
                  ],))
          ]
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
          fixedSize: MaterialStateProperty.all<Size>(Size(350, 180)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side: BorderSide(color: Colors.red)),
          )),
      onPressed: () {
        //print(film.id);
        Navigator.of(globalContext).push(MaterialPageRoute(builder: (globalContext) => Scaffold()));
      },);
  }

}