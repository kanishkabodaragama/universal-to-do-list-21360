import 'package:flutter_test/flutter_test.dart';
import 'package:todo_frontend/main.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    await tester.pumpWidget(const MyApp());
    // Initial route depends on auth state; just ensure a frame is built.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
