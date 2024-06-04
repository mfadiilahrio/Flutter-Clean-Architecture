import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:celebrities/domain/entities/article.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  ArticleDetailPage({required this.article});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  int _selectedImageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final bool hasSlideshow = widget.article.slideshow.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0, // Add a thin shadow
        centerTitle: true,
        leadingWidth: 100, // Adjust the leading width to fit the larger logo
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          child: Image.asset(
            'assets/logo.png',
            height: 40, // Set the desired height for the logo
          ),
        ),
        title: Container(), // Empty container to center the leading and actions
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
            Image.network(
              hasSlideshow ? widget.article.slideshow[_selectedImageIndex] : widget.article.contentThumbnail,
              fit: BoxFit.cover,
              width: double.infinity, // Make the selected image full width
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
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(
                        widget.article.slideshow[index],
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                        color: _selectedImageIndex == index ? Colors.black.withOpacity(0.4) : null,
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  );
                },
              ),
            )
                : Container(), // Handle case when slideshow is empty
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
