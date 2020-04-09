import '../services/common.dart';
import '../services/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  SocketService() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('connect', (_) {
      print('Grocery Socket Connected to ${Constants.socketUrl}');
    });
    Common.getAccountID().then((id) {
      Map<String, String> body = {'id': id};
      socket.emit('get-assigned-orders', body);
      socket.emit('get-delivered-orders', body);
    });
    socket.on('disconnect', (_) => print('Grocery Socket Disconnected'));
  }

  IO.Socket getSocket() {
    return socket;
  }

  void orderEmitForAcceptReject(skt, order) {
    Common.getAccountID().then((id) {
      Map<String, dynamic> body = {'id': id, 'orderInfo': order};
      skt.emit('update-order-status', body);
    });
  }

  void updateOrderStatus(skt, status, orderID) {
    Common.getAccountID().then((id) {
      Map<String, dynamic> body = {
        'id': id,
        'orderId': orderID,
        'status': status
      };
      print(body);
      skt.emit('order-update-status', body);
    });
  }
}



