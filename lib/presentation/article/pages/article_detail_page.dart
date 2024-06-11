import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  ArticleDetailPage({required this.article});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  int _selectedImageIndex = 0;
  bool _isMainImageLoading = true;
  List<bool> _isSlideshowLoading = [];

  @override
  void initState() {
    super.initState();
    _isSlideshowLoading = List<bool>.filled(widget.article.slideshow.length, true);
  }

  String formatDate(String createdAt) {
    final createdDate = DateTime.parse(createdAt);
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(createdDate);
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "fitur belum dibuat",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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

  @override
  Widget build(BuildContext context) {
    final bool hasSlideshow = widget.article.slideshow.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            height: 40,
          ),
        ),
        title: Container(),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "K-POP",
                style: TextStyle(fontSize: 16, color: Colors.pink),
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18.0),
            Text(
              widget.article.contributorName,
              style: TextStyle(fontSize: 14, color: Colors.pink),
            ),
            SizedBox(height: 2.0),
            Text(
              formatDate(widget.article.createdAt),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16.0),
            Stack(
              children: [
                if (_isMainImageLoading) _buildShimmer(double.infinity, 200.0),
                Image.network(
                  hasSlideshow ? widget.article.slideshow[_selectedImageIndex] : widget.article.contentThumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _isMainImageLoading = false;
                          });
                        }
                      });
                      return child;
                    }
                    return _buildShimmer(double.infinity, 200.0);
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _isMainImageLoading = false;
                        });
                      }
                    });
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8.0),
            hasSlideshow
                ? Container(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.article.slideshow.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Stack(
                      children: [
                        if (_isSlideshowLoading[index]) _buildShimmer(100.0, 100.0),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            widget.article.slideshow[index],
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                            color: _selectedImageIndex == index ? Colors.black.withOpacity(0.4) : null,
                            colorBlendMode: BlendMode.darken,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (mounted) {
                                    setState(() {
                                      _isSlideshowLoading[index] = false;
                                    });
                                  }
                                });
                                return child;
                              }
                              return _buildShimmer(100.0, 100.0);
                            },
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    _isSlideshowLoading[index] = false;
                                  });
                                }
                              });
                              return Container(
                                width: 100.0,
                                height: 100.0,
                                color: Colors.grey[300],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
                : Container(),
            SizedBox(height: 16.0),
            Text(
              "Foto: " + widget.article.contributorName,
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.article.content,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            RichText(
              text: TextSpan(
                text: 'Baca juga: ',
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Wah! Ternyata Ini Kebiasaan Tidur Aneh Anggota BTS',
                    style: TextStyle(color: Colors.pink, fontSize: 16, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = _showToast,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}