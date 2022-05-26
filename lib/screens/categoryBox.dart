import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  String? catName;
  String image;
  CategoryBox({required this.catName, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 160,
      width: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Color.fromARGB(148, 0, 0, 0), BlendMode.darken),
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            image: NetworkImage(image),
          ),
        ),
        child: Center(
          child: Text(
            catName!,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
