import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/api/dio.dart';


void main() {
  DioClient.init();
  runApp(const ProviderScope(child: MyApp()));
}
