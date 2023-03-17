class Playlist {
  String playlistID; //playlistID
  String authorID; // Check if userID equals this; if so, allow edits
  String playlistName; //what will be displayed and searched for
  List<String> tags; //array of tags - use arrycontains when searching firebase
  List<String> stories; // For story ids - to get download urls and relevant data
  String imageURL; //firebase download url for image

  Playlist({ //constructor
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

  Map<String,dynamic> toJson() => { //To map object to JSON
    'playlistID': playlistID,
    'authorID': authorID,
    'playlistName': playlistName,
    'tags': tags,
    'stories': stories,
    'imageURL': imageURL,
  };

  static Playlist fromJson(Map<String,dynamic> json) => Playlist( //maps json to playlist object
    playlistID: json['playlistID'],
    authorID: json['authorID'],
    playlistName: json['playlistName'],
    tags: json['tags'], //Check that correct type is returned
    stories: json['stories'],
    imageURL: json['imageURL'],
  );
}


class Story {
  //TODO: add transcript field and username field
  String storyID; //unique id for story
  String storyName; //name for story - what is searched for and displayed
  String downloadURL; //firebase download url for story - pass into audioplayer package
  String art; //download url for image
  //add length?
  String authorID; //unique id of author of story
  String description; //description of story
  List<String> tags; //array of tags - use arraycontains when searching for tags
  bool series; //True if part of series, False if not
  String seriesID; //Empty String if not part of series

  Story ({ //constructor
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

  Map<String,dynamic> toJson() => { //maps to json
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

  static Story fromJson(Map<String,dynamic> json) => Story( //maps from json to story object
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


class AppUser { //actual account information
  //TODO: add username field
  String userID; //unique id for user - will auto generate
  String firstName; //name of user
  String lastName;//name of user
  String imageURL; //profile image

  AppUser ({ //constructor
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.imageURL,
  });

  Map<String, dynamic> toJson() => { //maps to json
    'userID': userID,
    'firstName': firstName,
    'lastName': lastName,
    'imageURL': imageURL,
  };

  static AppUser fromJson(Map<String,dynamic> json) => AppUser( //maps from json to appuser
    userID: json['userID'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    imageURL: json['imageURL'],
  );
}

class Series { //for keeping track of series
  String seriesID; //unique series id
  String authorID; //unique id of author
  List<String> stories; //array of story ids - use to look up
  String seriesName; //what will be displayed and searched for

  Series({ //constructor
    required this.seriesID,
    required this.authorID,
    required this.stories,
    required this.seriesName,
  });

  Map<String,dynamic> toJson() =>{ //map to json
    'seriesID':seriesID,
    'authorID':authorID,
    'stories': stories,
    'seriesName': seriesName
  };

  static Series fromJson(Map<String,dynamic> json) => Series( //map from json to series object
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

