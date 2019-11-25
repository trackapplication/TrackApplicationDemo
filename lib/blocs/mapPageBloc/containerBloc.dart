import 'dart:async';

class ContainerBloc {
  StreamController<double> size = StreamController<double>.broadcast();

  Stream<double> get op => size.stream;

  Sink<double> get ip => size.sink;

  StreamController<bool> bottomSheet = StreamController<bool>.broadcast();

  Stream<bool> get b_op => bottomSheet.stream;

  Sink<bool> get b_ip => bottomSheet.sink;

  void dispose() {
    // TODO: Call dispose where necessary
    size.close();
    bottomSheet.close();
  }
}
