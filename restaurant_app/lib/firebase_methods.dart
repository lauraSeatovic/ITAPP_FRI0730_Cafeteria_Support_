import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore db;

  const CloudFirestoreService(this.db);

  Future<String> addProduct(Map<String, dynamic> data, {String restaurantId = "restaurant1"}) async {
    // Add a new document to the "products" collection under the specified restaurantId
    final document = await db.collection('restaurant').doc(restaurantId).collection('products').add(data);
    return document.id;
  }

  Future<List<Map<String, dynamic>>> getAllProductsByRestaurantId(String restaurantId) async {
    QuerySnapshot querySnapshot = await db
        .collection('restaurant')
        .doc(restaurantId)
        .collection('products')
        .get();

    List<Map<String, dynamic>> products = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the data map
      products.add(data);
    });

    print("Products list: $products"); // Print the entire list of products

    return products;
  }

  Future<void> deleteProduct(String restaurantId, String productId) async {
    await db
        .collection('restaurant')
        .doc(restaurantId)
        .collection('products')
        .doc(productId)
        .delete();
  }

  Future<void> updateProduct(String restaurantId, String productId, Map<String, dynamic> productData) async {
    await db
        .collection('restaurant')
        .doc(restaurantId)
        .collection('products')
        .doc(productId)
        .update(productData);
  }

}