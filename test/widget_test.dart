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
    expect(prefs.getString('note_${books.first.key}'), 'فائدة أراجعها لاحقاً');
  });

  testWidgets('children learning progress is saved locally', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MaterialApp(home: ChildrenPage()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('تعلم الوضوء'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('غسل الكفين'));
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('children_completed_steps'),
        contains('تعلم الوضوء::غسل الكفين'));
  });

  testWidgets('hadith library loads the sourced narration and its chain', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HadithLibraryPage()));
    await tester.pumpAndSettle();

    expect(find.text('الأحاديث والأسانيد'), findsOneWidget);
    expect(find.text('إنما الأعمال بالنيات'), findsOneWidget);
    await tester.tap(find.text('إنما الأعمال بالنيات'));
    await tester.pumpAndSettle();
    expect(find.textContaining('الحميدي عبد الله بن الزبير'), findsOneWidget);
    expect(find.text('الرواة بالترتيب'), findsOneWidget);
  });

  test('book identity includes both title and author', () {
    expect(books.first.key, '${books.first.title}::${books.first.author}');
  });

  test('Arabic catalog search normalization ignores diacritics', () {
    expect(
      normalizeArabic('رِيَاضُ الصَّالِحِينَ'),
      normalizeArabic('رياض الصالحين'),
    );
  });

}
