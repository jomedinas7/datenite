import 'package:datenite/Movies/moviesModel.dart';
import 'package:datenite/calendar.dart';
import 'package:datenite/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authentication_service.dart';
import 'package:provider/provider.dart';
import 'main.dart';


String currentAptId = '';
class DateCreation extends StatefulWidget {
  bool newDate = true;
  late final toMovie;
  Appointment currentAppointment =
  Appointment('title',DateTime.now(),'time','address','type');

  DateCreation(Appointment currentAppointment, toMovie, [newDate]) {
    this.currentAppointment = currentAppointment;
    if (newDate!= null) {
      this.newDate = newDate;
    }
    this.toMovie = toMovie;
  }

  @override
  _DateCreationState createState() =>  _DateCreationState(currentAppointment, newDate);
}
class _DateCreationState extends State<DateCreation> {
  bool newDate = true;
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final TextEditingController _addressEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();



  _DateCreationState(Appointment currentAppointment, [newDate]) {


    this.currentAppointment = currentAppointment;
    _addressEditingController.text = currentAppointment.address;
    _titleEditingController.text = currentAppointment.title;

    _titleEditingController.addListener(() {
      currentAppointment.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      currentAppointment.time  = _contentEditingController.text;
    });
    _addressEditingController.addListener(() {
      currentAppointment.address = _addressEditingController.text;
    });
    if (newDate!=null){
      this.newDate = newDate;
    }
  }

  Appointment currentAppointment =
  Appointment('title',DateTime.now(),'time','address','type');

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      setState(() {
        print(picked);
        int hour = picked.hour;
        String minute = picked.minute.toString();
        String amPm = 'AM';
        if(picked.hour>12){
          hour = picked.hour - 12;
          amPm = 'PM';
        }
        if(picked.minute<10){
          minute = '0${picked.minute}';
        }
        currentAppointment.time = "$hour:$minute $amPm";
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
          bool valid = true;
          if (currentAppointment.type == "Custom") {
            final form = formKey.currentState!;
            bool valid = form.validate();
            currentAppointment.title = _titleEditingController.text;
            currentAppointment.address = _addressEditingController.text;
            print("************************");
            print(currentAppointment.title);
          }

          if (valid) {
            if (newDate) {
              userCalendarEvents.add(currentAppointment);
              print("adding appointment");
              globalContext.read<AuthModel>().addAppointment(
                  currentAppointment);
            } else {
              print("updating appointment");
              if (currentAppointment.id == 'appointment#') {
                currentAppointment.id = currentAptId;
              }
              print(currentAptId);
              print(currentAppointment.id);
              globalContext.read<AuthModel>().updateAppointment(
                  currentAppointment);
            }
            if (!widget.toMovie) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Calendar("My Dates")));
            }
            if (widget.toMovie) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CinemasPage()));
            }
          }
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
                          SizedBox(height: 500, child:
                              ListView(children: [
                                if (currentAppointment.type == 'Custom')
                                  Form(
                                  key: formKey,
                                  child:
                                  Column(children: [
                                    Container(
                                      height:75,
                                  decoration: BoxDecoration(
                                      color: Colors.red[400],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.black)),
                                  margin:
                                  EdgeInsets.only(bottom: 6, left: 10, right:10),
                                  child: buildTextField("Activity",
                                      currentAppointment.title, false, _titleEditingController),
                                ),
                                    Container(
                                      height:75,
                                      decoration: BoxDecoration(
                                          color: Colors.red[400],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.black)),
                                      margin:
                                      EdgeInsets.only(bottom: 6, left: 10, right:10),
                                      child: buildTextField("Address",
                                          currentAppointment.address, false, _addressEditingController),
                                    ),
                                ]
                              )
                              ),
                                if (currentAppointment.type != 'Movie') Container(
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
                                if (currentAppointment.type == 'Movie')
                                  Text('TIME: ${currentAppointment.time}',style:TextStyle(fontWeight: FontWeight.bold)),
                                if (currentAppointment.type == 'Movie')
                                  Text('DATE:  ${currentAppointment.date.toString().substring(0,10)}', style:TextStyle(fontWeight: FontWeight.bold)),

                                if (currentAppointment.type == 'Movie')
                                  Image(height: 200,image: NetworkImage(currentAppointment.image)),

                                if (currentAppointment.type == 'Movie') Container(
                                    height:40,
                                    width: 200,
                                    child: Padding(
                                    padding: EdgeInsets.only(right: 40, left:40),

                                    child: ElevatedButton(onPressed: (){
                                      if (newDate == false){
                                        currentAptId = currentAppointment.id;
                                        print("SECOND CALL ______________________________");
                                        print(currentAppointment.id);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CinemasPage(false)));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CinemasPage()));
                                      }

                                    },child: Text('Choose a new showtime',style: TextStyle(fontSize: 18)),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[700])))
                                )
                                ),

                                if (currentAppointment.type != 'Custom') SizedBox(height: 20,),
                                if (currentAppointment.type != 'Movie') Container(
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

  Widget buildTextField(
      String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        validator: (value) {
          if (value != null && value.length<1) {
            return 'Enter Something';
          }
        },
        style: TextStyle(color: Colors.white),
        controller: controller,
        decoration: InputDecoration(
            errorStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,

            //hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              // fontWeight: FontWeight.bold,
              color: Color(Colors.red[100]!.value),
            )),
      ),
    );
  }
}