import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_example/add_grave_screen.dart';
import 'package:yandex_mapkit_example/grave_details_screen.dart';
import 'package:yandex_mapkit_example/store.dart';

import 'examples/widgets/marble_fab.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
      ),
      home: MainPage()));
}

final String style = '''
    [
      {
        "tags": {
          "none": ["poi"]
        },
        "stylers": {
          "saturation": -1
        }
      }
    ]
  ''';

class MainPage extends StatefulWidget {
  static final Point _point = Point(latitude: 55.725219, longitude: 37.554324);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late YandexMapController controller;

  bool tiltGesturesEnabled = true;

  bool zoomGesturesEnabled = true;

  bool rotateGesturesEnabled = true;

  bool scrollGesturesEnabled = true;

  bool modelsEnabled = true;

  bool nightModeEnabled = false;

  bool fastTapEnabled = false;

  bool mode2DEnabled = false;

  ScreenRect? focusRect;

  MapType mapType = MapType.vector;

  int? poiLimit;

  final animation = MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  final List<MapObject> mapObjects = [];

  final MapObjectId mapObjectId =
      MapObjectId('clusterized_placemark_collection');
  final MapObjectId largeMapObjectId =
      MapObjectId('large_clusterized_placemark_collection');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                Container(
                  child: YandexMap(
                    mapObjects: mapObjects,
                    mapType: mapType,
                    poiLimit: poiLimit,
                    tiltGesturesEnabled: tiltGesturesEnabled,
                    zoomGesturesEnabled: zoomGesturesEnabled,
                    rotateGesturesEnabled: rotateGesturesEnabled,
                    scrollGesturesEnabled: scrollGesturesEnabled,
                    modelsEnabled: modelsEnabled,
                    nightModeEnabled: nightModeEnabled,
                    fastTapEnabled: fastTapEnabled,
                    mode2DEnabled: mode2DEnabled,
                    logoAlignment: MapAlignment(
                        horizontal: HorizontalAlignment.left,
                        vertical: VerticalAlignment.bottom),
                    focusRect: focusRect,
                    onMapCreated:
                        (YandexMapController yandexMapController) async {
                      await yandexMapController.setMapStyle(style);
                      controller = yandexMapController;
                      await controller.moveCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: MainPage._point)),
                          animation: animation);
                      final cameraPosition =
                          await controller.getCameraPosition();
                      final minZoom = await controller.getMinZoom();
                      final maxZoom = await controller.getMaxZoom();

