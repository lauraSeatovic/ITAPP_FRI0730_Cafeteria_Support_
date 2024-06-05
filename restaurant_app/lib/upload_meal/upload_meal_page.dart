import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadMealPage extends StatefulWidget {
  @override
  _UploadMealPageState createState() => _UploadMealPageState();
}

class _UploadMealPageState extends State<UploadMealPage> {
  final picker = ImagePicker();
  XFile? _image;

  final _service = CloudFirestoreService(FirebaseFirestore.instance, FirebaseStorage.instance);

  String _name = '';
  double _price = 0.0;
  String _category = 'Drink';
  String _tag = 'baklava';

  // List of categories (you can replace it with your own list)
  List<String> _categories = [
    'Drink',
    'Meat',
    'Dessert',
    'Side dish',
  ];

  List<String> _tags = ['baklava', 'apple_pie'];

  // Function to handle category selection
  void _onCategoryChanged(String? value) {
    setState(() {
      _category =
          value ?? _categories[0]; // Assign a default value if value is null
    });
  }

  void _onTagChanged(String? value) {
    setState(() {
      _tag = value ?? _tags[0]; // Assign a default value if value is null
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

  Future uploadImage(String name, double price, String tag, String category) async {
  if (_image == null) {
    print('No image selected');
    return;
  }

  try {
    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('meal_images/${_image!.name}');
    
    // For web platform, upload image data directly
    final bytes = await _image!.readAsBytes();
    await storageRef.putData(bytes);
    final imageUrl = await storageRef.getDownloadURL();

    // Add product to Firestore
    String productId = await _service.addProduct({
      'name': name,
      'price': price,
      'tag': tag,
      'category': category,
      'image_url': imageUrl, // Add image URL to Firestore document
    });

    print('Product added with ID: $productId');
  } catch (e) {
    print('Failed to upload image and save product: $e');
  }
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Category', // Title text
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _category,
                      icon: const Icon(Icons.keyboard_arrow_down),
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
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tag', // Title text
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: _tag,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _tags.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _tag = newValue!;
                        });
                      },
                    ),
                  ],
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
                  onPressed: () => uploadImage(_name, _price, _tag,
                      _category), //Upload meal function....
                  child: Text('Upload meal'),
                ),
              ],
            ),
          ),
        ));
  }
}
