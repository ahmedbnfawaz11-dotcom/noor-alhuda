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
}
