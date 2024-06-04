import 'package:carousel_slider/carousel_slider.dart';
import 'package:celebrities/core/network/api_client.dart';
import 'package:celebrities/data/repositories/article_repository_impl.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:celebrities/domain/usecases/get_articles.dart';
import 'package:celebrities/presentation/bloc/article_bloc.dart';
import 'package:celebrities/presentation/widgets/article_widget.dart';
import 'package:celebrities/presentation/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArticlePage extends StatefulWidget {
  final Key? key;

  ArticlePage({this.key}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleBloc bloc;
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

  _ArticlePageState()
      : bloc = ArticleBloc(
    getArticles: GetArticles(
      ArticleRepositoryImpl(
        apiClient: ApiClient(baseUrl: 'https://60a4954bfbd48100179dc49d.mockapi.io/api/innocent'),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    bloc.fetchArticles();
  }

  Future<void> _refreshArticles() async {
    await bloc.fetchArticles();
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background color to white
        elevation: 2.0, // Add a thin shadow
        centerTitle: true, // Center the title
        title: Image.asset(
          'assets/logo.png',
          height: 30, // Set the desired height for the logo
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        color: Colors.pink,
        backgroundColor: Colors.white,
        child: StreamBuilder<List<Article>>(
          stream: bloc.articlesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Skeleton for Image Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildSkeleton(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width * 0.8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 20.0,
                          height: 6.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5, // Placeholder count
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSkeleton(double.infinity, 200.0), // Image
                              SizedBox(height: 8),
                              _buildSkeleton(100.0, 16.0), // Contributor name
                              SizedBox(height: 8),
                              _buildSkeleton(double.infinity, 18.0), // Content line 1
                              SizedBox(height: 4),
                              _buildSkeleton(double.infinity, 18.0), // Content line 2
                              SizedBox(height: 4),
                              _buildSkeleton(double.infinity, 18.0), // Content line 3
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No articles available'));
            } else {
              // Get the first 3 articles for the slider
              final sliderArticles = snapshot.data!.take(3).toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ImageSlider(
                      articles: sliderArticles,
                      carouselController: _carouselController,
                      currentIndex: _currentIndex,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'LATEST NEWS',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final article = snapshot.data![index];
                        return ArticleWidget(article: article);
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}