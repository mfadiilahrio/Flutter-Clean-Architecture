import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormValidationNotifier extends ValueNotifier<bool> {
  FormValidationNotifier() : super(false);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController contributorNameController = TextEditingController();
  final TextEditingController thumbnailController = TextEditingController();
  final TextEditingController createdAtController = TextEditingController();

  List<XFile> _images = [];

  void initListeners() {
    titleController.addListener(_validateForm);
    contentController.addListener(_validateForm);
    contributorNameController.addListener(_validateForm);
    thumbnailController.addListener(_validateForm);
    createdAtController.addListener(_validateForm);
  }

  void disposeListeners() {
    titleController.removeListener(_validateForm);
    contentController.removeListener(_validateForm);
    contributorNameController.removeListener(_validateForm);
    thumbnailController.removeListener(_validateForm);
    createdAtController.removeListener(_validateForm);
  }

  void _validateForm() {
    value = titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        contributorNameController.text.isNotEmpty &&
        thumbnailController.text.isNotEmpty &&
        createdAtController.text.isNotEmpty &&
        _images.isNotEmpty;
  }

  void validateForm(List<XFile> images) {
    _images = images;
    _validateForm();
  }
}