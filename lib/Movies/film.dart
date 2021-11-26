class Film{
  late var id;
  late var imbdID;
  late var titleID;
  late var name;
  late var versionRating;
  late var ageRating;
  late List<ShowTimes> showtimes;

  Film(this.id, this.imbdID, this.titleID, this.name,
      this.versionRating, this.ageRating,this.showtimes);
}

class ShowTimes{
  late var start;
  late var end;

  ShowTimes(this.start,this.end);
}