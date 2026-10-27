part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final FilmResponse filmResponse;
  MovieLoaded(this.filmResponse);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}