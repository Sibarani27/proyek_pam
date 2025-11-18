import 'package:flutter/material.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'services/api_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Order',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ApiService api = ApiService();
  List<MenuItem> menuItems = [];
  Map<int, int> selectedItems = {}; // key: menuId, value: quantity
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      final items = await api.getMenuItems();
      setState(() {
        menuItems = items;
      });
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  void toggleItem(MenuItem item) {
    setState(() {
      if (selectedItems.containsKey(item.id)) {
        selectedItems[item.id] = selectedItems[item.id]! + 1;
      } else {
        selectedItems[item.id] = 1;
      }
    });
  }

  void removeItem(MenuItem item) {
    setState(() {
      if (selectedItems.containsKey(item.id)) {
        if (selectedItems[item.id]! > 1) {
          selectedItems[item.id] = selectedItems[item.id]! - 1;
        } else {
          selectedItems.remove(item.id);
        }
      }
    });
  }

  Future<void> submitOrder() async {
    if (selectedItems.isEmpty) return;

    setState(() => isLoading = true);

    List<Map<String, dynamic>> orderData = selectedItems.entries.map((entry) {
      final menu = menuItems.firstWhere((m) => m.id == entry.key);
      return {
        'menu_id': menu.id,
        'quantity': entry.value,
        'price_at_order': menu.price,
      };
    }).toList();

    try {
      final order = await api.createOrder(orderData);
      setState(() {
        selectedItems.clear();
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Pesanan Berhasil'),
          content: Text('Pesanan #${order.id} dengan total Rp ${order.totalAmount.toStringAsFixed(0)}'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      print('Error submitting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Cafe')),
      body: menuItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final quantity = selectedItems[item.id] ?? 0;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: item.imageUrl != null
                        ? Image.network(item.imageUrl!, width: 60, height: 60, fit: BoxFit.cover)
                        : Icon(Icons.fastfood, size: 40),
                    title: Text(item.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rp ${item.price.toStringAsFixed(0)}'),
                        if (item.description != null)
                          Text(item.description!, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => toggleItem(item),
                        ),
                        if (quantity > 0)
                          Text('$quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                        if (quantity > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => removeItem(item),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: Icon(Icons.shopping_cart),
          label: isLoading ? Text('Memesan...') : Text('Pesan Sekarang'),
          onPressed: isLoading ? null : submitOrder,
          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
        ),
      ),
    );
  }
}