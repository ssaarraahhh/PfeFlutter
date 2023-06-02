import 'package:dronalms/app/modules/Calendrier/views/planning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  testWidgets('Test Planning Widget', (WidgetTester tester) async {
    // Build the TestingWidget with the Planning widget
    await tester.pumpWidget(TestingWidget(child: Planning()));

    // Verify the initial state of the widget
    expect(find.text('Month'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the future to complete and rebuild the widget
    await tester.pumpAndSettle();

    // Verify the rendered state of the widget
    expect(find.text('Month'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsOneWidget);

    // Perform any additional tests as needed, such as interacting with the widget

    // Example: Tap on a task checkbox and verify the state change
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(find.text('test'), findsOneWidget); // Verify that the task state is updated to "test"
  });
}

class TestingWidget extends StatelessWidget {
  final Widget child;

  const TestingWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }
}
