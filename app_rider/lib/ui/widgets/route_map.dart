import 'package:app_rider/models/address.dart';
import 'package:flutter/material.dart';
import 'package:app_rider/services/location.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RouteMap extends StatefulWidget {
  static final GlobalKey<RouteMapState> routeMapKey =
      GlobalKey<RouteMapState>();

  final Address origin;
  final Address destination;

  const RouteMap({super.key, required this.origin, required this.destination});

  @override
  State createState() => RouteMapState();
}

class RouteMapState extends State<RouteMap> with WidgetsBindingObserver {
  MapboxMap? mapboxMap;
  PointAnnotationManager? annotationManager;
  late final Uint8List mapMarkerImageData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setRoute() {}

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    // remove scale bar, compass, and enable location puck
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true));
    mapboxMap.logo.updateSettings(LogoSettings(enabled: false));
    mapboxMap.attribution
        .updateSettings(AttributionSettings(enabled: true, marginLeft: 10));

    // set camera bound
    CameraOptions options = await mapboxMap.cameraForCoordinatesPadding([
      Point(coordinates: Position(widget.origin.long, widget.origin.lat)),
      Point(
          coordinates:
              Position(widget.destination.long, widget.destination.lat))
    ], CameraOptions(zoom: 13),
        MbxEdgeInsets(top: 10, left: 40, bottom: 10, right: 40), null, null);

    final ByteData bytes = await rootBundle.load('assets/map-marker-32.png');
    mapMarkerImageData = bytes.buffer.asUint8List();

    annotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    mapboxMap.setCamera(options);

    // destination marker
    addMarker(widget.destination.long, widget.destination.lat);
  }

  addMarker(double long, double lat) {
    PointAnnotationOptions point = PointAnnotationOptions(
        geometry: Point(coordinates: Position(long, lat)),
        image: mapMarkerImageData,
        iconSize: 3.0);

    annotationManager?.create(point);
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;

    mapboxMap?.style.setStyleURI(
        (isDarkMode) ? MapboxStyles.DARK : MapboxStyles.MAPBOX_STREETS);

    return Expanded(
        child: MapWidget(
            styleUri:
                (isDarkMode) ? MapboxStyles.DARK : MapboxStyles.MAPBOX_STREETS,
            key: const ValueKey('mapWidget'),
            onMapCreated: _onMapCreated,
            onTapListener: (context) {}));
  }
}
