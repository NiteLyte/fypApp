import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRecipe extends StatefulWidget {
  final Function(int) onTap;

  const AddRecipe({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ingrController = TextEditingController();
  TextEditingController _prepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: Text("Add a New Recipe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                //border: InputBorder.none,
                hintText: 'Recipe Name',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _ingrController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                //border: InputBorder.none,
                hintText: 'Ingredient used',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _prepController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                //border: InputBorder.none,
                hintText: 'Preperation steps',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FirebaseFirestore.instance.collection("recipe").add({
            "rcp_name": _nameController.text,
            "ingr_used": _ingrController.text,
            "prep_step": _prepController.text
          }).then((value) {
            print(value.id);
            // Navigator.pop(context);
            widget.onTap(0);
          }).catchError(
              (error) => print("Failed to add new recipe due to $error"));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
