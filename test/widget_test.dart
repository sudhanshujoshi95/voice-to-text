import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_recognition/main.dart';

void main() {
  testWidgets('Voice recognition UI test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const VoiceToTextApp());

    // Verify that the initial text is displayed in the text field.
    expect(find.text("Press the mic to start recording"), findsOneWidget);

    // Find the microphone icon button and tap it to start recording.
    final micButton = find.byIcon(Icons.mic);
    expect(micButton, findsOneWidget);
    await tester.tap(micButton);
    await tester.pump(); // Rebuild the widget after the state changes

    // Verify that the recording dialog appears with the correct text.
    expect(find.text("Recording..."), findsOneWidget);
    expect(find.text("Your voice is being recorded"), findsOneWidget);

    // Find the "Finish" button in the dialog and tap it to stop recording.
    final finishButton = find.text("Finish");
    await tester.tap(finishButton);
    await tester.pump(); // Close the dialog and rebuild the UI

    // Optionally, verify that the text field updates with the recognized text
    // (this depends on the mock setup for testing voice recognition input).
    expect(find.textContaining("Press the mic to start recording"),
        findsOneWidget);
  });
}
