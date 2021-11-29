import 'dart:convert';
import 'dart:io';
import 'package:datenite/Restaurants/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:invert_colors/invert_colors.dart';


class RestaurantsClient{
  var restaurantId;
  var menu;

  Map<String,AssetImage> foodImgs = {
    'Barbecue': AssetImage('images/food/Barbecue.png'),
    'Breakfast': AssetImage('images/food/Breakfast.png'),
    'Steak': AssetImage('images/food/Steak.png'),
    'Mexican': AssetImage('images/food/Tacos.png'),
    'Diner': AssetImage('images/food/Breakfast.png'),
    'Burgers': AssetImage('images/food/Burgers.png'),
    'Sandwiches': AssetImage('images/food/Sandwiches.png'),
    'Soups': AssetImage('images/food/Soups.png'),
    'Chicken': AssetImage('images/food/Chicken.png'),
    'Smoothies & Juices': AssetImage('images/food/Smoothies & Juices.png'),
    'Seafood': AssetImage('images/food/Seafood.png'),
    'Coffee & Tea': AssetImage('images/food/Coffee & Tea.png'),
    'Pasta': AssetImage('images/food/Pasta.png'),
    'Pizza': AssetImage('images/food/Pizza.png'),
    'Bakery & Pastries': AssetImage('images/food/Bakery & Pastries.png'),
    'Hot Dogs': AssetImage('images/food/Hot Dogs.png'),
    'Wraps': AssetImage('images/food/Wraps.png'),
    'Salads': AssetImage('images/food/Salads.png'),
    //'American': AssetImage('images/food/Burgers.png'),
    //'Italian': AssetImage('images/food/Pasta.png'),
  };


  Map<String,String> get headers =>{
    "x-api-key": "d1c94f721d86e3e3b812d5681f5cf7ad"
  };

  Future<List<Restaurant>> getRestaurantsByZIP(zip) async {
    var url = 'https://api.documenu.com/v2/restaurants/zip_code/$zip?fullmenu=true';
    var response = await http.get(Uri.parse(url), headers: headers);
    var parsedBody = json.decode(response.body);
    //print(parsedBody['data']); // data is an [] array of restaurants data
    return createRestaurants(parsedBody['data']);
  }

  List<Restaurant> createRestaurants(resArr) {

    List<Restaurant> restaurants = [];

    resArr.forEach((res){
      print(res['restaurant_name']);
      restaurants.add(
          Restaurant(res['restaurant_name'],res['restaurant_phone'],
              res['restaurant_website'], res['restaurant_id'],res['cuisines'] ,res['address']['formatted'],
            res['menus']
          ));
    });
    print('Done');
    return restaurants;
  }

  createFoodWidget(cuisines){

    List foods = [];
    for(var i = 0; i < cuisines.length; i++){
      if(cuisines[i] == 'American' || cuisines[i] == 'Italian' || cuisines[i] == 'Tex-Mex'){
        continue;
      }else{
        foods.add(cuisines[i]);
      }
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: foods.length,
      separatorBuilder: (BuildContext context, int index) =>SizedBox(width: 20),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: [
              InvertColors(
                child: Image(image: foodImgs[foods[index]] as AssetImage, height: 50,width: 50)),
              Text(foods[index], style: TextStyle(color: CupertinoColors.white),)
            ],
          ),
        );
      },

    );
  }

}