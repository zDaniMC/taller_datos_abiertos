// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';

void main() {
  testWidgets('El dashboard muestra las cards de los endpoints',
          (WidgetTester tester) async {
        await tester.pumpWidget(const DatosAbiertosApp());
        await tester.pumpAndSettle();

        expect(find.text('Datos Abiertos de Colombia'), findsOneWidget);
        expect(find.text('Departamentos'), findsOneWidget);
        expect(find.text('Presidentes'), findsOneWidget);
      });
}