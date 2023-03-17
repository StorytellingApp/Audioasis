import 'package:flutter/material.dart';

//Not sure what this is used for - commenter was not author of this module

class SearchCards {
  final String url;
  final String author;
  final String storyTitle;

  const SearchCards({
    required this.url,
    required this.author,
    required this.storyTitle
  });
}

  List<SearchCards> items = [
    const SearchCards(
      url: 'https://cdn.britannica.com/83/156583-050-4A1FABB5/Red-raspberries.jpg',
      author: 'Edgar',
      storyTitle: 'Raspberry',
    ),
    const SearchCards(url: "https://media.istockphoto.com/id/505161000/photo/spam.jpg?s=612x612&w=0&k=20&c=Tof-sfyPZ0KtdvpumWdfaChOTHuRXN6jNhqzvlrhTFI=",
      author: 'SammyTheSpam',
      storyTitle: 'All about Spam',
    ),
    const SearchCards(
      url: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d1b8154e-56f8-417d-b243-5fba52b4890e/d2ojazn-a113192c-9f46-4aac-af07-b0470f02d840.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2QxYjgxNTRlLTU2ZjgtNDE3ZC1iMjQzLTVmYmE1MmI0ODkwZVwvZDJvamF6bi1hMTEzMTkyYy05ZjQ2LTRhYWMtYWYwNy1iMDQ3MGYwMmQ4NDAuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.m2JA5w8U_pWdLpRKCmHqf5-remJfIMXbi9Ggr4_FW2k",
      author: 'Osteraloa',
      storyTitle: 'La Cucaracha',
    ),
    const SearchCards(
      url: "https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bG92ZSUyMGhlYXJ0fGVufDB8fDB8fA%3D%3D&w=1000&q=80",
      author: 'Masf',
      storyTitle: 'I Love you',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width,
      height: 256.0,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (context, _) => const SizedBox(width: 12,),
          itemBuilder: (BuildContext context, int index) =>  buildCard(item: items[index], ),
           /* return Row(children:  [
              TopPicks(url: url, author: author, storyTitle: storyTitle,),
            ],
            );*/

      ),
    );
  }

// class TopPicks extends StatelessWidget {
//   final String url;
//   final String author;
//   final String storyTitle;
//   const TopPicks({Key? key, required this.url, required this.author, required this.storyTitle}) : super(key: key);

  Widget buildCard({required SearchCards item}) => Container(
    width: 200,
    child: Column(
      children: [
        Expanded(
            child: AspectRatio(
              aspectRatio: 4/3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                    item.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          item.storyTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          item.author,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
    );


/*
SafeArea(
child: SingleChildScrollView(
child: Card(
child: Container(
width: 195,
color: Colors.blueAccent,
child: Row(
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
),
),
),

);*/
