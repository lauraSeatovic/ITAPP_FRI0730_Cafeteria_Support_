import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CloudFirestoreService {
  final FirebaseFirestore db;

  final FirebaseStorage storage;

  const CloudFirestoreService(this.db, this.storage);


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


  Future<String> uploadProductImage(File imageFile, String productId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final destination = 'products/$productId/$fileName';

      final ref = storage.ref(destination);
      await ref.putFile(imageFile);

      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> addProductWithImage(Map<String, dynamic> productData, File imageFile, {String restaurantId = "restaurant1"}) async {
    try {
      // Add product without image URL to get productId
      final productId = await addProduct(productData, restaurantId: restaurantId);
      
      // Upload image and get the image URL
      final imageUrl = await uploadProductImage(imageFile, productId);
      
      // Update product with the image URL
      await updateProduct(restaurantId, productId, {'image_url': imageUrl});
    } catch (e) {
      print('Error adding product with image: $e');
      throw e;
    }
  }

}