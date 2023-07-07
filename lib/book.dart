class Book {
  String id;
  String title;
  String subtitle;
  List<dynamic> authors;
  String thumbnail; // 썸네일 이미지 링크
  String previewLink;
  String publishedDate; // ListTile 을 눌렀을 때 이동하는 링크

  Book({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.thumbnail,
    required this.publishedDate,
    required this.previewLink,
  });

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'previewLink': previewLink,
      'publishedDate': publishedDate,
      'subtitle': subtitle,
      'thumbnail': thumbnail
    };
  }

  factory Book.fromJson(json) {
    return Book(
        id: json['id'],
        title: json['title'],
        authors: json['authors'],
        previewLink: json['previewLink'],
        publishedDate: json['publishedDate'],
        subtitle: json['subtitle'],
        thumbnail: json['thumbnail']);
  }
}
