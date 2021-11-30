import 'package:datenite/Movies/moviesModel.dart';
import 'package:datenite/calendar.dart';
import 'package:datenite/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class DateCreation extends StatefulWidget {

  late final toMovie;

  Appointment currentAppointment =
  Appointment('title',DateTime.now(),'time','address','type');


  DateCreation(Appointment currentAppointment, toMovie) {
    this.currentAppointment = currentAppointment;
    this.toMovie = toMovie;
  }

  @override
  _DateCreationState createState() =>  _DateCreationState(currentAppointment);
}
class _DateCreationState extends State<DateCreation> {


  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  _DateCreationState(Appointment currentAppointment) {
    this.currentAppointment = currentAppointment;
    _titleEditingController.addListener(() {
      currentAppointment.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      currentAppointment.time  = _contentEditingController.text;
    });
  }

  Appointment currentAppointment =
  Appointment('title',DateTime.now(),'time','address','type');

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      setState(() {
        print(picked);
        int hour = 0;
        String amPm = 'AM';
        if(picked.hour>12){
          hour = picked.hour - 12;
          amPm = 'PM';
        }
        currentAppointment.time = "$hour:${picked.minute} $amPm";
      });
      // setTime(picked.format(context));
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime? picked = await
    showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days:30)),
        initialDate: initialDate
        builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.red[700],
          colorScheme: ColorScheme.light(primary: Color(Colors.red[700]!.value)),
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary
          ),
        ),
        child: child!,
      );
    },
    );

    if (picked != null) {
      print(picked);
      setState(() {
        currentAppointment.date = picked;
      });
    }
  }

  Row _buildControlButtons(BuildContext context) {
    return Row(children: [
      TextButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      Spacer(),
      TextButton(
        child: Text('Save'),
        onPressed: () {
          if(!widget.toMovie){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar("My Dates")));
          }
          if(widget.toMovie){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CinemasPage()));
          }
          // _save(context, appointmentsModel);
        },
      )
    ]
    );
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: _buildControlButtons(context)
              ),
              body:Stack(children: [
                SingleChildScrollView(
                    child: Column(
                        children: [
                          dateCreationTop(currentAppointment.title,currentAppointment.address,context),
                          SizedBox(height: 400, child:
                              ListView(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red[400],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.black)),
                                  margin:
                                  EdgeInsets.only(bottom: 6, left: 10, right:10),
                                        child:
                                        ListTile(
                                            leading: Icon(Icons.calendar_today,color: Colors.black),
                                            title: Text("Date",
                                              style:TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.bold),),
                                            subtitle: Text(currentAppointment.date.toString().substring(0,10),
                                                style:TextStyle(color: Colors.black,
                                                fontStyle: FontStyle.italic)),
                                            trailing: IconButton(
                                                icon: Icon(Icons.edit),
                                                color: Colors.white,
                                                onPressed: () {
                                                  print(currentAppointment.date);
                                                  _selectDate(context);
                                                }
                                            )
                                        ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black)),
                                margin:
                                  EdgeInsets.only(bottom: 6, left: 10, right:10),
                                  child:
                                    ListTile(
                                      leading: Icon(Icons.alarm,color: Colors.black),
                                      title: Text("Time",
                                      style: TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold),),
                                      subtitle: Text(currentAppointment.time,
                                          style:TextStyle(color: Colors.black,
                                              fontStyle: FontStyle.italic)),
                                      trailing: IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () => _selectTime(context)
                                      )
                                    ),
                              )
                              ]
                              )
                          ),
                        ]
                    )
                ),
                Positioned(left: -8, top: 55, child: IconButton(icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 55),
                onPressed: ()=> Navigator.pop(context))),
                ]
              )
          );
  }
}