import 'package:flutter/material.dart';

void main() {
  runApp(const MatjariApp());
}

class Product {
  final String id;
  final String nameAr;
  final String nameEn;
  final String storeAr;
  final String storeEn;
  final double price;
  final String categoryAr;
  final String categoryEn;
  final String imageUrl;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.storeAr,
    required this.storeEn,
    required this.price,
    required this.categoryAr,
    required this.categoryEn,
    required this.imageUrl,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class MatjariApp extends StatefulWidget {
  const MatjariApp({super.key});

  @override
  State<MatjariApp> createState() => _MatjariAppState();
}

class _MatjariAppState extends State<MatjariApp> {
  bool _isArabic = true;

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _isArabic ? 'متجري | Matjari' : 'Matjari App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF1B5E20),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F4),
        fontFamily: 'Roboto',
      ),
      home: Directionality(
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: MainHomeScreen(
          isArabic: _isArabic,
          onToggleLanguage: _toggleLanguage,
        ),
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onToggleLanguage;

  const MainHomeScreen({
    super.key,
    required this.isArabic,
    required this.onToggleLanguage,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  String _selectedCategoryAr = 'الكل';
  String _selectedCategoryEn = 'All';
  String _searchQuery = '';
  
  bool _isMerchantLoggedIn = false;

  final List<CartItem> _cart = [];

  final List<Product> _products = [
    Product(
      id: '1',
      nameAr: 'وجبة برغر عائلية',
      nameEn: 'Family Burger Meal',
      storeAr: 'Crunchyz Burgers',
      storeEn: 'Crunchyz Burgers',
      price: 15.0,
      categoryAr: 'طعام',
      categoryEn: 'Food',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
    ),
    Product(
      id: '2',
      nameAr: 'قميص رجالي عصري',
      nameEn: 'Modern Men Shirt',
      storeAr: 'متجر الأناقة',
      storeEn: 'Elegance Store',
      price: 25.0,
      categoryAr: 'ألبسة',
      categoryEn: 'Clothes',
      imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500',
    ),
    Product(
      id: '3',
      nameAr: 'هاتف ذكي جديد',
      nameEn: 'New Smartphone',
      storeAr: 'تكنو ستور',
      storeEn: 'Techno Store',
      price: 300.0,
      categoryAr: 'إلكترونيات',
      categoryEn: 'Electronics',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
    ),
  ];

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isArabic
            ? 'تمت إضافة ${product.nameAr} إلى السلة'
            : 'Added ${product.nameEn} to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addNewProduct(Product newProduct) {
    setState(() {
      _products.add(newProduct);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool ar = widget.isArabic;
    final pages = [
      _buildShoppingTab(),
      _isMerchantLoggedIn ? _buildMerchantDashboard() : _buildMerchantLogin(),
      _buildCartTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF2E7D32), size: 22),
            ),
            const SizedBox(width: 8),
            Text(
              ar ? 'متجري | Matjari' : 'Matjari',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: widget.onToggleLanguage,
            icon: const Icon(Icons.language, color: Colors.white, size: 18),
            label: Text(
              ar ? 'EN' : 'عربي',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  setState(() => _currentIndex = 2);
                },
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF2E7D32),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.storefront_rounded),
            label: ar ? 'التسوق' : 'Shop',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.admin_panel_settings_rounded),
            label: ar ? 'لوحة التاجر' : 'Merchant',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_checkout_rounded),
            label: ar ? 'السلة' : 'Cart',
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingTab() {
    final bool ar = widget.isArabic;
    final categories = ar
        ? ['الكل', 'طعام', 'ألبسة', 'إلكترونيات']
        : ['All', 'Food', 'Clothes', 'Electronics'];

    final filtered = _products.where((p) {
      final categoryMatch = ar
          ? (_selectedCategoryAr == 'الكل' || p.categoryAr == _selectedCategoryAr)
          : (_selectedCategoryEn == 'All' || p.categoryEn == _selectedCategoryEn);
      
      final productName = ar ? p.nameAr : p.nameEn;
      final storeName = ar ? p.storeAr : p.storeEn;
      final searchMatch = productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          storeName.toLowerCase().contains(_searchQuery.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: ar ? 'ابحث عن منتج أو متجر...' : 'Search product or store...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final cat = categories[i];
              final isSelected = ar ? (_selectedCategoryAr == cat) : (_selectedCategoryEn == cat);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFFC8E6C9),
                  activeColor: const Color(0xFF2E7D32),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF1B5E20) : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (_) {
                    setState(() {
                      if (ar) {
                        _selectedCategoryAr = cat;
                      } else {
                        _selectedCategoryEn = cat;
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    ar ? 'لا توجد منتجات مطابقة' : 'No matching products found',
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final p = filtered[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      clipBehavior: Clip.antiAlias,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              p.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported, size: 50),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ar ? p.nameAr : p.nameEn,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  ar ? p.storeAr : p.storeEn,
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${p.price.toStringAsFixed(0)}\$',
                                      style: const TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF2E7D32), size: 20),
                                      onPressed: () => _addToCart(p),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        )
      ],
    );
  }

