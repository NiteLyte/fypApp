import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget recipeEntry(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doc["rcp_name"]),
          Text(doc["ingr_used"]),
        ],
      ),
    ),
  );
}
