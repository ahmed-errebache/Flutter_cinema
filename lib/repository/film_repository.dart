import 'package:acteurs/model/film.dart';
import 'package:acteurs/service/film_service.dart';

class FilmRepository {

   Future<List<Film>> getActeurs() async {
    final films = await fetchFilms();

    return films;
  }

  Future<Film> getFilm(int filmId) async {
    return await fetchFilm(filmId);
  }
}
