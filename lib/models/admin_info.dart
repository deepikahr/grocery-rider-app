import 'package:flutter/foundation.dart';

class AdminModel extends ChangeNotifier {
  Map<String, dynamic> _info;

  Map<String, dynamic> get adminLocation {
    if (_info != null && _info['response_code'] == 200) {
      if (_info['response_data']['location'] != null) {
        return {
          'lat': _info['response_data']['location']['coordinates'][0],
          'long': _info['response_data']['location']['coordinates'][1]
        };
      }
    }
    return {'lat': 12.8718, 'long': 77.6022};
  }

  void update(Map adminInfo) {
    _info = adminInfo;
    notifyListeners();
  }
}
