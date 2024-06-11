import 'package:carousel_slider/carousel_slider.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/presentation/article/pages/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageSlider extends StatelessWidget {
  final List<Article> articles;
  final CarouselController carouselController;
  final int currentIndex;
  final Function(int) onPageChanged;

  ImageSlider({
    required this.articles,
    required this.carouselController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  Widget _buildSkeleton(double width, double height) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width * 0.8,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 1.0, // Ensure no margin between items
              onPageChanged: (index, reason) {
                onPageChanged(index);
              },
            ),
            items: articles.map((article) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(article: article),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.network(
                            article.contentThumbnail,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
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
                                height: double.infinity,
                                color: Colors.grey[300], // Grey background on error
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        article.contributorName,
                        style: TextStyle(fontSize: 16, color: Colors.pink),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        article.content,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(articles.length, (index) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(index),
                child: Container(
                  width: currentIndex == index ? 35.0 : 20.0,  // Active indicator wider than inactive
                  height: 6.0,  // Adjust the height for a more pill shape
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),  // Adjust the radius for a more pill shape
                    color: currentIndex == index
                        ? Colors.pinkAccent
                        : Colors.grey.withOpacity(0.4),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}