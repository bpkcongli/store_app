import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../exceptions/product_invalid_state_exception.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;
  final ProductController productController;

  const ProductFormScreen({ super.key, required this.productController, this.productId });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final String currency = 'Rp';
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    if (widget.productId == null) {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _priceController = TextEditingController();
    } else {
      final product = widget.productController.getSpecificProduct(widget.productId as String);

      _nameController = TextEditingController(text: product.name);
      _descriptionController = TextEditingController(text: product.code);
      _priceController = TextEditingController(text: product.price.round().toString());
    }
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
  }

  void onPressedSubmitButtonHandler() {
    try {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);

      if (widget.productId == null) {
        widget.productController.addNewProduct(name, description, price);
        _showSnackBar(context, 'Produk berhasil ditambahkan.');
      } else {
        widget.productController.editProduct(widget.productId as String, name, description, price);
        _showSnackBar(context, 'Produk berhasil diedit.');
      }

      Navigator.pop(context);
    } on ProductInvalidStateException catch (_) {
      _showSnackBar(context, 'Data yang Anda masukkan tidak valid.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.productId == null ? 'Create Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text('Nama Produk'),
                hintText: 'Masukkan nama produk',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                label: Text('Deskripsi Produk'),
                hintText: 'Masukkan deskripsi produk',
              ),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: const Text('Harga Produk'),
                hintText: 'Masukkan harga produk',
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(currency),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onPressedSubmitButtonHandler,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
