import 'dart:typed_data';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Uint8List image;

  const DetailPage(this.image, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
