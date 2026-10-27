// To parse this JSON data, do
//
//     final filmResponse = filmResponseFromJson(jsonString);

import 'dart:convert';

FilmResponse filmResponseFromJson(String str) => FilmResponse.fromJson(json.decode(str));

String filmResponseToJson(FilmResponse data) => json.encode(data.toJson());

class FilmResponse {
  int? count;
  String? next;
  String? previous;
  List<Result>? results;

  FilmResponse({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory FilmResponse.fromJson(Map<String, dynamic> json) => FilmResponse(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  String? title;
  int? episodeId;
  String? openingCrawl;
  String? director;
  String? producer;
  DateTime? releaseDate;
  List<String>? characters;
  List<String>? planets;
  List<String>? starships;
  List<String>? vehicles;
  List<String>? species;
  String? created;
  String? edited;
  String? url;

  Result({
    this.title,
    this.episodeId,
    this.openingCrawl,
    this.director,
    this.producer,
    this.releaseDate,
    this.characters,
    this.planets,
    this.starships,
    this.vehicles,
    this.species,
    this.created,
    this.edited,
    this.url,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    title: json["title"],
    episodeId: json["episode_id"],
    openingCrawl: json["opening_crawl"],
    director: json["director"],
    producer: json["producer"],
    releaseDate: json["release_date"] == null ? null : DateTime.parse(json["release_date"]),
    characters: json["characters"] == null ? [] : List<String>.from(json["characters"]!.map((x) => x)),
    planets: json["planets"] == null ? [] : List<String>.from(json["planets"]!.map((x) => x)),
    starships: json["starships"] == null ? [] : List<String>.from(json["starships"]!.map((x) => x)),
    vehicles: json["vehicles"] == null ? [] : List<String>.from(json["vehicles"]!.map((x) => x)),
    species: json["species"] == null ? [] : List<String>.from(json["species"]!.map((x) => x)),
    created: json["created"],
    edited: json["edited"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "episode_id": episodeId,
    "opening_crawl": openingCrawl,
    "director": director,
    "producer": producer,
    "release_date": releaseDate == null ? null : "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    "characters": characters == null ? [] : List<dynamic>.from(characters!.map((x) => x)),
    "planets": planets == null ? [] : List<dynamic>.from(planets!.map((x) => x)),
    "starships": starships == null ? [] : List<dynamic>.from(starships!.map((x) => x)),
    "vehicles": vehicles == null ? [] : List<dynamic>.from(vehicles!.map((x) => x)),
    "species": species == null ? [] : List<dynamic>.from(species!.map((x) => x)),
    "created": created,
    "edited": edited,
    "url": url,
  };
}
