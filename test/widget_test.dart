// Teste pentru aplicatia laboratorului 2.

import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';

import 'package:lab_2_pam/main.dart';

void main() {
  testWidgets('Navigheaza de pe Home pe Course Overview', (tester) async {
    await tester.pumpWidget(const OnlineCourseApp());

    // Prima pagina
    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('Learning Plan'), findsOneWidget);

    // Apasa butonul din prima caseta a slider-ului
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // A doua pagina
    expect(find.text('Course Overview'), findsOneWidget);
    expect(find.text('Enroll Now'), findsOneWidget);
  });

  testWidgets('Prima pagina nu crapa cand ecranul este raportat 0x0',
      (tester) async {
    // La primul frame Android poate raporta inca o suprafata de 0x0.
    // Latimile slider-ului se calculau din (latime - 40) si deveneau
    // negative, ceea ce arunca exceptie in PageView (padding negativ).
    tester.view.physicalSize = const Size(0, 0);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const OnlineCourseApp());
    expect(tester.takeException(), isNull);
  });
}
