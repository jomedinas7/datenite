import 'package:datenite/Movies/moviesClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cinema.dart';



class CinemasPage extends StatelessWidget{
  
  var client = MoviesClient();  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cinema>>(
        future: client.getCinemas(),
        builder: (context, AsyncSnapshot<List<Cinema>> snapshot) {
          if (snapshot.hasData) {
           return Scaffold(
               body: ListView(
                children:
                  snapshot.data!.map((cinema) =>
                  Container(
                    height: 200,
                    width: 200,
                    child: Text(cinema.name),
                  )).toList()
            ,
           ));
          } 
          else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}

//
// class CinemasPage extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => _CinemasPageState();
//
// }
//
// class _CinemasPageState extends State<CinemasPage>{
//
//   MoviesClient client = MoviesClient();
//
//   @override
//   Future<Widget> build(BuildContext context) async {
//     var cines = client.getCinemas();
//     return Scaffold(
//       body: ListView(
//         children: [
//           await Stream.fromIterable((responseNewsList as List)
//               .skip(skipItems)
//               .take(20))
//               .asyncMap((id) =>  this.fetchNewsDetails(id))
//               .toList()
//         ],
//       ),
//     )
//   }
//
// }