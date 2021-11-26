import 'dart:convert';
import 'package:http/http.dart' as http;


class RestaurantsClient{
  Map<String,String> get headers =>{
    "client": "NONE_78",
    "x-api-key": "wWKfWC6IO51Wi8jeNEsSW7MI0oo0I53246whJrGc",
    "authorization": "Basic Tk9ORV83OF9YWDpVbGpJTmVoVDRyTWE=",
    "territory": "XX",
    "api-version": "v200",
    "geolocation": "-22.0;14.0",
    "device-datetime": DateTime.now().toIso8601String(),
  };


  getConnection() async {
    var url = "https://api-gate2.movieglu.com/filmsNowShowing/?n=2";
    var response = await http.get(Uri.parse(url), headers: headers);
    print('Response code: ${response.statusCode}');
    //print('Response body: ${response.body}');

    var parsedBody = jsonDecode(response.body);
    print(parsedBody);
  }
}

