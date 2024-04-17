import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: UploadImagePage(),
    );
  }
}

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final picker = ImagePicker();
  late XFile _image;


  String _name = ''; // Variable to store the name of the food
  double _price = 0.0; // Variable to store the price of the food
  String _category = 'Category 1'; // Variable to store the selected category

  // List of categories (you can replace it with your own list)
  List<String> _categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
  ];

  // Function to handle category selection
  void _onCategoryChanged(String? value) {
  setState(() {
    _category = value ?? _categories[0]; // Assign a default value if value is null
  });
}

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImage() async {
    print('Upload image functionality should be implemented here.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Meal'),
      ),
      body: Center(
        child:
        SizedBox(
          width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.file(File(_image.path)),

            SizedBox(height: 20), // Add spacing between image and other information
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _price = double.parse(value);
                          });
                        },
                      ),
                      DropdownButton( 
                
              // Initial Value 
              value: _category, 
                
              // Down Arrow Icon 
              icon: const Icon(Icons.keyboard_arrow_down),     
                
              // Array list of items 
              items: _categories.map((String items) { 
                return DropdownMenuItem( 
                  value: items, 
                  child: Text(items), 
                ); 
              }).toList(), 
              onChanged: (String? newValue) {  
                setState(() { 
                  _category = newValue!; 
                }); 
              }, 
            ),

            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: uploadImage, //Upload meal function....
              child: Text('Upload meal'),
            ),
          ],
        ),
      ),
    ));
  }
}