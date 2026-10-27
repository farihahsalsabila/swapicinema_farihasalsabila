import 'package:dio/dio.dart';
import 'package:swapi_cinema_app/src/data/api_endpoint.dart';
import 'package:swapi_cinema_app/src/domain/models/film_response.dart';

class CinemaRemoteDataSource {
  final Dio _dio = Dio();

  Future<FilmResponse> getMovies() async {
    final response = await _dio.get(ApiEndpoints.films);
    return FilmResponse.fromJson(response.data);
  }
}