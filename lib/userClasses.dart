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
  List<String> tags;
  bool series; //True if part of series, False if not
  String seriesID; //Empty String if not part of series

  Story ({
    required this.storyID,
    required this.storyName,
    required this.downloadURL,
    required this.art,
    required this.authorID,
    required this.description,
    required this.tags,
    required this.series,
    required this.seriesID,
  });

  Map<String,dynamic> toJson() => {
    'storyID': storyID,
    'storyName': storyName,
    'downloadURL': downloadURL,
    'art': art,
    'authorID': authorID,
    'description': description,
    'tags': tags,
    'series':series,
    'seriesID':seriesID,
  };

  static Story fromJson(Map<String,dynamic> json) => Story(
    storyID: json['storyID'],
    storyName: json['storyName'],
    downloadURL: json['downloadURL'],
    art: json['art'],
    authorID: json['authorID'],
    description: json['description'],
    tags: json['tags'], //TODO: Is this right?
    series: json['series'],
    seriesID: json['seriesID'],
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

class Series {
  String seriesID;
  String authorID;
  List<String> stories;
  String seriesName;

  Series({
    required this.seriesID,
    required this.authorID,
    required this.stories,
    required this.seriesName,
  });

  Map<String,dynamic> toJson() =>{
    'seriesID':seriesID,
    'authorID':authorID,
    'stories': stories,
    'seriesName': seriesName
  };

  static Series fromJson(Map<String,dynamic> json) => Series(
    seriesID: json['seriesID'],
    authorID: json['authorID'],
    stories: json['stories'],
    seriesName: json['seriesName'],
  );

  String getSeriesID() {
    return seriesID;
  }

  String getSeriesName() {
    return seriesName;
  }
}

