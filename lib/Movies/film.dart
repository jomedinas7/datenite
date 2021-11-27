class Film{
  var id; //need film id to do more queries from API
  var name; // title of movie
  var version; // Standard, IMAX, 3D
  var ageRating; // PG, 15 (These are in EU standards for some reason)
  var posterUrl;
  List showtimes = [];
  var runtime;

  Film(this.id, this.name,
      this.version, this.ageRating,this.posterUrl,this.showtimes, this.runtime);

}

class FilmInfo{
  var imageUrl;
  var synopsis;
  var distributor;
  var trailerUrl;
  var genre;
  List cast = [];

  FilmInfo(this.imageUrl, this.synopsis, this.distributor, this.trailerUrl,
      this.genre, this.cast);
}