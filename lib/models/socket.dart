import 'package:flutter/foundation.dart';
import '../services/socket.dart';

class SocketModel extends ChangeNotifier {
  SocketService? _socket;

  SocketService? get getSocketInstance => _socket;

  void setSocketInstance(SocketService skt) {
    _socket = skt;
  }
}
