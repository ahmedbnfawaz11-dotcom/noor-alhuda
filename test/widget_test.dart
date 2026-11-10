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
    await tester.pumpWidget(MaterialApp(
      home: BookDetails(book: books.first, saved: false, onSave: () {}),
    ));
    await tester.pumpAndSettle();

    expect(find.text('بيانات الفهرس'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('ملاحظاتي الخاصة'), 220, scrollable: find.byType(Scrollable).first);
    expect(find.text('ملاحظاتي الخاصة'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(TextField), 220, scrollable: find.byType(Scrollable).first);
    await tester.enterText(find.byType(TextField).first, 'فائدة أراجعها لاحقاً');
    await tester.scrollUntilVisible(find.text('احفظ ملاحظاتي على الجهاز'), 220, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('احفظ ملاحظاتي على الجهاز'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('note_${books.first.title}'), 'فائدة أراجعها لاحقاً');
  });

  testWidgets('offline reader clearly reports when verified book text is absent', (tester) async {
    await tester.pumpWidget(MaterialApp(home: OfflineReaderPage(book: const Book('كتاب غير مدرج للاختبار','مؤلف غير محدد','اختبار',''))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('قارئ الكتب'), findsOneWidget);
    expect(find.text('النص الكامل لهذا الكتاب غير متاح داخل النسخة الحالية'), findsOneWidget);
    expect(find.textContaining('لم نضع نصاً تجريبياً'), findsOneWidget);
  });

  test('Arabic catalog search normalization ignores diacritics', () {
    expect(
      normalizeArabic('رِيَاضُ الصَّالِحِينَ'),
      normalizeArabic('رياض الصالحين'),
    );
  });

}
