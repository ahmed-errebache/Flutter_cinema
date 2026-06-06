import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import '../model/etablissement.dart';
import '../service/etablissement_service.dart';

class EtablissementRepository {
  Future<List<Etablissement>> getEtablissements(LatLngBounds bounds, {CancelToken? cancelToken}) async {
    final etablissements = await fetchEtablissements(bounds, cancelToken: cancelToken);
    etablissements.sort((a, b) => a.nom.compareTo(b.nom));
    return etablissements;
  }
}
