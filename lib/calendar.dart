import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets.dart';
import "package:flutter_calendar_carousel/" "flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';

DateTime currentDate = DateTime.now();

class Calendar extends StatefulWidget {
  // Calendar({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _CalendarState createState() =>  _CalendarState();
}

class _CalendarState extends State<Calendar> {
  displayToast(){
    Fluttertoast.showToast(msg: 'Selected');
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    EventList<Event> markedDateMap = EventList<Event>(
      events: {
        DateTime(20201, 11, 2): [
          Event(
            date: DateTime(2021, 11, 2),
            title: 'Event 1',
            icon: const Icon(Icons.circle),
            dot: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              //color: Colors.green,
              height: 5.0,
              width: 5.0,
            ),
          ),
        ],
      },
    );
    return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Text('Drawer Header')),
              ListTile(
                title: const Text('Item 1'),
                onTap: (){
                },
              )
            ],
          ),
        ),

        // body: Container(),
        body: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                    children: [
                      calendarTopContainer(),
                      SizedBox(height: 30),
                      //SizedBox(height: 500, child:  calendarWidget(),),

                      SizedBox(height: 500, child:
                      Column(
                          children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: CalendarCarousel<Event>(
                                      thisMonthDayBorderColor: Colors.grey,
                                      daysHaveCircularBorder: true,
                                      markedDatesMap: markedDateMap,
                                      selectedDateTime: currentDate,
                                      todayBorderColor: Colors.black,
                                      todayButtonColor: Color(Colors.red[300]!.value),
                                      weekdayTextStyle:  TextStyle(
                                        color: Colors.black,
                                      ),
                                      weekendTextStyle: TextStyle(
                                        color: Color(Colors.red[300]!.value),
                                      ),
                                      headerTextStyle: TextStyle(
                                        fontSize: 20,
                                        color: Color(Colors.red[300]!.value),
                                      ),
                                      iconColor: Colors.black,
                                      headerMargin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      weekDayFormat: WeekdayFormat.narrow,
                                      onDayPressed: (DateTime date, List<Event> events) {
                                        this.setState(() => currentDate = date);
                                        events.forEach((event) => print(event.title));
                                      },
                                    )
                                ))
                          ]),
                      ),
                    ]
                  )
              ),
              Positioned(left: 5, top: 35, child: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
                  onPressed: ()=> Navigator.pop(context))),
            ],
        ),
    );
  }
}


class MenuOption extends StatelessWidget{

  final String text;
  final String subtext;
  final Function function;
  final String image;

  const MenuOption( this.text, this.subtext, this.function, this.image);

  @override
  Widget build(BuildContext context) {
    return _buildOption(this.text, this.subtext, this.function, this.image);
  }

  Widget _buildOption(text, subtext, Function f, String img){
    return ElevatedButton(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 5),
            Image(image: AssetImage(img), height: 90, width: 90),
            Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    Text(subtext, style: TextStyle(color: Colors.white,fontSize: 15))
                  ],))
          ]
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red[800] as Color),
          fixedSize: MaterialStateProperty.all<Size>(Size(350, 120)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),side: BorderSide(color: Colors.red)),
          )
      ), onPressed: () => f(),
    );
  }
}