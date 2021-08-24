class PostModel {
  String id;
  String description;
  String src;
  PostType postType;
  PostModel({
    required this.id,
    required this.description,
    required this.src,
    required this.postType,
  });
}

enum PostType { Image, Video }
