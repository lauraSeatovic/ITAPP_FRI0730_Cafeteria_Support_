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
      products.add(doc.data() as Map<String, dynamic>);
    });

    return products;
  }
}