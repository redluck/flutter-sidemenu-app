import 'package:flutter/material.dart';
import 'page_3.dart';
import 'page_2.dart';
import 'page_1.dart';

void main() {
  runApp(const MyApp());
}

/*===========================================================================+
| Main Application Widget                                                    |
+===========================================================================*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidebar Menu Application',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

/*===========================================================================+
| HomePage                                                                   |
+===========================================================================*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index for the selected page
  int _selectedIndex = 0;

  // List of widgets (pages)
  final List<Widget> _pages = <Widget>[
    const Page1(),
    const Page2(),
    const Page3(),
  ];

  // List of titles for the AppBar
  final List<String> _appBarTitles = <String>[
    'Title One',
    'Title Two',
    'Title Three',
  ];

  // Handle navigation drawer item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Close the drawer
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*-------------------------+
      | appBar                   |
      +-------------------------*/
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex], style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1B5E20),
      ),
      /*-------------------------+
      | menu                     |
      +-------------------------*/
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2E7D32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Application Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Select the menu item to navigate',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Page 1'),
              selected: _selectedIndex == 0, // Highlight if selected
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Page 2'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Page 3'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      /*-------------------------+
      | body                     |
      +-------------------------*/
      // Display the selected page widget
      body: _pages[_selectedIndex],
    );
  }
}
