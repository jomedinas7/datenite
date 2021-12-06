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