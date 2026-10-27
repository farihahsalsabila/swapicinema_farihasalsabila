import 'package:swapi_cinema_app/src/data/cinema_datasource.dart';
import 'package:swapi_cinema_app/src/domain/cinema_irepository.dart';
import 'package:swapi_cinema_app/src/domain/models/film_response.dart';

class CinemaRepository extends ICinemaRepository {
  final CinemaRemoteDataSource remoteDatasource;

  CinemaRepository(this.remoteDatasource);

  @override
  Future<FilmResponse> getMovies() {
    return remoteDatasource.getMovies();
  }
}