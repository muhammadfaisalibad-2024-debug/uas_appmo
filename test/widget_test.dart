// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:e_ticketing_dummy/main.dart';

void main() {
  testWidgets('App starts with Splash Screen showing E-Ticketing Helpdesk', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our Splash Screen is displayed.
    expect(find.text('E-Ticketing Helpdesk'), findsOneWidget);
    expect(find.text('Solusi pelaporan IT terpadu'), findsOneWidget);

    // Advance the timer by 2 seconds to complete the navigation to LoginScreen
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
