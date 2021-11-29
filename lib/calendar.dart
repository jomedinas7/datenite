import 'package:datenite/Movies/moviesClient.dart';
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
import 'package:scoped_model/scoped_model.dart';

DateTime currentDate = DateTime.now();
List userCalendarEvents = [];

class Appointment {
  Appointment(String title, DateTime date, String time, String address, String type){
    this.title = title;
    this.date = date;
    this.time = time;
    this.address = address;
    this.type = type;
  }
  String title = '';
  DateTime date = DateTime.now();
  String time = '';
  String address = '';
  String type = '';
  bool hasTime() => time != '';
}

List<Appointment> aptList = [Appointment("Raiders of the Lost Ark", DateTime.now(), "2:30 PM", "12704 Montana Ave, El Paso, TX 79938", "Movie"), Appointment("Olive Garden", DateTime.now(), "4:30 PM", "300 Mesa St, El Paso, TX 79902","Food"),];

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
          // globalContext.read<AuthModel>().addAppointment(aptList[1]);

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
                                  // if (appointment.time != '') {
                                  //   List timeParts = appointment.time
                                  //       .split(",");
                                  //   TimeOfDay at = TimeOfDay(
                                  //       hour: int.parse(timeParts[0]),
                                  //       minute: int.parse(
                                  //           timeParts[1]));
                                  //   apptTime =
                                  //   " (${at.format(inContext)})";
                                  // }

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
                                                // _editAppointment(
                                                //     inContext,
                                                //     appointment);
                                              })
                                      ),
                                      secondaryActions: [
                                        IconSlideAction(
                                            caption: "Delete",
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () => {}
                                          // _deleteAppointment(
                                          //     inBuildContext,
                                          //     inModel,
                                          //     appointment)
                                        )
                                      ]
                                  );
                                }
                            )
                        )
                      ,
                        if (showButton) Container(
                            height:40,
                            width: 200,
                            child: ElevatedButton(onPressed: (){
                              var cines = MoviesClient().getCinemas();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CinemasPage()));
                            }, child: Text('Let\'s plan!',style:
                            TextStyle(fontSize: 18),
                            ),
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[700])))
                        )]
                  )
              )
              )
              )
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

    setMarkedMap();
    markedDateMap.clear();

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
                              color: Colors.red[700],
                            border: Border.all(color: Colors.black)
                          ),
                          child: Center(child:Text('Select a Date!',
                            style:TextStyle(color: Colors.white, fontSize: 18),
                          )),
                      )
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