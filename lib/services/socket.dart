import 'package:grocerydelivery/screens/home/tabs.dart';

import '../services/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  SocketService() {
    socket = IO.io(Constants.apiURL, <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('connect', (_) {
      print('Grocery Socket Connected to ${Constants.apiURL}');
    });

    socket.on('disconnect', (_) => print('Grocery Socket Disconnected'));
  }

  IO.Socket getSocket() {
    return socket;
  }
}
