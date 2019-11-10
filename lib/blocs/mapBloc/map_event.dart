import 'package:meta/meta.dart';

@immutable
abstract class MapEvent {}

class PanelUp extends MapEvent {}

class PanelDown extends MapEvent {}
