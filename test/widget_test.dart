import 'package:flutter_test/flutter_test.dart';
import 'package:sazotech_coran/main.dart';

void main() {
  testWidgets('L accueil SAZOTECH apparait', (WidgetTester tester) async {
    await tester.pumpWidget(const SazotechCoranApp());
    expect(find.text('SAZOTECH CORAN'), findsOneWidget);
    expect(find.text('Lire Al-Fatiha'), findsOneWidget);
  });
}
