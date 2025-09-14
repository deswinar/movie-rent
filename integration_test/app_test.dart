// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_rent/main.dart' as app; // adjust to your main.dart entry

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('basic navigation flow', (tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Check Home screen is default
    expect(find.text('Home Screen'), findsOneWidget);

    // Navigate to Rented
    await tester.tap(find.text('Rented'));
    await tester.pumpAndSettle();
    expect(find.text('Rented Screen'), findsOneWidget);

    // Navigate to Explore
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Explore Screen'), findsOneWidget);

    // Navigate to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile Screen'), findsOneWidget);

    // Back to Home
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
