import 'dart:io';
import 'package:celebrities/data/local/db/database_helper.dart';
import 'package:celebrities/presentation/common/CustomButtomPopUp.dart';
import 'package:celebrities/presentation/common/CustomButton.dart';
import 'package:celebrities/presentation/common/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:celebrities/data/models/article_model.dart';
import 'package:image_picker/image_picker.dart';
import 'form_validation.dart';

class AddArticlePage extends StatefulWidget {
  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final FormValidationNotifier _formValidationNotifier = FormValidationNotifier();
  final TextEditingController _displayDateController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _formValidationNotifier.initListeners();
  }

  @override
  void dispose() {
    _formValidationNotifier.disposeListeners();
    _displayDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          final DateTime combined = DateTime(
            _selectedDate!.year,
            _selectedDate!.month,
            _selectedDate!.day,
            _selectedTime!.hour,
            _selectedTime!.minute,
          );
          _formValidationNotifier.createdAtController.text = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(combined.toUtc());
          _displayDateController.text = DateFormat("dd-MMMM-yyyy HH:mm").format(combined);
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFiles != null) {
        setState(() {
          _selectedImages.addAll(pickedFiles.take(4 - _selectedImages.length));
        });
        _formValidationNotifier.validateForm(_selectedImages);
      }
    } catch (e) {
      _showPermissionPopup();
    }
  }

  void _showPermissionPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomPopup(
          imagePath: 'assets/permission.png',
          title: 'Permission Required',
          description: 'Please grant the required permissions to access photos.',
          positiveButtonText: 'OK',
          onPositiveButtonPressed: () {
            Navigator.of(context).pop();
          },
          dismissible: false,
          showCloseButton: false,
        );
      },
    );
  }

  Future<void> _saveArticle() async {
    if (_formKey.currentState!.validate()) {
      final newArticle = ArticleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _formValidationNotifier.titleController.text,
        content: _formValidationNotifier.contentController.text,
        contentThumbnail: _formValidationNotifier.thumbnailController.text,
        contributorName: _formValidationNotifier.contributorNameController.text,
        createdAt: _formValidationNotifier.createdAtController.text,
        slideshow: _selectedImages.map((file) => file.path).toList(),
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertManualArticle(newArticle);

      _showSuccessPopup();
    }
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomPopup(
          imagePath: 'assets/logo.png',
          title: 'Berhasil',
          description: 'Artikel berhasil ditambahkan.',
          positiveButtonText: 'OK',
          onPositiveButtonPressed: () {
            Navigator.of(context).pop(); // Close the popup
            Navigator.of(context).pop(true); // Return true to indicate a new article has been added
          },
          dismissible: false,
          showCloseButton: false,
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      _formValidationNotifier.validateForm(_selectedImages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Artikel Baru'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: _formValidationNotifier.titleController,
                  labelText: 'Judul',
                  type: TextFieldType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: _formValidationNotifier.contentController,
                  labelText: 'Konten',
                  type: TextFieldType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Konten tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: _formValidationNotifier.contributorNameController,
                  labelText: 'Nama Kontributor',
                  type: TextFieldType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama Kontributor tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextFormField(
                  controller: _formValidationNotifier.thumbnailController,
                  labelText: 'URL Thumbnail',
                  type: TextFieldType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'URL Thumbnail tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _pickDateTime(context),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      controller: _displayDateController,
                      labelText: 'Tanggal Dibuat',
                      type: TextFieldType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Tanggal Dibuat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foto (Maksimal 4, jpg/JPG/jpeg/png)',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        XFile image = entry.value;
                        return Stack(
                          children: [
                            Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _selectedImages.length < 4 ? _pickImage : null,
                      child: Text('Tambah Foto'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _formValidationNotifier,
                  builder: (context, isValid, child) {
                    return CustomButton(
                      text: 'Simpan',
                      onPressed: isValid ? _saveArticle : null,
                      isLoading: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}