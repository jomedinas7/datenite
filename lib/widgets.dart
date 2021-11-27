import 'package:flutter/material.dart';
import "package:flutter_calendar_carousel/" "flutter_calendar_carousel.dart";
import "package:flutter_calendar_carousel/classes/event.dart";
import "package:flutter_calendar_carousel/classes/event_list.dart";
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'calendar.dart';


Widget calendarTopContainer(title,context){
  return Container(
      padding: EdgeInsets.fromLTRB(0,70,0,0),
      decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 225,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(child: Text(title,
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 32))),
                        SizedBox(height: 8),
                        Container(child: Text('When\'s the date?',
                            style: TextStyle(color: Colors.white, fontSize: 22))),
                      ]),
            )
          ]
      )
  );
}

Widget createProfileTopBar(){
  return Container(
      padding: EdgeInsets.fromLTRB(20,90,10,40),
      decoration: BoxDecoration(
          color: Colors.red[800],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 225,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 40, width: 250,child: Text('Create Profile',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 28))),
                        SizedBox(height: 5),
                      ]),
                ]
            ),
            )
          ]
      )
  );
}


Widget calendarWidget(){
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
  // markedDateMap.clear();
  // for (Appointment app in appointmentsModel.entityList) {
  //   DateTime date = toDate(app.date);
  //   markedDateMap.add(date, Event(date: date,
  //       icon: Container(decoration: BoxDecoration(color: Colors.black))));
  // }
  return Column(
      children: [
        Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: CalendarCarousel<Event>(
                  thisMonthDayBorderColor: Colors.grey,
                  daysHaveCircularBorder: false,
                  markedDatesMap: markedDateMap,
                  selectedDateTime: currentDate,
                  onDayPressed:
                      (DateTime inDate, List<
                      Event> inEvents) {
                    currentDate = inDate;
                  },
                  // onDayPressed: (DateTime date, List<Event> events) {
                  //   this.setState(() => _currentDate = date);
                  //   events.forEach((event) => print(event.title));
                  // },
                )
            ))
      ]);
}