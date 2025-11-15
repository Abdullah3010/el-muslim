import 'dart:async';

import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/loading_indicator.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/location_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QiblahMaps extends StatefulWidget {
  const QiblahMaps({super.key, required this.resolvePosition});

  final Future<Position?> Function() resolvePosition;

  static const meccaLatLong = LatLng(21.422487, 39.826206);
  static final meccaMarker = Marker(
    markerId: const MarkerId('mecca'),
    position: meccaLatLong,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    draggable: false,
  );

  @override
  State<QiblahMaps> createState() => _QiblahMapsState();
}

class _QiblahMapsState extends State<QiblahMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  final StreamController<LatLng> _positionStream = StreamController<LatLng>.broadcast();
  LatLng position = const LatLng(36.800636, 10.180358);
  late Future<Position?> _positionFuture;

  @override
  void initState() {
    super.initState();
    _positionStream.sink.add(position);
    _initializePosition();
  }

  @override
  void dispose() {
    _positionStream.close();
    super.dispose();
  }

  void _initializePosition() {
    _positionFuture = widget.resolvePosition();
    _positionFuture.then((result) {
      if (result != null) {
        position = LatLng(result.latitude, result.longitude);
        _positionStream.sink.add(position);
      }
    });
  }

  void _retry() {
    setState(() {
      _initializePosition();
    });
  }

  void _updateCamera() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 20));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position?>(
      future: _positionFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (snapshot.hasError) {
          return LocationErrorWidget(message: snapshot.error.toString(), onRetry: _retry);
        }

        if (snapshot.data == null) {
          return LocationErrorWidget(message: 'Please enable location services'.translated, onRetry: _retry);
        }

        return StreamBuilder<LatLng>(
          stream: _positionStream.stream,
          builder:
              (_, snapshot) => GoogleMap(
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(target: position, zoom: 11),
                markers: {
                  QiblahMaps.meccaMarker,
                  Marker(
                    draggable: true,
                    markerId: const MarkerId('Marker'),
                    position: position,
                    icon: BitmapDescriptor.defaultMarker,
                    onTap: _updateCamera,
                    onDragEnd: (LatLng value) {
                      position = value;
                      _positionStream.sink.add(value);
                    },
                    zIndex: 5,
                  ),
                },
                circles: {
                  Circle(
                    circleId: const CircleId('Circle'),
                    radius: 10,
                    center: position,
                    fillColor: Theme.of(context).primaryColorLight.withAlpha(100),
                    strokeWidth: 1,
                    strokeColor: Theme.of(context).primaryColorDark.withAlpha(100),
                    zIndex: 3,
                  ),
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('Line'),
                    points: [position, QiblahMaps.meccaLatLong],
                    color: Theme.of(context).primaryColor,
                    width: 5,
                    zIndex: 4,
                    geodesic: true,
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
        );
      },
    );
  }
}
