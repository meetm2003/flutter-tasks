import 'package:authapp/Services/data_services.dart';
import 'package:authapp/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final DataServices _dataServices = DataServices();

  void _addPost() async {
    final title = _titleController.text.trim();
    final data = _dataController.text.trim();

    if (title.isEmpty || data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Both title and data are required!")),
      );
      return;
    }

    try {
      await _dataServices.addPost(title, data, context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post added successfully!")));
      Navigator.pop(context); // Return to previous page
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding post: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.size.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter post title...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: padding * 0.98,
                  horizontal: padding,
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _dataController,
                maxLines: null, // Makes the TextField grow as needed
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Write your post here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: padding * 0.98,
                    horizontal: padding,
                  ),
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: "Add Notes",
              onPressed: _addPost,
            ),
          ],
        ),
      ),
    );
  }
}
