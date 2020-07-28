import 'package:flutter/foundation.dart';

class AdminModel extends ChangeNotifier {
  Map<String, dynamic> _info;

  Map<String, dynamic> get storeLocation {
    if (_info != null && _info['response_data'] != null) {
      if (_info['response_data']['location'] != null) {
        return {
          'latitude': _info['response_data']['location']['latitude'],
          'longitude': _info['response_data']['location']['longitude']
        };
      }
    }
    return {'latitude': 12.8718, 'longitude': 77.6022};
  }

  void updateInfo(Map locationInfo) {
    _info = locationInfo;
    notifyListeners();
  }
}
