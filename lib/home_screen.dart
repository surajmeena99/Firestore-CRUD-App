import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_crud_app/add_product.dart';
import 'package:firestore_crud_app/db_services.dart';
import 'package:firestore_crud_app/edit_product.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final DatabaseService _databaseService = DatabaseService();

  Future<void> _deleteConfirmationDialog(DocumentSnapshot product) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _databaseService.deleteData(product.id);
                setState(() {}); // Refresh the UI
                Navigator.pop(context);
              },
              child: const Text('Delete'),
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
        title: const Text('Products List'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _databaseService.getData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data!.docs;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot product = products[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Text(product['price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => EditProduct(editProduct: products[index],))
                              );
                            }
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteConfirmationDialog(product)
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddProduct())
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}