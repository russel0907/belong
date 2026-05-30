import 'package:flutter_test/flutter_test.dart';
import 'package:belong/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const BelongApp());
    expect(find.byType(BelongApp), findsOneWidget);
  });
}
