import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final CollectionReference _products = FirebaseFirestore.instance.collection('products');

  // Create
  Future<void> addData(Map<String, dynamic> data) async {
    try {
      await _products.add(data);
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  // Read
  Stream<QuerySnapshot> getData() {
    return _products.snapshots();
  }

  // Update
  Future<void> updateData(String id, String name, double price) async {
    try {
      await _products.doc(id).update({
        'name': name,
        'price': price,
      });
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Delete
  Future<void> deleteData(String id) async {
    try {
      await _products.doc(id).delete();
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
