import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../screens/feedback.dart';
import '../screens/filters.dart';
import '../screens/food_gallery.dart';

class MainDrawer extends StatelessWidget {
  Future<String?> getUserEmail() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey('userData')) {
      final data = pref.getString('userData');
      if (data != null) {
        final info = jsonDecode(data) as Map<String, dynamic>;
        return info['email'];
      }
    }
    return null;
  }

  Widget _showTiles({required String title, IconData? icon, Function? fun}) {
    return ListTile(
      onTap: fun as void Function()?,
      leading: Icon(
        icon,
        size: 25,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 150,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: FutureBuilder(
              future: getUserEmail(),
              builder: (BuildContext ctx, AsyncSnapshot<String?> snapshot) {
                return Text(
                  'Enjoy your Foods! \n${snapshot.data}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                );
              },
            ),
          ),
          _showTiles(
            title: 'Meals',
            icon: Icons.restaurant,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
          _showTiles(
            title: 'Filters',
            icon: Icons.settings,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                FiltersScreen.routeName,
              );
            },
          ),
          _showTiles(
            title: 'Food Gallery',
            icon: Icons.photo_album_sharp,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                FoodGallery.routeName,
              );
            },
          ),
          _showTiles(
            title: 'Feedback',
            icon: Icons.feedback_outlined,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                FeedbackScreen.routeName,
              );
            },
          ),
          _showTiles(
            title: 'Logout',
            icon: Icons.exit_to_app_sharp,
            fun: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
              Provider.of<AuthProvider>(context, listen: false).doLogout();
            },
          ),
        ],
      ),
    );
  }
}
