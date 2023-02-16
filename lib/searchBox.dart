import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.0,
        color: Colors.white,
      child: Row(
        children: const [
          SizedBox(
            width: 10.0,
          ),
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Authors, Stories, or Playlist",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
