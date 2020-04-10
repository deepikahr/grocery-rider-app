import 'package:flutter/foundation.dart';

class AdminModel extends ChangeNotifier {
  Map<String, dynamic> _info;

  Map<String, dynamic> get storeLocation {
    if (_info != null && _info['response_code'] == 200) {
      if (_info['response_data']['location'] != null) {
        print('adm loc ${_info['response_data']['location']}');
        return {
          'lat': _info['response_data']['location']['lat'],
          'long': _info['response_data']['location']['lng']
        };
      }
    }
    return {'lat': 12.8718, 'long': 77.6022};
  }

  void updateInfo(Map locationInfo) {
    print(_info);
    _info = locationInfo;
    notifyListeners();
  }
}
