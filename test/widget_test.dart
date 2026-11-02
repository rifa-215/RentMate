import 'package:flutter_test/flutter_test.dart';
import 'package:rentmate/main.dart';

void main() {
  testWidgets('RentMate splash screen test', (WidgetTester tester) async {
    await tester.pumpWidget(const RentMateApp());

    expect(find.text('RentMate'), findsOneWidget);
  });
}
