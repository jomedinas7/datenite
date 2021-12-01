import 'package:datenite/Movies/moviesClient.dart';
import 'package:datenite/Restaurants/RestaurantsClient.dart';
import 'package:datenite/Restaurants/RestaurantsModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Movies/moviesModel.dart';
import 'widgets.dart';
import "package:flutter_calendar_carousel/" "flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'date_creation.dart';
import 'home.dart';

//TODONE: make sure to push movie date when creating a movie
//TODONE: make sure edit on movies will update properly
//TODONE: add functionality to choose a new showtime button
//TODO: pass an appointment to something new page and change what's displayed
// based on the type of appointment


DateTime currentDate = DateTime.now();
List userCalendarEvents = [];

class Appointment {
  Appointment(String title, DateTime date, String time, String address, String type, [id, String image = '']){
    this.title = title;
    this.date = date;
    this.time = time;
    this.address = address;
    this.type = type;
    if (id!=null){
      this.id = id;
    }
    if (image!=''){
      this.image = image;
    }
  }
  String image = '';
  String id = 'appointment#';
  String title = '';
  DateTime date = DateTime.now();
  String time = '';
  String address = '';
  String type = '';
  bool hasTime() => time != '';
}

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

  setMarkedMap() async {
    userCalendarEvents = await globalContext.read<AuthModel>().setMarkedMapEvents();
  }

  void _showAppointments(DateTime inDate, BuildContext inContext, bool showButton) async {
    showModalBottomSheet(context: inContext,
        builder: (BuildContext inContext) {
          return Scaffold(
              body: Container(child: Padding(
                  padding: EdgeInsets.all(10), child: GestureDetector(
                  child: Column(
                      children: [
                        Text(DateFormat.yMMMMd("en_US").format(inDate
                            .toLocal()), textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red,fontSize:24)),
                        Divider(),
                        Expanded(
                            child: ListView.builder(
                                itemCount: userCalendarEvents.length,
                                itemBuilder: (BuildContext inBuildContext,
                                    int inIndex) {
                                  Appointment appointment =
                                  userCalendarEvents[inIndex];

                                  String date = "${appointment.date.year},${appointment.date.month.toString()},${appointment.date.day.toString()}";
                                  if (date !=
                                      "${inDate.year},${inDate
                                          .month},${inDate
                                          .day}") {
                                    return Container(height: 0);
                                  }
                                  String apptTime = appointment.time;
                                  String apptAddress = appointment.address;
                                  String apptType = appointment.type;

                                  return Slidable(
                                      actionPane: const SlidableDrawerActionPane(),
                                      actionExtentRatio: .25,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 8),
                                          color: apptType == "Movie" ? Colors.red[200] : Colors.purple[100],
                                          child: ListTile(
                                              title: Row(children: [
                                                Text("${appointment.title} "),
                                                Text('$apptTime', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                              ]),
                                              subtitle: Text('$apptAddress', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
                                              onTap: () async {
                                                print("VERY FIRST CALL______________________________________________");
                                                print(appointment.id);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DateCreation(appointment, false, false))); // prevent from going to movies if just editing time for restaurant
                                              })
                                      ),
                                      secondaryActions: [
                                        IconSlideAction(
                                            caption: "Delete",
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () {
                                              _deleteAppointment(context,appointment);
                                            }
                                        )
                                      ]
                                  );
                                }
                            )
                        )
                      ,
                        if (showButton) Container(
                            height:40,
                            width: 600,
                            child: Row(children: [

                              if(widget.title=='My Dates') SizedBox(width:25),
                              if(widget.title=='My Dates') ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => RestaurantsPage(true)));
                                },
                                child:Text('Dinner+Show'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red[700]),)
                              ),
                              if(widget.title=='My Dates') ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CinemasPage()));
                                },
                                child:Text('Movies'),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red[700]),)
                              ),
                              if(widget.title=='My Dates') ElevatedButton(
                                onPressed: (){
                                  Appointment somethingNewApt = Appointment('Custom Date', currentDate, "3:00 PM", 'Custom Address', 'Custom');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DateCreation(somethingNewApt, false)));
                                },
          style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red[700]),),
                                child:Text('Something New'),
                             ),
                              if(widget.title!='My Dates') SizedBox(width:90),
                              if(widget.title!='My Dates')
                              Center(child:
                                  SizedBox(width:200, child:
                              ElevatedButton(
                                  onPressed: (){
                              //var cines = MoviesClient().getCinemas();
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => CinemasPage()));
                              var res = RestaurantsClient().getRestaurantsByZIP(79912);
                              if(widget.title == 'Dinner + Show') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RestaurantsPage(true)));
                              }
                              else if(widget.title == 'Movie Date'){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CinemasPage()));
                              }
                              else if (widget.title == 'Something New'){
                                Appointment somethingNewApt = Appointment('Custom Date', currentDate, "3:00 PM", 'Custom Address', 'Custom');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DateCreation(somethingNewApt, false)));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CinemasPage()));
                              }

                            },child: Text('Let\'s plan!',style: TextStyle(fontSize: 18)),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red[700]),
                                ))
                                  )
                              )
                            ]
                            )

                      )]
                  )
              )
              )
              )
          );
        }
    );
  }

  _deleteAppointment(BuildContext context, Appointment appointment) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Delete Appointment'),
            content: Text('Are you sure you want to delete \'${appointment
                .title}\''),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(alertContext).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  globalContext.read<AuthModel>().deleteAppointment(appointment);
                  Navigator.of(alertContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Appointment deleted')
                      )
                  );
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    EventList<Event> markedDateMap = EventList<Event>(
      events: {
        DateTime(2021, 11, 30): [
          Event(
            date: DateTime(2021, 11, 30),
            title: 'Event 1',
            icon: const Icon(Icons.circle),
            dot: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              decoration: BoxDecoration(color: Colors.red, border: Border.all(color: Colors.black)),
              // color: Colors.red,
              height: 5.0,
              width: 5.0,
            ),
          ),]
      }
    );


    markedDateMap.clear();
    setMarkedMap();

    for (int i =0; i<userCalendarEvents.length; i++) {
      Color color = Colors.red;
      if (userCalendarEvents[i].type == "Food"){
        color = Colors.purple;
      }
      markedDateMap.add(DateTime(userCalendarEvents[i].date.year,userCalendarEvents[i].date.month,userCalendarEvents[i].date.day),
          Event(
            date: DateTime(userCalendarEvents[i].date.year,userCalendarEvents[i].date.month,userCalendarEvents[i].date.day),
            title: userCalendarEvents[i].title,
            icon: const Icon(Icons.circle),
            dot: Container(
              decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black)),
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              height: 5.0,
              width: 5.0,
            ),
          )
      );
    }

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

                                      customDayBuilder: (
                                          bool isSelectable,
                                          int index,
                                          bool isSelectedDay,
                                          bool isToday,
                                          bool isPrevMonthDay,
                                          TextStyle textStyle,
                                          bool isNextMonthDay,
                                          bool isThisMonthDay,
                                          DateTime day,
                                          ) {
                                        if(!isSelectable){
                                          for (int i =0; i<userCalendarEvents.length; i++) {
                                            if (day.year == userCalendarEvents[i].date.year
                                            && day.month == userCalendarEvents[i].date.month
                                            && day.day == userCalendarEvents[i].date.day){
                                              return Center(
                                                  child: Material(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        print("hello");
                                                        _showAppointments(day, context, false);
                                                      },
                                                      child: Container(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          child: Image(image: AssetImage('images/black_heart.png'), height: 20, width: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  )

                                              );
                                            }
                                          }
                                        }
                                        if (isSelectedDay) {
                                          return Center(
                                            child: Image(image: AssetImage('images/Heart.png'), height: 30, width: 30),

                                          );
                                        } else {
                                          return null;
                                        }
                                      },
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
                                        _showAppointments(date, context, true);
                                        this.setState(() => currentDate = date);
                                        events.forEach((event) => print(event.title));
                                      },
                                    )
                                ))
                          ]),
                      ),
                      Container(
                          height:40,
                          decoration: BoxDecoration(
                              color: Colors.red[800],
                          ),
                          child: Center(child:Text('Select a Date!',
                            style:TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      )
                    ]
                  )
              ),
              if (widget.title != "My Dates") Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                  onPressed: () {
                    Navigator.pop(context);
                  }
                  )),
              if (widget.title == "My Dates") Positioned(left: -8, top: 55,
                  child: IconButton(icon:
                  Icon(Icons.menu, color: Colors.white, size: 55),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                  }
              )),
            ],
        ),
    );
  }
}