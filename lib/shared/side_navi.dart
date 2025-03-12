import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget child; // The main content of the page

  const MainLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: AppDrawer(), // Shared Drawer
      body: child, // Page content
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 70,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Settings List',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Generator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Main Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.radar),
            title: Text('Item Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/item_settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('World Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/world_settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Misc. Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/misc_settings');
            },
          ),
        ],
      ),
    );
  }
}


