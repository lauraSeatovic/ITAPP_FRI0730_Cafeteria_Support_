import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_methods.dart'; // Import your CloudFirestoreService class

class ProductsPage extends StatefulWidget {
  final String restaurantId;

  const ProductsPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final CloudFirestoreService _firestoreService = CloudFirestoreService(FirebaseFirestore.instance);
  late List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    List<Map<String, dynamic>> products = await _firestoreService.getAllProductsByRestaurantId(widget.restaurantId);
    setState(() {
      _products = products;
    });
  }

  Future<void> _deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(widget.restaurantId, productId);
    await _loadProducts();
  }


  Future<void> _showEditDialog(Map<String, dynamic> product) async {
  TextEditingController nameController = TextEditingController(text: product['name']);
  TextEditingController priceController = TextEditingController(text: product['price'].toString());
  TextEditingController tagController = TextEditingController(text: product['tag']);
  TextEditingController categoryController = TextEditingController(text: product['category']);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Product'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: tagController,
                decoration: InputDecoration(labelText: 'Tag'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              // Update the product in Firestore
              await _firestoreService.updateProduct(
                widget.restaurantId,
                product['id'],
                {
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'tag': tagController.text,
                  'category': categoryController.text,
                },
              );
              // Refresh the product list
              await _loadProducts();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Items'),
    ),
    body: _products.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.all(16),
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Tag')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Actions')), // Add column for actions
                ],
                rows: _products.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product['name'].toString())),
                    DataCell(Text(product['price'].toString())),
                    DataCell(Text(product['tag'].toString())),
                    DataCell(Text(product['category'].toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                              await _showEditDialog(product);
                            },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                              await _deleteProduct(product['id']);
                            },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ],
          ),
  );}}