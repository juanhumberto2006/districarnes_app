import 'package:flutter_test/flutter_test.dart';
import 'package:districarnes_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const DistriCarnesApp());
    expect(find.text('DISTRICARNES'), findsOneWidget);
  });
}
