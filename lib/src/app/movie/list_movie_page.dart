import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_cinema_app/src/app/app_event_bus.dart';
import 'package:swapi_cinema_app/src/app/movie/bloc/movie_bloc.dart';
import 'package:swapi_cinema_app/src/app/movie/detail_movie_page.dart';
import 'package:swapi_cinema_app/src/data/cinema_datasource.dart';
import 'package:swapi_cinema_app/src/data/cinema_repository.dart';
import 'package:swapi_cinema_app/src/domain/movies_usecase.dart';

class ListMoviePage extends StatefulWidget {
  const ListMoviePage({super.key});

  @override
  State<ListMoviePage> createState() => _ListMoviePageState();
}

class _ListMoviePageState extends State<ListMoviePage> {
  final Set<String> remindedMovies = {};

  StreamSubscription? _reminderSubscription;

  @override
  void initState() {
    super.initState();
    _reminderSubscription = eventBus.on<MovieReminderEvent>().listen((event) {
      setState(() {
        if (remindedMovies.contains(event.movieTitle)) {
          remindedMovies.remove(event.movieTitle);
        } else {
          remindedMovies.add(event.movieTitle);
        }
      });
    });
  }

  @override
  void dispose() {
    _reminderSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(
        MoviesUseCase(
          CinemaRepository(CinemaRemoteDataSource()),
        ),
      )..add(FetchMoviesEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                'SWAPI',
                style: TextStyle(
                  color: Color(0xFFE50914),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.5,
                  fontSize: 22,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'CINEMA',
                style: TextStyle(
                  color: Color(0xFFFFE81F),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Badge(
                  isLabelVisible: remindedMovies.isNotEmpty,
                  label: Text('${remindedMovies.length}'),
                  backgroundColor: const Color(0xFFFFE81F),
                  textColor: Colors.black,
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              );
            } else if (state is MovieLoaded) {
              final movies = state.filmResponse.results ?? [];
              if (movies.isEmpty) {
                return const Center(
                  child: Text("No movies available",
                      style: TextStyle(color: Colors.white70)),
                );
              }

              final firstMovie = movies.isNotEmpty ? movies.first : null;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (firstMovie != null)
                      GestureDetector(
                        onTap: () {
                          final isReminded =
                              remindedMovies.contains(firstMovie.title ?? '');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMoviePage(
                                movie: firstMovie,
                                initialReminded: isReminded,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 380,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xFFFFE81F), size: 60),
                                    const SizedBox(height: 8),
                                    Text(
                                      "EPISODE ${firstMovie.episodeId ?? ''}",
                                      style: const TextStyle(
                                        color: Color(0xFFFFE81F),
                                        letterSpacing: 4,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.95)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 16,
                                right: 16,
                                child: Column(
                                  children: [
                                    Text(
                                      firstMovie.title ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            final isReminded =
                                                remindedMovies.contains(
                                                    firstMovie.title ?? '');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailMoviePage(
                                                        movie: firstMovie,
                                                        initialReminded:
                                                            isReminded),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.play_arrow,
                                              color: Colors.black),
                                          label: const Text(
                                            'Play Movie',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white38),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            final isReminded =
                                                remindedMovies.contains(
                                                    firstMovie.title ?? '');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailMoviePage(
                                                        movie: firstMovie,
                                                        initialReminded:
                                                            isReminded),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.info_outline,
                                              size: 18),
                                          label: const Text('Details'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Star Wars Collection",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          final movieTitle = movie.title ?? '';
                          final isReminded =
                              remindedMovies.contains(movieTitle);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailMoviePage(
                                    movie: movie,
                                    initialReminded: isReminded,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 130,
                              margin: const EdgeInsets.symmetric(horizontal: 7),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 160,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.movie_creation_outlined,
                                        color: Colors.white.withOpacity(0.15),
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      movieTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else if (state is MovieError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.redAccent)),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
