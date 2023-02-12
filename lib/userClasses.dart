class Playlist {
  String playlistID; //playlistID
  String authorID; // Check if userID equals this; if so, allow edits
  String playlistName;
  List<String> tags;
  List<String> stories; // For story ids - to get download urls and relevant data
  String imageURL;

  Playlist({
    required this.playlistID,
    required this.authorID,
    required this.playlistName,
    required this.tags,
    required this.stories,
    required this.imageURL,
  });

  void addStory(String storyID) {
    stories.add(storyID);
  }

  List<String> getAllStories() {
    return stories;
  }

  Map<String,dynamic> toJson() => {
    'playlistID': playlistID,
    'authorID': authorID,
    'playlistName': playlistName,
    'tags': tags,
    'stories': stories,
    'imageURL': imageURL,
  };

  static Playlist fromJson(Map<String,dynamic> json) => Playlist(
    playlistID: json['playlistID'],
    authorID: json['authorID'],
    playlistName: json['playlistName'],
    tags: json['tags'], //Check that correct type is returned
    stories: json['stories'],
    imageURL: json['imageURL'],
  );
}


class Story {
  String storyID;
  String storyName;
  String downloadURL;
  String art; //download url for image
  //add length?
  String authorID;
  String description;

  Story ({
    required this.storyID,
    required this.storyName,
    required this.downloadURL,
    required this.art,
    required this.authorID,
    required this.description,
  });

  Map<String,dynamic> toJson() => {
    'storyID': storyID,
    'storyName': storyName,
    'downloadURL': downloadURL,
    'art': art,
    'authorID': authorID,
    'description': description,
  };

  static Story fromJson(Map<String,dynamic> json) => Story(
    storyID: json['storyID'],
    storyName: json['storyName'],
    downloadURL: json['downloadURL'],
    art: json['art'],
    authorID: json['authorID'],
    description: json['description'],
  );
}


class AppUser {
  String userID;
  String firstName;
  String lastName;
  String imageURL;

  AppUser ({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.imageURL,
  });

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'firstName': firstName,
    'lastName': lastName,
    'imageURL': imageURL,
  };

  static AppUser fromJson(Map<String,dynamic> json) => AppUser(
    userID: json['userID'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    imageURL: json['imageURL'],
  );
}