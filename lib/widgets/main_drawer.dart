import 'package:flutter/material.dart';

import '../screens/feedback.dart';
import '../screens/filters.dart';
import '../screens/food_gallery.dart';

class MainDrawer extends StatelessWidget {
  Widget _showTiles({String title, IconData icon, Function fun}) {
    return ListTile(
      onTap: fun,
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
            child: Text(
              'Enjoy your Foods!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
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
                FiltersScreen.route,
              );
            },
          ),
          _showTiles(
            title: 'Food Gallery',
            icon: Icons.photo_album_sharp,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                FoodGallery.route,
              );
            },
          ),
          _showTiles(
            title: 'Feedback',
            icon: Icons.feedback_outlined,
            fun: () {
              Navigator.pushReplacementNamed(
                context,
                FeedbackScreen.route,
              );
            },
          ),
        ],
      ),
    );
  }
}
