import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String content;
  final String contentThumbnail;
  final String contributorName;
  final String createdAt;
  final List<String> slideshow;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.contentThumbnail,
    required this.contributorName,
    required this.createdAt,
    this.slideshow = const [], // Default value for slideshow
  });

  @override
  List<Object?> get props => [id, title, content, contentThumbnail, contributorName, createdAt, slideshow];
}