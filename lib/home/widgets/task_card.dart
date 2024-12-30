import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String description;

  const TaskCard(
    {
      super.key,
      required this.color,
      required this.headerText,
      required this.description
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headerText,
           style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      )
    );
  }
}