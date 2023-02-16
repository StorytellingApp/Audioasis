import 'package:flutter/material.dart';

class SearchCards extends StatelessWidget {
  const SearchCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CardGenre(),
            CardGenre(),
          ],
        ),
        Row(
          children: [
            CardGenre(),
            CardGenre(),
          ],
        ),
      ],
    );
  }
}

class CardGenre extends StatelessWidget {
  const CardGenre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 195,
        height: 95,
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                Text(
                  "Genre",

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 19.0,
                  ),
                ),
              ],
            ),
            Transform.rotate(
              angle: 0.5,
                child: const Image(
                image: NetworkImage('https://images.pexels.com/photos/208745/pexels-photo-208745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                  width: 70.0,
                  height: 60.0,
                ),
            ),
          ],
        ),
      )
    );
  }
}
