import 'package:celebrities/domain/entities/article.dart';
import 'package:equatable/equatable.dart';

class ArticleModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String contentThumbnail;
  final String contributorName;
  final String createdAt;
  final List<String> slideshow;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.contentThumbnail,
    required this.contributorName,
    required this.createdAt,
    this.slideshow = const [], // Default value for slideshow
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      contentThumbnail: json['contentThumbnail'],
      contributorName: json['contributorName'],
      createdAt: json['createdAt'],
      slideshow: json['slideshow'] != null ? List<String>.from(json['slideshow']) : [], // Handle null slideshow
    );
  }

  Article toEntity() {
    return Article(
      id: id,
      title: title,
      content: content,
      contentThumbnail: contentThumbnail,
      contributorName: contributorName,
      createdAt: createdAt,
      slideshow: slideshow,
    );
  }

  @override
  List<Object?> get props => [id, title, content, contentThumbnail, contributorName, createdAt, slideshow];
}