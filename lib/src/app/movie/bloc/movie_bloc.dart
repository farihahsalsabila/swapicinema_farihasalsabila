import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:swapi_cinema_app/src/domain/models/film_response.dart';
import 'package:swapi_cinema_app/src/domain/movies_usecase.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MoviesUseCase cinemaUseCase;
  MovieBloc(this.cinemaUseCase) : super(MovieInitial()) {

    on<FetchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      try {
        final filmResponse = await cinemaUseCase.execute(0);
        emit(MovieLoaded(filmResponse));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
