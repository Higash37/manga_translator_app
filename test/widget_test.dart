// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:manga_translator_app/main.dart';

void main() {
  testWidgets('Manga translator app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app launches correctly
    // 画面タイトルやアイコンのテスト内容は必要に応じて修正してください
    expect(find.text('漫画語学学習アプリ'), findsOneWidget);
    // expect(find.byIcon(Icons.language), findsOneWidget); // 必要に応じて
  });
}
