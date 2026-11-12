import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noor_alhuda/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // Asset-backed widgets use asynchronous bundle loading. Let real async
  // work complete between frames instead of assuming one 100 ms pump is enough.
  Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 40; attempt++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pump();
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Widget did not appear after waiting for asynchronous loading: $finder');
  }

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
    await tester.scrollUntilVisible(
      find.text('تعلم الوضوء'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
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
    expect(find.text('1. الحميدي عبد الله بن الزبير'), findsOneWidget);
    expect(find.text('الرواة بالترتيب'), findsOneWidget);
  });

  testWidgets('Ajurrumiyyah full text is loaded from the bundled book asset', (tester) async {
    final ajurrumiyyah = books.firstWhere((book) => book.title == 'الآجرومية');
    final bundledText = await tester.runAsync(
      () => rootBundle.loadString(ajurrumiyyah.contentAsset!),
    );
    expect(bundledText, contains('الكلام هو اللفظ المركب المفيد بالوضع'));
    await tester.pumpWidget(MaterialApp(
      home: BookDetails(book: ajurrumiyyah, saved: false, onSave: () {}),
    ));

    // BookDetails uses a lazy ListView. Scroll the asset-backed section into
    // view so its FutureBuilder is mounted before waiting for the text.
    await tester.scrollUntilVisible(
      find.text('النص الرقمي المرفق'),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpUntilFound(
      tester,
      find.textContaining('الكلام هو اللفظ المركب المفيد بالوضع'),
    );
    expect(find.textContaining('ويكي مصدر'), findsOneWidget);
  });

  testWidgets('structured offline reader supports chapter selection and in-book search', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(
      () => rootBundle.loadString('assets/books/alajurrumiyyah.json'),
    );
    await tester.pumpWidget(const MaterialApp(
      home: StructuredBookReader(
        assetPath: 'assets/books/alajurrumiyyah.json',
        bookTitle: 'الآجرومية',
      ),
    ));
    await pumpUntilFound(tester, find.text('فهرس الفصول'));

    // The selected chapter title appears in both the dropdown and the
    // chapter heading, so two matches are expected before searching.
    expect(find.text('متن الآجرومية'), findsNWidgets(2));
    await tester.enterText(find.byType(TextField), 'الكلام هو');
    await tester.pump();
    expect(find.textContaining('نتائج البحث'), findsOneWidget);
    expect(find.textContaining('متن الآجرومية'), findsWidgets);
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
