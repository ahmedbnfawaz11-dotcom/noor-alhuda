import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_alhuda/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the first-launch screen in Arabic', (tester) async {
    await tester.pumpWidget(const NoorApp(firstRun: true));
    await tester.pumpAndSettle();

    expect(find.text('نُورُ الهُدَى'), findsOneWidget);
    expect(find.text('الموسوعة الإسلامية'), findsOneWidget);
    expect(find.text('متابعة إلى الترحيب'), findsOneWidget);
  });

  testWidgets('shows the home screen after first launch', (tester) async {
    await tester.pumpWidget(const NoorApp(firstRun: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دخول الموسوعة'));
    await tester.pumpAndSettle();

    expect(find.text('أقسام الموسوعة'), findsOneWidget);
    expect(find.text('ابحث عن كتاب أو مؤلف أو قسم...'), findsOneWidget);
  });
  testWidgets('book details provide adjustable text and locally saved notes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NoorApp(firstRun: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دخول الموسوعة'));
    await tester.pumpAndSettle();

    final book = find.text('صحيح البخاري').first;
    await tester.ensureVisible(book);
    await tester.tap(book);
    await tester.pumpAndSettle();

    expect(find.text('بيانات الفهرس'), findsOneWidget);
    expect(find.text('ملاحظاتي الخاصة'), findsOneWidget);
    await tester.enterText(find.byType(TextField).last, 'فائدة أراجعها لاحقاً');
    await tester.tap(find.text('احفظ ملاحظاتي على الجهاز'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('note_صحيح البخاري'), 'فائدة أراجعها لاحقاً');
  });

  testWidgets('catalog search ignores Arabic diacritics', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const NoorApp(firstRun: false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دخول الموسوعة'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'رِيَاضُ الصَّالِحِينَ');
    await tester.pumpAndSettle();

    expect(find.text('رياض الصالحين'), findsWidgets);
  });

}
