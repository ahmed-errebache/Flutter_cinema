import 'dart:async';

import 'package:acteurs/model/etablissement.dart';
import 'package:acteurs/repository/etablissement_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CarteView extends StatefulWidget {
  const CarteView({super.key});

  @override
  State<CarteView> createState() => _CarteViewState();
}

class _CarteViewState extends State<CarteView> {
  final MapController _mapController = MapController();
  final EtablissementRepository _repository = EtablissementRepository();
  StreamSubscription? _mapEventSubscription;
  CancelToken? _cancelToken;
  LatLng? _userLocation;
  List<Etablissement> _etablissements = [];

  @override
  void initState() {
    super.initState();
    _determinePosition().then((Position? position) {
      if (position == null || !mounted) return;
      setState(() => _userLocation = LatLng(position.latitude, position.longitude));
      _mapController.move(LatLng(position.latitude, position.longitude), 13.0);
    });
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _cancelToken?.cancel();
    super.dispose();
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;
    return await Geolocator.getCurrentPosition();
  }

  void _appelService() {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
    _repository
        .getEtablissements(_mapController.camera.visibleBounds, cancelToken: _cancelToken)
        .then((result) {
      if (mounted) setState(() => _etablissements = result);
    });
  }

  void _showInfo(Etablissement e) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (e.voie != null) ...[const SizedBox(height: 4), Text(e.voie!)],
            if (e.ville != null) ...[const SizedBox(height: 4), Text(e.ville!)],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = _etablissements
        .where((e) => e.point != null)
        .map((e) => Marker(
              point: e.point!,
              child: GestureDetector(
                onTap: () => _showInfo(e),
                child: const Icon(Icons.location_pin, color: Colors.blue, size: 36),
              ),
            ))
        .toList();

    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(48.5, 7.5),
          initialZoom: 10.0,
          onMapReady: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _appelService();
              _mapEventSubscription = _mapController.mapEventStream.listen((event) {
                if (event is MapEventMoveEnd) _appelService();
              });
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'univ-lorraine.iutsd.cinema',
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 60,
              size: const Size(44, 44),
              markers: markers,
              builder: (context, clusterMarkers) => Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${clusterMarkers.length}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
          if (_userLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _userLocation!,
                  child: const Icon(Icons.my_location, color: Colors.blue, size: 32),
                ),
              ],
            ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
    );
  }
}
