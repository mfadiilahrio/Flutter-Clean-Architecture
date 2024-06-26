import 'dart:io';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/presentation/article/pages/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final Key? key;

  const ArticleWidget({this.key, required this.article}) : super(key: key);

  String formatRelativeTime(String createdAt) {
    final now = DateTime.now();
    final createdDate = DateTime.parse(createdAt);
    final difference = now.difference(createdDate);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else {
      return DateFormat.yMMMd().format(createdDate);
    }
  }

  bool isLocal(String url) {
    return !url.startsWith('http');
  }

  Widget _buildShimmer(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImage(String url) {
    return isLocal(url)
        ? Image.file(
      File(url),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        } else {
          return _buildShimmer(double.infinity, 200.0);
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Failed to load image',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    )
        : Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        } else {
          return _buildShimmer(double.infinity, 200.0);
        }
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: Center(
            child: Text(
              'Failed to load image',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(article: article),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(article.contentThumbnail),
            const SizedBox(height: 8),
            Text(
              article.contributorName,
              style: TextStyle(fontSize: 16, color: Colors.pink),
            ),
            const SizedBox(height: 8),
            Text(
              article.content,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              formatRelativeTime(article.createdAt),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}