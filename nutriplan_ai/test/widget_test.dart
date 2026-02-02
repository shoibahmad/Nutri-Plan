// Basic widget test for NutriPlan AI

import 'package:flutter_test/flutter_test.dart';
import 'package:nutriplan_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriPlanApp());
    
    // Verify that the app loads
    expect(find.text('NutriPlan AI'), findsWidgets);
  });
}
