import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/favorite_providers.dart';
import './providers/filter_meals_providers.dart';
import './providers/filter_providers.dart';
import './providers/food_gallery_providers.dart';
import './screens/categories_meals_screen.dart';
import './screens/feedback.dart';
import './screens/filters.dart';
import './screens/food_gallery.dart';
import './screens/login_screen.dart';
import './screens/meals_details_screen.dart';
import './screens/tab_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => FilterProviders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<FilterProviders, FilterMealsProviders>(
          create: (ctx) => FilterMealsProviders(null),
          update: (ctx, filter, previous) => FilterMealsProviders(filter),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FavoriteProviders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FoodGalleryProvider(),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Foodies',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700),
                  bodyText2: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          home: auth.isAuthenticated()
              ? TabsScreen()
              : FutureBuilder(
                  future: auth.checkForAutoLogin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                          (snapshot.connectionState == ConnectionState.waiting)
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.white,
                                )
                              : LoginScreen(),
                ),
          routes: {
            TabsScreen.routeName: (_) => TabsScreen(),
            CategoriesMealsScreen.routeName: (ctx) => CategoriesMealsScreen(),
            MealsDetailsScreen.routeName: (ctx) => MealsDetailsScreen(),
            FiltersScreen.routeName: (ctx) => FiltersScreen(),
            FeedbackScreen.routeName: (ctx) => FeedbackScreen(),
            FoodGallery.routeName: (ctx) => FoodGallery(),
          },
        ),
      ),
    );
  }
}
