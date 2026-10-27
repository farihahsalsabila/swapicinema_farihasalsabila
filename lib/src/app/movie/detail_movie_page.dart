import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:swapi_cinema_app/src/app/app_event_bus.dart';
import 'package:swapi_cinema_app/src/domain/models/film_response.dart';
import 'package:http/http.dart' as http;

class DetailMoviePage extends StatefulWidget {
  final Result? movie;
  final bool? initialReminded;

  const DetailMoviePage({super.key, this.movie, this.initialReminded});

  @override
  State<DetailMoviePage> createState() => _DetailMoviePageState();
}

class _DetailMoviePageState extends State<DetailMoviePage> {
  bool isReminded = false;

  @override
  void initState() {
    super.initState();
    isReminded = widget.initialReminded ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F2937), Color(0xFF121212)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(Icons.movie_filter_rounded,
                    color: Color(0xFFFFE81F), size: 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie?.title ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        DateTime.parse(
                                widget.movie?.releaseDate.toString() ?? "-")
                            .year
                            .toString(),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.movie?.episodeId ?? '-'} Episodes',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Summary',
                    style: TextStyle(
                      color: Color(0xFFFFE81F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie?.openingCrawl ?? 'No summary available.',
                    style: const TextStyle(
                        color: Colors.white60, height: 1.5, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Producer',
                    style: TextStyle(
                      color: Color(0xFFFFE81F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie?.producer ?? '-',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Director',
                    style: TextStyle(
                      color: Color(0xFFFFE81F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie?.director ?? '-',
                    style: const TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      color: Color(0xFFFFE81F),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie?.characters?.length ?? 0,
                      itemBuilder: (context, index) {
                        final currentCharacterUrl =
                            widget.movie?.characters?[index];
                        return FutureBuilder<String>(
                            future:
                                fetchCharacterName(currentCharacterUrl ?? ""),
                            builder: (context, snapshot) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Center(
                                  child: Text(
                                    snapshot.data ?? '',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isReminded
                            ? Colors.grey[800]
                            : const Color(0xFFFFE81F),
                        foregroundColor:
                            isReminded ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isReminded = !isReminded;
                        });

                        eventBus.fire(
                            MovieReminderEvent(widget.movie?.title ?? 'Movie'));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isReminded
                                  ? 'Reminder set for ${widget.movie?.title}'
                                  : 'Reminder removed for ${widget.movie?.title}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: Icon(
                        isReminded
                            ? Icons.check_circle
                            : Icons.notifications_none,
                        color:
                            isReminded ? const Color(0xFFFFE81F) : Colors.black,
                      ),
                      label: Text(
                        isReminded ? 'Reminder Set' : 'Remind Me',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchCharacterName(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      return 'Error';
    }
  }
}
