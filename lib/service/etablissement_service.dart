import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import '../model/etablissement.dart';

final _dio = Dio();

Future<List<Etablissement>> fetchEtablissements(
  LatLngBounds bounds, {
  CancelToken? cancelToken,
}) async {
  try {
    final response = await _dio.post(
      'https://api.neotech.fr/rpc/etablissements_in_view',
      data: {
        "min_lat": bounds.southWest.latitude,
        "min_lng": bounds.southWest.longitude,
        "max_lat": bounds.northEast.latitude,
        "max_lng": bounds.northEast.longitude,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
      cancelToken: cancelToken,
    );
    final List tableau = response.data;
    return tableau.map((json) => Etablissement.fromJson(json)).toList();
  } on DioException catch (e) {
    if (e.type == DioExceptionType.cancel) return [];
    return [];
  }
}

Future<Etablissement> fetchEtablissement(int etablissementId) async {
  final response = await _dio.get(
    'https://api.neotech.fr/etablissements?etablissement_id=eq.$etablissementId',
  );
  final List tableau = response.data;
  return Etablissement.fromJson(tableau[0]);
}
