import 'package:flutter/material.dart';

void main() {
  runApp(const MatjariApp());
}

class MatjariApp extends StatelessWidget {
  const MatjariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجري - Matjari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'الكل', 'icon': Icons.grid_view},
    {'name': 'ألبسة', 'icon': Icons.checkroom},
    {'name': 'طعام', 'icon': Icons.fastfood},
    {'name': 'إلكترونيات', 'icon': Icons.devices},
    {'name': 'سيارات', 'icon': Icons.directions_car},
    {'name': 'عقارات', 'icon': Icons.home},
    {'name': 'خدمات', 'icon': Icons.build},
  ];

  final List<Map<String, dynamic>> products = [
    {
      'title': 'قميص رجالي عصري',
      'price': '25\$',
      'category': 'ألبسة',
      'store': 'متجر الأناقة',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'وجبة برغر عائلية',
      'price': '15\$',
      'category': 'طعام',
      'store': 'Crunchyz Burgers',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'هاتف ذكي جديد',
      'price': '300\$',
      'category': 'إلكترونيات',
      'store': 'تكنو ستور',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجري | Matjari', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: _selectedIndex == 0 ? _buildBrowsePage() : _buildSellerDashboard(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'التسوق'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'لوحة التاجر'),
        ],
      ),
    );
  }

  Widget _buildBrowsePage() {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ChoiceChip(
                  label: Text(categories[index]['name']),
                  selected: false,
                  avatar: Icon(categories[index]['icon'], size: 18),
                  onSelected: (val) {},
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(item['store'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['price'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.chat, color: Colors.deepPurple, size: 20),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(productName: item['title'], storeName: item['store']),
                                    ),
                                  );
                                },
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
        ),
      ],
    );
  }

  Widget _buildSellerDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('لوحة تحكم التاجر', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            color: Colors.deepPurple[50],
            child: const ListTile(
              leading: Icon(Icons.storefront, color: Colors.deepPurple),
              title: Text('متجري الفعال: Crunchyz Burgers'),
              subtitle: Text('حالة الاشتراك: مجاني (فترة تجريبية)'),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
            label: const Text('إضافة منتج جديد'),
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String productName;
  final String storeName;

  const ChatScreen({super.key, required this.productName, required this.storeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                const Icon(Icons.shopping_bag, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text('الاستفسار عن: $productName', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('بدء المحادثة المباشرة مع التاجر...'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك للتاجر...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
