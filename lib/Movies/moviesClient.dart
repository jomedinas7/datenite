import 'dart:convert';
import 'package:datenite/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'cinema.dart';
import 'film.dart';

class MoviesClient{
  var cinemaId;
  late Film film;
  var cinema;
  /* These are the testing credentials, they don't show nearby data yet
  When we know everything works we can swap them for the real credentials
  The real credentials only have ~70 requests left, testing have 10,000 */

  Map<String,String> get headers =>{
    "client": "NONE_78",
    "x-api-key": "mx3jlKFMml9o4ojHkZTQn60Vv3owq6Xc8TGqkgLH",
    "authorization": "Basic Tk9ORV83ODpFUVZHaXN1S0gxQ3A=",
    "territory": "US",
    "api-version": "v200",
    "geolocation": "31.772543;-106.460953",
    "device-datetime": currentDate.toIso8601String(),
  };



  getFilmInfo(id) async {
    var url = "https://api-gate2.movieglu.com/filmDetails/?film_id=$id";
    var response = await http.get(Uri.parse(url), headers: headers);
    var parsedBody = jsonDecode(response.body);
    return createFilmInfo(parsedBody);
  }

  createFilmInfo(body){
    List cast = [];
    body['cast'].forEach((actor) {
        cast.add(actor['cast_name']);
      });

    //Need to check every field for null
    FilmInfo info = FilmInfo(body['images']['still']['1']['medium']['film_image'],
      body['synopsis_long'],body['distributor'],
      body['genres'][0]['genre_name'],cast);
    print(info.genre);
    if (body['trailers'] != null){
      info.trailerUrl = body['trailers']['high'][0]['film_trailer'];
    }
    return info;
  }

  Future<List<Film>> getFilms(id) async {
    var url = "https://api-gate2.movieglu.com/cinemaShowTimes/?cinema_id=$id&date=2021-12-01";
    var response = await http.get(Uri.parse(url), headers: headers);
    var parsedBody = jsonDecode(response.body);
    return createFilms(parsedBody['films']);
  }

  List<Film> createFilms(body){

    List<Film> films = [];

    body.forEach((film) {
      print(film['film_name']);
      print(film['film_id']);

      List showTimes = [];
      film['showings']['Standard']['times'].forEach((showtime){
        var time = DateFormat.jm().format(DateFormat.Hm().parse(
            showtime['start_time']));
        showTimes.add(time);
      });


      var endtime = DateFormat.jm().format(DateFormat.Hm().parse(
          film['showings']['Standard']['times'][0]['end_time']));
      print(endtime);


      DateTime start = DateFormat.jm().parse(showTimes[0]);
      print(start);
      DateTime end = DateFormat.jm().parse(endtime);

      Duration dif = end.difference(start);

      // TODO: Check all queries for null, then add them...otherwise app hangs
      films.add(Film(film['film_id'],
          film['film_name'],film['version_type'],
          film['age_rating'],
          film['images']['poster']['1']['medium']['film_image'],
          showTimes,dif.inMinutes.toString()));

    });

    print('Done');
    return films;
  }
  Future <List<Cinema>> getCinemas() async {
    var url = "https://api-gate2.movieglu.com/cinemasNearby/?n=10";
    var response = await http.get(Uri.parse(url), headers: headers);

    var parsedBody = jsonDecode(response.body);


    return createCinemas(parsedBody['cinemas']);
  }

  List<Cinema> createCinemas(body){
    List<Cinema> cinemas = [];

    body.forEach((cinema) =>
        cinemas.add(Cinema(cinema['cinema_id'],cinema['cinema_name'],
            cinema['address'],cinema['address2'], cinema['city'],cinema['state'],
            cinema['county'],cinema['postcode'],cinema['logo_url']))
    );
   return cinemas;
  }
}
