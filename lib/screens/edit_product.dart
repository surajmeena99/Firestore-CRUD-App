import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_crud_app/screens/db_services.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.editProduct});

  final DocumentSnapshot editProduct;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  final DatabaseService _databaseService = DatabaseService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  initState() {
    super.initState();
    _nameController.text = widget.editProduct['name'];
    _priceController.text = widget.editProduct['price'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit This Product',
                  style: TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name Value Can\'t Be Empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name',
                      labelText: 'Name',
                    )),
                const SizedBox(height: 20.0,),
                TextFormField(
                    controller: _priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price Value Can\'t Be Empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Price',
                      labelText: 'Price',
                    )),
                const SizedBox(height: 20.0,),
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final String name = _nameController.text;
                            final double? price = double.tryParse(_priceController.text);

                            await _databaseService.updateData(widget.editProduct.id, name, price!);
                            Navigator.of(context).pop();
                          }
                          // Don't write here Navigator.of(context).pop();
                          
                        },
                        child: const Text('Update Product')),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () {
                          _nameController.text = '';
                          _priceController.text = '';
                        },
                        child: const Text('Clear Data'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
