import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Directions {
  final LatLngBounds bounds;
  final String? totalDistance;
  final String? totalDuration;

  const Directions({
    required this.bounds,
    @required this.totalDistance,
    @required this.totalDuration,
  });
}