import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/edit_recipe.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeReader extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  final Function(int) onTap;
  RecipeReader({required this.doc, required this.onTap, Key? key})
      : super(key: key);
  @override
  State<RecipeReader> createState() => _RecipeReaderState();
}

class Recipe {
  String rcp_name;
  String ingr_used;
  String prep_step;

  Recipe({
    required this.rcp_name,
    required this.ingr_used,
    required this.prep_step,
  });
}

class _RecipeReaderState extends State<RecipeReader> {
  late Recipe localData;

  void refreshPage() {
    final docRef =
        FirebaseFirestore.instance.collection("recipe").doc(widget.doc.id);
    docRef.get().then((doc) {
      final data = doc.data();
      setState(() {
        localData = Recipe(
            rcp_name: data?["rcp_name"],
            ingr_used: data?["ingr_used"],
            prep_step: data?["prep_step"]);
      });
    });
  }

  @override
  void initState() {
    localData = Recipe(
      rcp_name: widget.doc["rcp_name"],
      ingr_used: widget.doc["ingr_used"],
      prep_step: widget.doc["prep_step"],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text("Recipe Overview",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection("recipe")
                  .doc(widget.doc.id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
              }).catchError((error) =>
                      print("Failed to delete recipe due to $error"));
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text("Recipe ID: ${widget.doc.id}"),
            Text(localData.rcp_name,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
            SizedBox(height: 28.0),
            Text("Ingredient used: ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                )),
            Text(localData.ingr_used),
            SizedBox(height: 18.0),
            Text("Preperation steps: ",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                )),
            Text(localData.prep_step),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditRecipe(
                doc: localData,
                id: widget.doc.id,
                onTap: widget.onTap,
              ),
            ),
          ).then((value) => refreshPage());
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
