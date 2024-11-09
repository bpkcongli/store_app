import 'package:flutter/material.dart';
import './user/user_auth_screen.dart';
import '../controllers/login_controller.dart';
import '../controllers/product_controller.dart';
import '../exceptions/app_exception.dart';
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
              final bool isMounted = context.mounted;

              loginController.logout()
                .then((isLogoutSucceed) {
                  if (isMounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return const UserAuthScreen();
                      }),
                    );
                  }
                });
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
              child: FutureBuilder(
                future: controller.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Gagal mendapatkan daftar produk.'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Belum ada produk yang ditambahkan.'),
                    );
                  } else {
                    final products = snapshot.data!;

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

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
                                  final isMounted = context.mounted;

                                  controller.deleteProduct(product.id)
                                    .then((isDeleteProductSucceed) {
                                      if (isDeleteProductSucceed) {
                                        if (isMounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Produk berhasil dihapus.'),
                                          ));
                                        }
                                      }
                                    }).onError((AppException e, _) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(e.message),
                                      ));
                                    });
                                }
                              }
                            },
                          ),
                          onTap: () {},
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
