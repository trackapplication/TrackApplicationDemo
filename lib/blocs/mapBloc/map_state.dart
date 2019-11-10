import 'package:meta/meta.dart';

@immutable
abstract class MapState {}

class InitialMapState extends MapState {}

class PanelIsUp extends MapState {}

class PanelIsDown extends MapState {}
