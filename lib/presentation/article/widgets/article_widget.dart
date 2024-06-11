import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/presentation/article/pages/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            Image.network(
              article.contentThumbnail,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300], // Grey background on error
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              article.contributorName,
              style: TextStyle(fontSize: 16, color: Colors.pink),
            ),
            const SizedBox(height: 8),
            Text(
              article.content,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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