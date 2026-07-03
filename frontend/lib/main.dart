import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  print('=== CareerPath App Starting ===');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
