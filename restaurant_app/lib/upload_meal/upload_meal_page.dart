import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_methods.dart';

class UploadMealPage extends StatefulWidget {
  @override
  _UploadMealPageState createState() => _UploadMealPageState();
}

class _UploadMealPageState extends State<UploadMealPage> {
  final picker = ImagePicker();
  XFile? _image;

  final _service = CloudFirestoreService(FirebaseFirestore.instance);
  

  String _name = ''; // Variable to store the name of the food
  double _price = 0.0; // Variable to store the price of the food
  String _category = 'Drink'; // Variable to store the selected category

  // List of categories (you can replace it with your own list)
  List<String> _categories = [
    'Drink',
    'Meat',
    'Dessert',
    'Side dish',
  ];

  // Function to handle category selection
  void _onCategoryChanged(String? value) {
    setState(() {
      _category =
          value ?? _categories[0]; // Assign a default value if value is null
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

  Future uploadImage(String name, double price, String tag) async {
  String productId = await _service.addProduct({
    'name': name,
    'price': price,
    'tag': tag,
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Meal'),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _price = double.parse(value);
                    });
                  },
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Container(
                    height: 200, // Set the height of the container
                    width: 200,
                    child: _image != null
                        ? Image.network(_image!.path)
                        : Image.asset('food-placeholder.png')),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  child: Text('Select Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => uploadImage(_name, _price, _category), //Upload meal function....
                  child: Text('Upload meal'),
                ),
              ],
            ),
          ),
        ));
  }
}
