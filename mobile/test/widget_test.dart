import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bramble_mobile/core/widgets/bramble_button.dart';
import 'package:bramble_mobile/core/widgets/bramble_chip.dart';
import 'package:bramble_mobile/core/widgets/book_cover_view.dart';

void main() {
  group('Bramble Core Widgets Test', () {
    testWidgets('BrambleButton renders and responds to tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrambleButton(
              text: 'Start Reading',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Start Reading'), findsOneWidget);
      await tester.tap(find.text('Start Reading'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('BrambleChip renders label and selection state', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrambleChip(
              label: 'Slow fantasy',
              isSelected: true,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Slow fantasy'), findsOneWidget);
      await tester.tap(find.text('Slow fantasy'));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('BookCoverView renders title and badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookCoverView(
              title: 'The Salt Almanac',
              badge: 'CH 48',
              width: 112,
              height: 158,
            ),
          ),
        ),
      );

      expect(find.text('The Salt Almanac'), findsOneWidget);
      expect(find.text('CH 48'), findsOneWidget);
    });
  });
}
