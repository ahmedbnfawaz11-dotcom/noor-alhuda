import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color emerald = Color(0xFF123B30);
const Color gold = Color(0xFFC6A45C);
const Color ivory = Color(0xFFF4EBDD);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seenIntro = prefs.getBool('seen_intro') ?? false;
  runApp(NoorAlHudaApp(showIntro: !seenIntro));
}

class NoorAlHudaApp extends StatelessWidget {
  final bool showIntro;
  const NoorAlHudaApp({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نور الهدى',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: emerald,
          primary: emerald,
          secondary: gold,
          surface: ivory,
        ),
        fontFamily: 'NotoNaskhArabic',
        appBarTheme: const AppBarTheme(
          backgroundColor: emerald,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: showIntro ? const WelcomePage() : const HomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _continue(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_intro', true);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF174A3B), Color(0xFF0D2D25)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Ornament(),
                  const SizedBox(height: 24),
                  const Text(
                    'بِسْمِ اللهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(color: gold, fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'نُورُ الهُدَى',
                    style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'الموسوعة الإسلامية العالمية',
                    style: TextStyle(color: Color(0xFFE9D9B5), fontSize: 17),
                  ),
                  const SizedBox(height: 28),
                  const Divider(color: gold, thickness: 1),
                  const SizedBox(height: 18),
                  const Text(
                    'الحمد لله رب العالمين، حمداً كثيراً طيباً مباركاً فيه، والصلاة والسلام على نبينا محمد، وعلى آله وصحبه أجمعين.',
                    style: TextStyle(color: ivory, height: 1.9, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'اللهم اجعل هذا العمل خالصاً لوجهك الكريم، وانفع به المسلمين، واجعله علماً نافعاً وصدقة جارية، وبارك في صاحبه والقائمين عليه.',
                    style: TextStyle(color: ivory, height: 1.9, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'اللهم ارزقنا علماً نافعاً وعملاً صالحاً وقلباً خاشعاً.',
                    style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: gold,
                      foregroundColor: emerald,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _continue(context),
                    child: const Text('ابدأ رحلتك في طلب العلم', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Ornament extends StatelessWidget {
  const Ornament({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 82,
    height: 82,
    decoration: BoxDecoration(
      border: Border.all(color: gold, width: 2),
      borderRadius: BorderRadius.circular(22),
    ),
    child: const Icon(Icons.menu_book_rounded, color: gold, size: 44),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const sections = [
    ('القرآن وعلومه', Icons.auto_stories_rounded),
    ('الحديث الشريف', Icons.menu_book_rounded),
    ('العقيدة والتوحيد', Icons.lightbulb_outline_rounded),
    ('الفقه الإسلامي', Icons.balance_rounded),
    ('السيرة النبوية', Icons.mosque_rounded),
    ('التاريخ والتراجم', Icons.history_edu_rounded),
    ('اللغة العربية', Icons.translate_rounded),
    ('الرقائق والآداب', Icons.favorite_border_rounded),
    ('أصول الفقه', Icons.account_tree_outlined),
    ('مصطلح الحديث', Icons.fact_check_outlined),
    ('الفتاوى الموثقة', Icons.question_answer_outlined),
    ('المسلمون الجدد', Icons.public_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              Text('نور الهدى', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('الموسوعة الإسلامية العالمية', style: TextStyle(fontSize: 11, color: Color(0xFFE8D9B7))),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'الإعدادات',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: emerald,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: gold, width: 1.2),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',
                    style: TextStyle(color: gold, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('مكتبتك للعلم النافع والتراث الإسلامي',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(height: 16),
                  SearchField(),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeading(title: 'أقسام الموسوعة'),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.75,
              ),
              itemBuilder: (context, index) {
                final item = sections[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showComingSoon(context, item.$1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDCCBA8)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.$2, color: emerald, size: 27),
                        const SizedBox(height: 7),
                        Text(item.$1, textAlign: TextAlign.center,
                          style: const TextStyle(color: emerald, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            const SectionHeading(title: 'مساحات المكتبة'),
            const SizedBox(height: 10),
            FeatureTile(icon: Icons.people_alt_outlined, title: 'العلماء والمؤلفون', subtitle: 'تراجم العلماء ومؤلفاتهم', onTap: () => _showComingSoon(context, 'العلماء والمؤلفون')),
            FeatureTile(icon: Icons.download_for_offline_outlined, title: 'المكتبة والتنزيلات', subtitle: 'إدارة الكتب المتاحة دون إنترنت', onTap: () => _showComingSoon(context, 'المكتبة والتنزيلات')),
            FeatureTile(icon: Icons.bookmark_border, title: 'مكتبتي الخاصة', subtitle: 'المفضلة والعلامات وسجل القراءة', onTap: () => _showComingSoon(context, 'مكتبتي الخاصة')),
          ],
        ),
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name: سيتم تفعيل هذا القسم عند ربط قاعدة الكتب الموثوقة.')),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});
  @override
  Widget build(BuildContext context) => TextField(
    textDirection: TextDirection.rtl,
    decoration: InputDecoration(
      hintText: 'ابحث عن كتاب أو عالم أو موضوع...',
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF6E776F)),
      prefixIcon: const Icon(Icons.search, color: emerald),
      filled: true,
      fillColor: ivory,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    ),
    onSubmitted: (_) => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('سيتم تفعيل البحث الشامل بعد تجهيز فهرس الكتب.')),
    ),
  );
}

class SectionHeading extends StatelessWidget {
  final String title;
  const SectionHeading({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 4, height: 22, decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 9),
      Text(title, style: const TextStyle(color: emerald, fontWeight: FontWeight.bold, fontSize: 18)),
    ],
  );
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const FeatureTile({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Color(0xFFDCCBA8))),
    child: ListTile(
      onTap: onTap,
      leading: Icon(icon, color: emerald, size: 28),
      title: Text(title, style: const TextStyle(color: emerald, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_left, color: gold),
    ),
  );
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) => Drawer(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 25),
            color: emerald,
            child: const Column(children: [
              Icon(Icons.menu_book_rounded, color: gold, size: 44),
              SizedBox(height: 8),
              Text('نور الهدى', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('الموسوعة الإسلامية العالمية', style: TextStyle(color: ivory, fontSize: 12)),
            ]),
          ),
          ListTile(leading: const Icon(Icons.home_outlined), title: const Text('الرئيسية'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.people_outline), title: const Text('العلماء والمؤلفون'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.download_outlined), title: const Text('التنزيلات'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.language), title: const Text('اللغات'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('الإعدادات'), onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          }),
          const Spacer(),
          const Padding(padding: EdgeInsets.all(16), child: Text('نسخة تأسيسية قيد التطوير', style: TextStyle(color: Colors.grey, fontSize: 11))),
        ],
      ),
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.language), title: Text('لغة التطبيق'), subtitle: Text('العربية حالياً — ستضاف اللغات الأخرى')),
          ListTile(leading: Icon(Icons.dark_mode_outlined), title: Text('مظهر القراءة'), subtitle: Text('فاتح / داكن — قيد الإعداد')),
          ListTile(leading: Icon(Icons.storage_outlined), title: Text('مساحة المكتبة'), subtitle: Text('ستظهر أحجام الكتب بعد ربط مستودع المحتوى')),
          ListTile(leading: Icon(Icons.info_outline), title: Text('حول الموسوعة'), subtitle: Text('نور الهدى — الموسوعة الإسلامية العالمية')),
        ],
      ),
    ),
  );
}
