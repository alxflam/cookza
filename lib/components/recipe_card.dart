import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://img.chefkoch-cdn.de/rezepte/881941193747522/bilder/986131/crop-600x400/spaetzle-pfanne.jpg'),
                  fit: BoxFit.cover,
                ),
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(5),
                //   topRight: Radius.circular(5),
                // ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Käsespätzle',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            )
          ],
        ),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          // borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
