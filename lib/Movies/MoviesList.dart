import 'package:date_format/date_format.dart';
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
                                          FilmButton(film, context),
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

  const FilmButton(this.film, this.parentContext);

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
                          onPressed: () { print('okay');},
                          style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(Size(95,40)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white as Color)),
                          child: Text(film.showtimes[index], style: TextStyle(color: Colors.red,fontSize: 14)),
                        );
                      })),
            SizedBox(height: 10)
          ])),
            onTap:(){
            client.movieId = film.id;
            showDialog(context: this.parentContext, builder: (BuildContext) => _buildPopupDialog(this.parentContext));
          },
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return FutureBuilder(
      future: client.getFilmInfo(client.movieId),
      builder: (context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(snapshot.data.synopsis)
                          ],),
                          )])]
  ));}
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
      });
}