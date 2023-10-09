import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/recipe_reader.dart';

class EditRecipe extends StatefulWidget {
  final Recipe doc;
  final Function(int) onTap;
  final String id;
  EditRecipe(
      {required this.doc, required this.onTap, required this.id, Key? key})
      : super(key: key);
  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  late TextEditingController _nameController;
  late TextEditingController _ingrController;
  late TextEditingController _prepController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doc.rcp_name);
    _ingrController = TextEditingController(text: widget.doc.ingr_used);
    _prepController = TextEditingController(text: widget.doc.prep_step);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text("Edit Your Recipe"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
          FirebaseFirestore.instance
              .collection("recipe")
              .doc(widget.id)
              .update({
            "rcp_name": _nameController.text,
            "ingr_used": _ingrController.text,
            "prep_step": _prepController.text
          }).then((value) {
            Navigator.pop(context, "done");
            // widget.onTap(0);
          }).catchError(
                  (error) => print("Failed to add new recipe due to $error"));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
