import 'package:flutter/material.dart';

enum TextFieldType { text, email, phone, password }

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextFieldType type;
  final FormFieldValidator<String>? validator;

  CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.type,
    this.validator,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (widget.type == TextFieldType.phone) {
      _controller = widget.controller;
      if (!_controller.text.startsWith('+62')) {
        _controller.text = '+62';
      }
      _controller.addListener(_phoneListener);
    } else {
      _controller = widget.controller;
    }
  }

  @override
  void dispose() {
    if (widget.type == TextFieldType.phone) {
      _controller.removeListener(_phoneListener);
    }
    super.dispose();
  }

  void _phoneListener() {
    String text = _controller.text;
    if (!text.startsWith('+62')) {
      _controller.text = '+62';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    } else if (text.startsWith('+620')) {
      _controller.text = '+62' + text.substring(4);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.password:
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  bool _isPasswordField() {
    return widget.type == TextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: _controller,
      keyboardType: _getKeyboardType(),
      obscureText: _isPasswordField() && _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: colorScheme.onBackground),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: isDarkTheme ? Colors.white : colorScheme.onSurface),
        ),
        suffixIcon: _isPasswordField()
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.onBackground,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      cursorColor: colorScheme.secondary,
      style: TextStyle(color: colorScheme.onBackground),
      validator: widget.validator,
    );
  }
}