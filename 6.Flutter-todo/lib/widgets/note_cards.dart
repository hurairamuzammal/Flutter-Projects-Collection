import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  // Parse the color_id to an int if it's stored as a String
  int colorId = int.tryParse(doc['color_id'].toString()) ?? 0;

  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardColors[colorId],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Make the column's height fit its children
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["notes_title"],
            style: AppStyle.mainTitle,
            
          ),
          const SizedBox(height: 4),
          Text(
            doc["creation_date"],
            style: AppStyle.dateTitle,
          ),
          const SizedBox(height: 15),
          Flexible(
            child: Text(
              doc["note_content"],
              style: AppStyle.maincontent,
              overflow: TextOverflow.ellipsis,
              maxLines: 3, // Adjust based on your preference
            ),
          ),
        ],
      ),
    ),
  );
}