  Widget _buildMerchantLogin() {
    final bool ar = widget.isArabic;
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront_rounded, size: 70, color: Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 15),
          Text(
            ar ? 'تسجيل دخول التاجر (حساب تجريبي)' : 'Merchant Login (Demo Account)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            ar ? 'اسم المستخدم: merchant | كلمة المرور: 1234' : 'Username: merchant | Password: 1234',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: userCtrl,
            decoration: InputDecoration(
              labelText: ar ? 'اسم المستخدم' : 'Username',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: passCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: ar ? 'كلمة المرور' : 'Password',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (userCtrl.text == 'merchant' && passCtrl.text == '1234') {
                  setState(() => _isMerchantLoggedIn = true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ar
                          ? 'بيانات الدخول خاطئة! استعمل: merchant / 1234'
                          : 'Invalid credentials! Use: merchant / 1234'),
                    ),
                  );
                }
              },
              child: Text(ar ? 'دخول للوحة التاجر' : 'Login to Dashboard'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMerchantDashboard() {
    final bool ar = widget.isArabic;
    final nameCtrl = TextEditingController();
    final storeCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final imageCtrl = TextEditingController();
    String category = 'طعام';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ar ? 'لوحة التاجر - إضافة منتج' : 'Merchant Dashboard - Add Product',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () => setState(() => _isMerchantLoggedIn = false),
              )
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
              labelText: ar ? 'اسم المنتج' : 'Product Name',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: storeCtrl,
            decoration: InputDecoration(
              labelText: ar ? 'اسم المتجر' : 'Store Name',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: ar ? 'السعر (\$)' : 'Price (\$)',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: imageCtrl,
            decoration: InputDecoration(
              labelText: ar ? 'رابط الصورة (URL)' : 'Image URL',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          StatefulBuilder(
            builder: (context, setDropdownState) => DropdownButtonFormField<String>(
              value: category,
              items: ['طعام', 'ألبسة', 'إلكترونيات']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setDropdownState(() => category = v!),
              decoration: InputDecoration(
                labelText: ar ? 'القسم' : 'Category',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                  _addNewProduct(
                    Product(
                      id: DateTime.now().toString(),
                      nameAr: nameCtrl.text,
                      nameEn: nameCtrl.text,
                      storeAr: storeCtrl.text.isEmpty ? 'متجري' : storeCtrl.text,
                      storeEn: storeCtrl.text.isEmpty ? 'Matjari' : storeCtrl.text,
                      price: double.tryParse(priceCtrl.text) ?? 10.0,
                      categoryAr: category,
                      categoryEn: category,
                      imageUrl: imageCtrl.text.isNotEmpty
                          ? imageCtrl.text
                          : 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إضافة المنتج بنجاح!' : 'Product added successfully!')),
                  );
                  setState(() => _currentIndex = 0);
                }
              },
              child: Text(ar ? 'نشر المنتج في المتجر' : 'Publish Product'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    final bool ar = widget.isArabic;
    final double total = _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    if (_cart.isEmpty) {
      return Center(
        child: Text(
          ar ? 'السلة فارغة حالياً' : 'Cart is currently empty',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (context, i) {
              final item = _cart[i];
              return ListTile(
                leading: Image.network(item.product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(ar ? item.product.nameAr : item.product.nameEn),
                subtitle: Text('${item.product.price}\$ × ${item.quantity} = ${(item.product.price * item.quantity).toStringAsFixed(0)}\$'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          if (item.quantity > 1) {
                            item.quantity--;
                          } else {
                            _cart.removeAt(i);
                          }
                        });
                      },
                    ),
                    Text('${item.quantity}'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2E7D32)),
                      onPressed: () {
                        setState(() {
                          item.quantity++;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ar ? "المجموع" : "Total"}: ${total.toStringAsFixed(0)}\$',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ar ? 'تم إرسال الطلب بنجاح!' : 'Order placed successfully!')),
                  );
                  setState(() => _cart.clear());
                },
                child: Text(ar ? 'إتمام الشراء' : 'Checkout'),
              )
            ],
          ),
        )
      ],
    );
  }
}
