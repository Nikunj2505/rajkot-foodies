import 'package:flutter/foundation.dart';

import '../dummy_data.dart';
import '../models/meal.dart';

class FavoriteProviders with ChangeNotifier {
  List<Meal> _favoriteMeals = [];

  List<Meal> get favoriteMeals {
    return [..._favoriteMeals];
  }

  void toggleFavorite(String? mealId) {
    var favoriteIndex = _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (favoriteIndex >= 0) {
      _favoriteMeals.removeAt(favoriteIndex);
    } else {
      _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
    }
    notifyListeners();
  }
}
