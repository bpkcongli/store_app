import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_form_screen.dart';
import '../user/user_auth_screen.dart';
import '../../common/user_info.dart';
import '../../viewmodels/product_view_model.dart';
import '../../viewmodels/user_view_model.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String username = 'user';

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      username = (await UserInfo().getUsername())!;

      if (mounted) {
        final viewModel = context.read<ProductViewModel>();
        viewModel.getAllProducts();
      }
    });
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

  Future<void> onRefreshHandler() async {
    final viewModel = context.read<ProductViewModel>();
    await viewModel.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Product List'),
      ),
      drawer: const _ProductListDrawer(),
      body: RefreshIndicator(
        onRefresh: onRefreshHandler,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang, $username',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Expanded(
                child: _ProductList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductListDrawer extends StatelessWidget {
  const _ProductListDrawer();

  Future<void> onLogoutHandler(BuildContext context, VoidCallback callback) async {
    final viewModel = context.read<UserViewModel>();
    final logoutResult = await viewModel.logout();
    
    if (logoutResult) {
      callback();
    }
  }

  Future<void> onAddNewProductButtonPressedHandler(BuildContext context, VoidCallback callback) async {
    final viewModel = context.read<ProductViewModel>();
    final result = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (context) {
      return const ProductFormScreen();
    }));

    if (result == true) {
      callback();
      await viewModel.getAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/logo_mercubuana.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(''),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Tambah Produk'),
            onTap: () async {
              onAddNewProductButtonPressedHandler(context, () {
                _showSnackBar(context, 'Produk berhasil ditambahkan.');
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              onLogoutHandler(context, () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const UserAuthScreen();
                  }),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final String currency = 'Rp';

  const _ProductList();

  Future<void> onEditProductOptionSelectedHandler(String productId, BuildContext context, VoidCallback callback) async {
    final viewModel = context.read<ProductViewModel>();
    final result = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (context) {
      return ProductFormScreen(productId: productId);
    }));

    if (result == true) {
      callback();
      await viewModel.getAllProducts();
    }
  }

  Future<void> onDeleteProductOptionSelectedHandler(String productId, BuildContext context, VoidCallback callback) async {
    final viewModel = context.read<ProductViewModel>();
    final deleteProductResult = await viewModel.deleteProduct(productId);

    if (deleteProductResult) {
      callback();
      await viewModel.getAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        return viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.products.isEmpty
            ? const Center(child: Text('Belum ada produk yang ditambahkan.'))
            : ListView.builder(
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
                      onSelected: (String option) async {
                        switch (option) {
                          case 'Edit': {
                            onEditProductOptionSelectedHandler(product.id, context, () {
                              _showSnackBar(context, 'Produk berhasil diedit.');
                            });
                          }
                          case 'Delete': {
                            onDeleteProductOptionSelectedHandler(product.id, context, () {
                              _showSnackBar(context, 'Produk berhasil dihapus.');
                            });
                          }
                        }
                      },
                    ),
                    onTap: () {},
                  );
                },
              );
      },
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
