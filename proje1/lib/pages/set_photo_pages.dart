import 'dart:html';
import 'dart:io' as io;

import 'package:flutter/material.dart';

class setPhotoPage extends StatefulWidget {
  const setPhotoPage({Key? key}) : super(key: key);

  @override
  State<setPhotoPage> createState() => _setPhotoPageState();
}

class _setPhotoPageState extends State<setPhotoPage> {
  File? _image;
  Future _pickImage(CanvasImageSource source) async{}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
