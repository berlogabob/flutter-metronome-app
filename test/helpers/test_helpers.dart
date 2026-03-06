import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

/// Helper function to pump widget with ProviderScope
Future<void> pumpAppWidget(
  WidgetTester tester,
  Widget widget, {
  List<Override>? overrides,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
