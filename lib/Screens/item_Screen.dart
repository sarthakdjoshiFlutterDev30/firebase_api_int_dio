import 'package:flutter/material.dart';
import '../Model/item_model.dart';
import 'add_item_screen.dart';
import '../Controller/api_service.dart';
import 'login_screen.dart';

class ItemsScreen extends StatefulWidget {
  final ApiService api;
  ItemsScreen({required this.api});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  void fetchItems() async {
    final data = await widget.api.getItems();
    setState(
      () => items = data
          .map<Item_Model>((item) => Item_Model.fromJson(item['id'], item))
          .toList(),
    );
  }

  void deleteItem(String id) async {
    await widget.api.deleteItem(id);
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Items"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await widget.api.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          if (item.id == null) {
            return Center(child: Text("No Data Found"));
          } else {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  item.imageUrl.isNotEmpty
                      ? item.imageUrl
                      : 'https://via.placeholder.com/150',
                ),
              ),
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => deleteItem(item.id),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemScreen(api: widget.api)),
          );
          if (added == true) fetchItems();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
