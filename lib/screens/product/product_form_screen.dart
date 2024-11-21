import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../exceptions/product_invalid_state_exception.dart';
import '../../viewmodels/product_view_model.dart';

class ProductFormScreen extends StatefulWidget {
  final String? productId;

  const ProductFormScreen({ super.key, this.productId });

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = context.watch<ProductViewModel>();
    if (viewModel.apiErrorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar(context, viewModel.apiErrorMessage!);
        viewModel.clearError();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
  }

  Future<void> _initializeController() async {
    final viewModel = context.read<ProductViewModel>();

    try {
      if (widget.productId != null) {
        final product = await viewModel.getSpecificProduct(widget.productId!);

        if (product != null) {
          _codeController.text = product.code;
          _nameController.text = product.name;
          _priceController.text = product.price.round().toString();
        }
      }
    } catch (e) {
      // Log error
    }
  }

  Future<void> onPressedSubmitButtonHandler() async {
    final viewModel = context.read<ProductViewModel>();

    try {
      final code = _codeController.text;
      final name = _nameController.text;
      final price = double.parse(_priceController.text);

      if (widget.productId == null) {
        final createProductResult = await viewModel.createProduct(code, name, price);

        if (createProductResult && mounted) {
          Navigator.pop(context, true);
        }
      } else {
        final editProductResult = await viewModel.editProduct(widget.productId as String, code, name, price);

        if (editProductResult && mounted) {
          Navigator.pop(context, true);
        }
      }
    } on ProductInvalidStateException catch (_) {
      if (mounted) {
        _showSnackBar(context, 'Data yang Anda masukkan tidak valid.');
      }
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
