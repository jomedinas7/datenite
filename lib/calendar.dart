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
import 'package:scoped_model/scoped_model.dart';

DateTime currentDate = DateTime.now();

class Appointment {
  Appointment(String title, String date, String time){
    this.title = title;
    this.date = date;
    this.time = time;
  }
  int id = -1;
  String title = '';
  String description = '';
  String date = '';
  String time = '';

  bool hasTime() => time != '';

  @override
  String toString()  =>
      "{ id=$id, title=$title, description=$description, date=$date, time=$time }";
}

List<Appointment> aptList = [Appointment("First","11/12/21", "2:30 PM"),Appointment("Second", "11/12/21", "4:30 PM"),];

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


  void _showAppointments(DateTime inDate, BuildContext inContext) async {
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
                                itemCount: aptList.length,
                                itemBuilder: (BuildContext inBuildContext,
                                    int inIndex) {
                                  Appointment appointment =
                                  aptList[inIndex];
                                  if (appointment.date !=
                                      "${inDate.year},${inDate
                                          .month},${inDate
                                          .day}") {
                                    return Container(height: 0);
                                  }
                                  String apptTime = appointment.time;
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
                                          color: Colors.grey.shade300,
                                          child: ListTile(
                                              title: Text(
                                                  "${appointment
                                                      .title}$apptTime"),
                                              subtitle: appointment.date == ''
                                                  ? null
                                                  : Text(appointment.date),
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
                        Container(
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
                                        _showAppointments(date, context);
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