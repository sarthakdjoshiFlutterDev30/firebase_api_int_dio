import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Controller/api_service.dart';

class AddItemScreen extends StatefulWidget {
  final ApiService api;
  AddItemScreen({required this.api});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.image),
              label: Text('Pick Image'),
              onPressed: pickImage,
            ),
            if (_image != null) Image.file(_image!, height: 100),
            SizedBox(height: 20),
            (_isLoading)
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      String? imageUrl;
                      if (_image != null) {
                        imageUrl = await widget.api.uploadImage(_image!);
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      await widget.api.createItem({
                        'title': titleController.text,
                        'description': descController.text,
                        if (imageUrl != null) 'imageUrl': imageUrl,
                      });
                      Navigator.pop(context, true);
                    },
                    child: Text('Save'),
                  ),
          ],
        ),
      ),
    );
  }
}
