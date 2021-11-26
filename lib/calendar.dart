import 'package:datenite/restaurants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets.dart';
import "package:flutter_calendar_carousel/" "flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

DateTime currentDate = DateTime.now();

class Calendar extends StatefulWidget {

  final String title;
  const Calendar(this.title);

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
        DateTime(2021, 11, 27): [
          Event(
            date: DateTime(2021, 11, 27),
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
              )],
          ),
        ),
        body: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                    children: [
                      calendarTopContainer(widget.title,context),
                      SizedBox(height: 10),
                      SizedBox(height: 450, child:
                      Column(
                          children: [
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: CalendarCarousel<Event>(
                                      thisMonthDayBorderColor: Colors.transparent,
                                      daysHaveCircularBorder: true,
                                      markedDatesMap: markedDateMap,
                                      selectedDateTime: currentDate,
                                      todayBorderColor: Color(Colors.grey[800]!.value),
                                      todayButtonColor: Colors.transparent,
                                      todayTextStyle: TextStyle(color:Colors.black),
                                      minSelectedDate: DateTime.now().subtract(Duration(days:1)),
                                      selectedDayButtonColor: Color(Colors.red[400]!.value),
                                      selectedDayBorderColor: Colors.transparent,
                                      selectedDayTextStyle: TextStyle(color: Colors.white),
                                      weekdayTextStyle:  TextStyle(
                                        color: Colors.black,
                                      ),
                                      weekendTextStyle: TextStyle(
                                        color: Color(Colors.red[400]!.value),
                                      ),
                                      headerTextStyle: TextStyle(
                                        fontSize: 22,
                                        color: Color(Colors.red[400]!.value)
                                      ),
                                      iconColor: Colors.black,
                                      headerMargin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      weekDayFormat: WeekdayFormat.narrow,
                                      onDayPressed: (DateTime date, List<Event> events) {
                                        this.setState(() => currentDate = date);
                                        events.forEach((event) => print(event.title));
                                      },
                                    )
                                ))
                          ]),
                      ),
                      Container(
                          height:40,
                          width: 200,
                          child: ElevatedButton(onPressed: (){
                            var client = RestaurantsClient();
                            client.getConnection();
                            }, child: Text('Let\'s plan!',style:
                          TextStyle(fontSize: 18),
                          ),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[700])))
                      )
                      // Divider(color: Colors.grey,thickness: 2,indent: 10,endIndent: 10),
                      // Container(height: 200, width: MediaQuery.of(context).size.width,
                      //     child: ListView())
                    ]
                  )
              ),
              Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                  onPressed: ()=> Navigator.pop(context))),
            ],
        ),
    );
  }
}