                      print('Camera position: $cameraPosition');
                      print('Min zoom: $minZoom, Max zoom: $maxZoom');
                    },
                    onMapTap: (Point point) async {
                      print('Tapped map at $point');

                      await controller.deselectGeoObject();
                    },
                    onMapLongTap: (Point point) =>
                        print('Long tapped map at $point'),
                    onCameraPositionChanged: (CameraPosition cameraPosition,
                        CameraUpdateReason reason, bool finished) {
                      print(
                          'Camera position: $cameraPosition, Reason: $reason');

                      if (finished) {
                        print('Camera position movement has been finished');
                      }
                    },
                    onObjectTap: (GeoObject geoObject) async {
                      print('Tapped object: ${geoObject.name}');

                      if (geoObject.selectionMetadata != null) {
                        await controller.selectGeoObject(
                            geoObject.selectionMetadata!.id,
                            geoObject.selectionMetadata!.layerId);
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // ControlFab(
                            //   onPressed: () {
                            //     controller.moveCamera(CameraUpdate.zoomIn());
                            //   },
                            //   icon: Icons.zoom_in,
                            // ),
                            // const SizedBox(
                            //   height: 8.0,
                            // ),
                            // ControlFab(
                            //   onPressed: () {
                            //     controller.moveCamera(CameraUpdate.zoomOut());
                            //   },
                            //   icon: Icons.zoom_out,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MarbleFab(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => AddGraveScreen(),
                                  ),
                                );
                                setState(() {
                                  mapObjects.add(
                                    ClusterizedPlacemarkCollection(
                                      mapId: largeMapObjectId,
                                      radius: 30,
                                      minZoom: 15,
                                      onClusterAdded:
                                          (ClusterizedPlacemarkCollection self,
                                              Cluster cluster) async {
                                        return cluster.copyWith(
                                            appearance: cluster.appearance.copyWith(
                                                opacity: 0.75,
                                                icon: PlacemarkIcon.single(
                                                    PlacemarkIconStyle(
                                                        image: BitmapDescriptor
                                                            .fromBytes(
                                                                await _buildClusterAppearance(
                                                                    cluster)),
                                                        scale: 1))));
                                      },
                                      onClusterTap:
                                          (ClusterizedPlacemarkCollection self,
                                              Cluster cluster) {
                                        print('Tapped cluster');
                                      },
                                      placemarks: [
                                        PlacemarkMapObject(
                                            mapId: MapObjectId('placemark_1'),
                                            point: MainPage._point,
                                            icon: PlacemarkIcon.single(
                                                PlacemarkIconStyle(
                                                    image: BitmapDescriptor
                                                        .fromAssetImage(
                                                            'lib/assets/place.png'),
                                                    scale: 2))),
                                        PlacemarkMapObject(
                                            mapId: MapObjectId('placemark_2'),
                                            point: Point(
                                                latitude: 55.714531,
                                                longitude: 37.602103),
                                            icon: PlacemarkIcon.single(
                                                PlacemarkIconStyle(
                                                    image: BitmapDescriptor
                                                        .fromAssetImage(
                                                            'lib/assets/place.png'),
                                                    scale: 2)))
                                      ],
                                      onTap:
                                          (ClusterizedPlacemarkCollection self,
                                                  Point point) =>
                                              Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (context) =>
                                              GraveDetailsScreen(
                                            name: Store.grave?.name ?? '',
                                            dob: Store.grave?.dob ?? '',
                                            dod: Store.grave?.dod ?? '',
                                            bio: Store.grave?.bio ?? '',
                                            imageUrl: Store.grave?.file,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                                // mapObjects.add(ClusterizedPlacemarkCollection(
                                //   mapId: mapObjectId,
                                //   radius: 30,
                                //   minZoom: 15,
                                //   onClusterAdded:
                                //       (ClusterizedPlacemarkCollection self,
                                //           Cluster cluster) async {
                                //     return cluster.copyWith(
                                //         appearance: cluster.appearance.copyWith(
                                //             icon: PlacemarkIcon.single(
                                //                 PlacemarkIconStyle(
                                //                     image: BitmapDescriptor
                                //                         .fromAssetImage(
                                //                             'lib/assets/cluster.png'),
                                //                     scale: 1))));
                                //   },
                                //   onClusterTap:
                                //       (ClusterizedPlacemarkCollection self,
                                //           Cluster cluster) {
                                //     print('Tapped cluster');
                                //   },
                                //   placemarks: [
                                //     PlacemarkMapObject(
                                //         mapId: MapObjectId('placemark_1'),
                                //         point: Point(
                                //             latitude: 55.756,
                                //             longitude: 37.618),
                                //         consumeTapEvents: true,
                                //         onTap: (PlacemarkMapObject self,
                                //                 Point point) =>
                                //             print(
                                //                 'Tapped placemark at $point'),
                                //         icon: PlacemarkIcon.single(
                                //             PlacemarkIconStyle(
                                //                 image: BitmapDescriptor
                                //                     .fromAssetImage(
                                //                         'lib/assets/place.png'),
                                //                 scale: 1))),
                                //     PlacemarkMapObject(
                                //         mapId: MapObjectId('placemark_2'),
                                //         point: Point(
                                //             latitude: 59.956,
                                //             longitude: 30.313),
                                //         icon: PlacemarkIcon.single(
                                //             PlacemarkIconStyle(
                                //                 image: BitmapDescriptor
                                //                     .fromAssetImage(
                                //                         'lib/assets/place.png'),
                                //                 scale: 1))),
                                //     PlacemarkMapObject(
                                //         mapId: MapObjectId('placemark_3'),
                                //         point: Point(
                                //             latitude: 39.956,
                                //             longitude: 30.313),
                                //         icon: PlacemarkIcon.single(
                                //             PlacemarkIconStyle(
                                //                 image: BitmapDescriptor
                                //                     .fromAssetImage(
                                //                         'lib/assets/place.png'),
                                //                 scale: 1))),
                                //   ],
                                //   onTap: (ClusterizedPlacemarkCollection self,
                                //           Point point) =>
                                //       print('Tapped me at $point'),
                                // ));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: _allPages.length,
          //     itemBuilder: (_, int index) => ListTile(
          //       title: Text(_allPages[index].title),
          //       onTap: () => _pushPage(context, _allPages[index]),
          //     ),
          //   )
          // )
        ],
      ),
    );
  }

  Future<Uint8List> _buildClusterAppearance(Cluster cluster) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(200, 200);
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final radius = 60.0;

    final textPainter = TextPainter(
        text: TextSpan(
            text: cluster.size.toString(),
            style: TextStyle(color: Colors.black, fontSize: 50)),
        textDirection: TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
