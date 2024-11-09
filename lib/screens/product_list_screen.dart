import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../controllers/product_controller.dart';
import '../screens/login_screen.dart';
import '../screens/product_form_screen.dart';

class ProductListScreen extends StatelessWidget {
  final String username;
  final ProductController controller = ProductController();
  final LoginController loginController = LoginController();
  final String currency = 'Rp';

  ProductListScreen({ super.key, required this.username });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              if (loginController.logout(username)) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat datang, $username!',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return ProductFormScreen(productController: controller);
                    }));
                  },
                  child: const Text('Tambah Produk'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: controller.getAllProducts().length,
                itemBuilder: (context, index) {
                  final product = controller.getAllProducts()[index];

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('$currency ${product.price.truncate().toString()}'),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) {
                        return {'Edit', 'Delete'}.map((option) {
                          return PopupMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList();
                      },
                      onSelected: (String option) {
                        switch (option) {
                          case 'Edit': {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return ProductFormScreen(productController: controller, productId: product.id);
                            }));
                          }
                          case 'Delete': {
                            final deleteProductResult = controller.deleteProduct(product.id);

                            if (deleteProductResult) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Produk berhasil dihapus."),
                              ));
                            }
                          }
                        }
                      },
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
