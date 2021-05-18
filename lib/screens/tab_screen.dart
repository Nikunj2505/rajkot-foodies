import 'package:flutter/material.dart';

import './categories_screen.dart';
import './favorites_screen.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'title': 'Categories',
        'route': CategoriesScreen(),
      },
      {
        'title': 'Favorites',
        'route': FavoritesScreen(),
      },
    ];
  }

  void _changeCurrentPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_pages[_selectedPageIndex]['title']}'),
      ),
      body: _pages[_selectedPageIndex]['route'],
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changeCurrentPage,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black38,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
    /*return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hi'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Categories',
              ),
              Tab(
                text: 'Favorites',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesScreen(),
            FavoritesScreen(),
          ],
        ),
      ),
    );*/
  }
}
