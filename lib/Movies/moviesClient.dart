import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cinema.dart';


class MoviesClient{

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


  Future <List<Cinema>> getCinemas() async {
    var url = "https://api-gate2.movieglu.com/cinemasNearby/?n=2";
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
