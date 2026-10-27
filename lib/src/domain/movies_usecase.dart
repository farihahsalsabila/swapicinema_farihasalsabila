import 'package:swapi_cinema_app/src/domain/cinema_irepository.dart';
import 'package:swapi_cinema_app/src/domain/general_usecase.dart';
import 'package:swapi_cinema_app/src/domain/models/film_response.dart';

class MoviesUseCase extends IUseCase<void, Future<FilmResponse>> {
  final ICinemaRepository cinemaRepository;
  MoviesUseCase(this.cinemaRepository);

  @override
  Future<FilmResponse> execute(void request) async {
    return cinemaRepository.getMovies();
  }
}
