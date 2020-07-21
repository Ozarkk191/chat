class NewsModel {
  String title;
  String imageUrl;
  String timePost;
  String groupUID;
  String imageGroup;
  String nameGroup;
  bool isActive;

  NewsModel(
      {this.title,
      this.imageUrl,
      this.timePost,
      this.groupUID,
      this.imageGroup,
      this.nameGroup,
      this.isActive});

  NewsModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        imageUrl = json['imageUrl'],
        timePost = json['timePost'],
        groupUID = json['groupUID'],
        imageGroup = json['imageGroup'],
        nameGroup = json['nameGroup'];

  toJson() {
    return {
      "title": title,
      "imageUrl": imageUrl,
      "timePost": timePost,
      "groupUID": groupUID,
      "imageGroup": imageGroup,
      "nameGroup": nameGroup,
    };
  }
}
