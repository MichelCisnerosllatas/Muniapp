import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../library/import.dart';

class Tubicacion extends GetxController {
  static const String tokenMapBox = "sk.eyJ1IjoibWljaGVsYW5nZWwiLCJhIjoiY201bG96cndmMDRsbjJqcHVteDV3MzhxcyJ9.3svEVmPnLFa7SDD0Fs7WAA";
  Rx<double> latidude = 0.0.obs;
  Rx<double> longitude = 0.0.obs;
  RxList<List<double>> coordenadasRuta = <List<double>>[].obs;

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMapp;
  Rx<int> accuracyColor = 0.obs;
  Rx<int> pulsingColor = 0.obs;
  Rx<int> accuracyBorderColor = 0.obs;
  Rx<double> puckScale = 10.0.obs;

  RxBool cargarLocalizar = false.obs;
  RxBool mapaCargada = false.obs;
  RxString mapaEstilo = MapboxStyles.MAPBOX_STREETS.obs;
  static const List<Map<String, String>> estilosMapa = [
    {"nombre": "Calles", "uri": MapboxStyles.MAPBOX_STREETS},
    {"nombre": "Exterior", "uri": MapboxStyles.OUTDOORS},
    {"nombre": "Satelital", "uri": MapboxStyles.SATELLITE},
    {"nombre": "Híbrido", "uri": MapboxStyles.SATELLITE_STREETS},
    {"nombre": "Oscuro", "uri": MapboxStyles.DARK},
    {"nombre": "Claro", "uri": MapboxStyles.LIGHT},
  ];
}