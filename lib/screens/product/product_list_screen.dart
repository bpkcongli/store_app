import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_form_screen.dart';
import '../user/user_auth_screen.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/product_controller.dart';
import '../../exceptions/app_exception.dart';
import '../../viewmodels/product_view_model.dart';

class ProductListScreen extends StatefulWidget {
  final String username;

  const ProductListScreen({ super.key, required this.username });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController controller = ProductController();
  final LoginController loginController = LoginController();
  final String currency = 'Rp';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<ProductViewModel>();
      viewModel.getAllProducts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final viewModel = context.watch<ProductViewModel>();
    if (viewModel.apiErrorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(viewModel.apiErrorMessage!)),
        );

        viewModel.clearError();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();

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
      body: RefreshIndicator(
        onRefresh: viewModel.getAllProducts,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang, ${widget.username}!',
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
                  itemCount: viewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = viewModel.products[index];
  
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
