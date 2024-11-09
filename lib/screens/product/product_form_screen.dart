import 'package:flutter/material.dart';
import '../../controllers/product_controller.dart';
import '../../exceptions/app_exception.dart';
import '../../exceptions/product_invalid_state_exception.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;
  final ProductController productController;

  const ProductFormScreen({ super.key, required this.productController, this.productId });

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final String currency = 'Rp';
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
  }

  Future<void> _initializeController() async {
    try {
      if (widget.productId != null) {
        final product = await widget.productController.getSpecificProduct(widget.productId as String);

        _codeController.text = product.code;
        _nameController.text = product.name;
        _priceController.text = product.price.round().toString();
      }
    } catch (e) {
      // Log error
    }
  }

  void onPressedSubmitButtonHandler() {
    try {
      final code = _codeController.text;
      final name = _nameController.text;
      final price = double.parse(_priceController.text);
      final bool isMounted = context.mounted;

      if (widget.productId == null) {
        widget.productController.createProduct(code, name, price)
          .then((isCreateProductSucceed) {
            if (isCreateProductSucceed) {
              if (isMounted) {
                _showSnackBar(context, 'Produk berhasil ditambahkan.');
                Navigator.pop(context);
              }
            }
          }).onError((AppException e, _) {
            if (isMounted) {
              _showSnackBar(context, e.message);
            }
          });
      } else {
        widget.productController.editProduct(widget.productId as String, code, name, price)
          .then((isUpdateProductSucceed) {
            if (isUpdateProductSucceed) {
              if (isMounted) {
                _showSnackBar(context, 'Produk berhasil diedit.');
                Navigator.pop(context);
              }
            }
          }).onError((AppException e, _) {
            if (isMounted) {
              _showSnackBar(context, e.message);
            }
          });
      }
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
      body: FutureBuilder(
        future: _initializeController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal mendapatkan data produk'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    label: Text('Kode Produk'),
                    hintText: 'Masukkan kode produk',
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    label: Text('Nama Produk'),
                    hintText: 'Masukkan nama produk',
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
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
