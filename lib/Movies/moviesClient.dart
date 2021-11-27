import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cinema.dart';
import 'film.dart';


class MoviesClient{
  var cinemaId;
  /* These are the testing credentials, they don't show nearby data yet
  When we know everything works we can swap them for the real credentials
  The real credentials only have ~70 requests left, testing have 10,000 */

  Map<String,String> get headers =>{
    "client": "NONE_78",
    "x-api-key": "wWKfWC6IO51Wi8jeNEsSW7MI0oo0I53246whJrGc",
    "authorization": "Basic Tk9ORV83OF9YWDpVbGpJTmVoVDRyTWE=",
    "territory": "XX",
    "api-version": "v200",
    "geolocation": "-22.0;14.0",
    "device-datetime": DateTime.now().toIso8601String(),
  };


  Future<List<Film>> getFilms(id) async {
    var url = "https://api-gate2.movieglu.com/cinemaShowTimes/?cinema_id=$id&date=2021-11-28";
    var response = await http.get(Uri.parse(url), headers: headers);
    var parsedBody = jsonDecode(response.body);
    return createFilms(parsedBody['films']);
  }

  List<Film> createFilms(body){

    List<Film> films = [];

    body.forEach((film) {
      print(film['film_name']);

      List showTimes = [];
      film['showings']['Standard']['times'].forEach((showtime){
        showTimes.add(showtime['start_time']);
      });

      films.add(Film(film['film_id'], film['imdb_id'],film['imdb_title_id'],
          film['film_name'],film['version_type'],
          film['age_rating'], showTimes));

    });

    print('Done');
    return films;
  }
  Future <List<Cinema>> getCinemas() async {
    var url = "https://api-gate2.movieglu.com/cinemasNearby/?n=10";
    var response = await http.get(Uri.parse(url), headers: headers);

    //print('Response code: ${response.statusCode}');
    //print('Response body: ${response.body}');

    var parsedBody = jsonDecode(response.body);
    //print(parsedBody);
    //print(parsedBody['cinemas']);

    return createCinemas(parsedBody['cinemas']);
  }

  List<Cinema> createCinemas(body){
    List<Cinema> cinemas = [];

    body.forEach((cinema) =>
        //print(cinema)
        cinemas.add(Cinema(cinema['cinema_id'],cinema['cinema_name'],cinema['address'],cinema['address2'],
            cinema['city'],cinema['state'],cinema['county'],cinema['postcode'],cinema['logo_url']))
    );
   //print(cinemas[0].city);
   return cinemas;
  }
}
