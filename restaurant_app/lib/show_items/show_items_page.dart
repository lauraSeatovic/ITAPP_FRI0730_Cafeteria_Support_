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
                  DataColumn(label: Text('Actions')), // Add column for actions
                ],
                rows: _products.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product['name'].toString())),
                    DataCell(Text(product['price'].toString())),
                    DataCell(Text(product['tag'].toString())),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit action here
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Implement delete action here
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