import 'package:flutter/foundation.dart';

class FilterProviders with ChangeNotifier {
  Map<String, bool> _filterList = {
    'isGlutenFree': false,
    'isVegan': false,
    'isVegetarian': false,
    'isLactoseFree': false,
  };

  Map<String, bool> get filterList {
    return {..._filterList};
  }

  updateFilterList(String key, bool value) {
    if (_filterList.containsKey(key)) {
      _filterList[key] = value;
      notifyListeners();
    }
  }
}
