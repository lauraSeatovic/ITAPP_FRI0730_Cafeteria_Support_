import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/show_items/show_items_page.dart';
import 'package:restaurant_app/upload_meal/upload_meal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDjXN9fYyW6bIEcbNu-_DjeUVhJTmG0xOQ", appId: "1:344288739919:web:a978749a28a1217ee6e03a", messagingSenderId: "344288739919", projectId: "cafeteria-support"));
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreenAccent,
        useMaterial3: true
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UploadMealPage(),
    ProductsPage(restaurantId: "restaurant1",),
    UploadMealPage()
  ];

  Widget _getPage(int index) {
    return _pages[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          
          NavigationRail(
            backgroundColor: Theme.of(context).hoverColor,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.upload),
                label: Text('Upload Item'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.food_bank),
                label: Text('Items'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('Orders'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: _getPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
