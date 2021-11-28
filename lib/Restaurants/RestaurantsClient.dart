import 'dart:convert';
import 'package:datenite/Restaurants/restaurant.dart';
import 'package:http/http.dart' as http;


class RestaurantsClient{
  var restaurantId;
  var menu;

  Map<String,String> get headers =>{
    "x-api-key": "d1c94f721d86e3e3b812d5681f5cf7ad"
  };

  getRestaurantsByZIP(zip) async {
    var url = 'https://api.documenu.com/v2/restaurants/zip_code/$zip?fullmenu=true';
    var response = await http.get(Uri.parse(url), headers: headers);
    var parsedBody = json.decode(response.body);
    print(parsedBody['data']); // data is an [] array of restaurants data
    //return createRestaurants(parsedBody['data']);
  }

  createRestaurants(resArr) {

    List<Restaurant> restaurants = [];

    resArr.forEach((res){
      print(res['restaurant_name']);
      restaurants.add(
          Restaurant(res['restaurant_name'],res['restaurant_phone'],
              res['restaurant_website'], res['restaurant_id'],res['cuisines'] ,res['address']['formatted'],
            res['menus']
          ));

    });

  }


}