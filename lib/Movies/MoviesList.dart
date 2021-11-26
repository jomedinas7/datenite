import 'package:datenite/Movies/moviesClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';
import 'cinema.dart';
import 'moviesModel.dart';

class MoviesList extends StatelessWidget{
  var client = MoviesClient();

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
                                calendarTopContainer('Movies Near You', context),
                                SizedBox(height: 20),
                                Column(
                                    children:
                                    snapshot.data!.map((cinema) =>
                                        Column(children: [
                                          CinemaButton(cinema),
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