import 'package:celebrities/data/common/Resource.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:celebrities/presentation/article/bloc/article_bloc.dart';
import 'package:celebrities/presentation/article/widgets/article_widget.dart';
import 'package:celebrities/presentation/article/widgets/image_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final ArticleBloc bloc = GetIt.I<ArticleBloc>();
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          title: Image.asset(
            'assets/logo.png',
            height: 30,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 15.0, // Shadow effect for AppBar
          iconTheme: Theme.of(context).appBarTheme.iconTheme
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        color: Colors.pink,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: StreamBuilder<Resource<List<Article>>>(
          stream: bloc.articlesStream,
          builder: (context, snapshot) {
            final resource = snapshot.data;
            if (resource == null || resource.status == Status.Loading) {
              return SingleChildScrollView(
                child: Column(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 120,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
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
            } else if (resource.status == Status.Error) {
              return Center(child: Text('Error: ${resource.message}'));
            } else if (resource.status == Status.Success && resource.data != null) {
              final articles = resource.data!;
              final sliderArticles = articles.take(3).toList();
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
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
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
            } else {
              return Center(child: Text('No articles available'));
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