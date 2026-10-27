import 'package:swapi_cinema_app/src/domain/models/film_response.dart';

abstract class ICinemaRepository {
  Future<FilmResponse> getMovies();
}