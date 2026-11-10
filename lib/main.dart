import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const green = Color(0xFF123B30), gold = Color(0xFFC6A45C), paper = Color(0xFFF6F0E4);
const books = <Book>[
 Book('القرآن الكريم','كلام الله تعالى','القرآن وعلومه','المصحف الشريف بالرسم العثماني، كاملاً في 114 سورة، من نص مشروع تنزيل الموثق.'),
 Book('صحيح البخاري','الإمام محمد بن إسماعيل البخاري','الحديث الشريف','من أمهات كتب الحديث النبوي.'),
 Book('صحيح مسلم','الإمام مسلم بن الحجاج','الحديث الشريف','مصنف من أشهر دواوين السنة النبوية.'),
 Book('رياض الصالحين','الإمام يحيى بن شرف النووي','الحديث والآداب','أحاديث في الإيمان والعبادات والأخلاق والآداب.'),
 Book('الأربعون النووية','الإمام يحيى بن شرف النووي','الحديث الشريف','مجموعة مشهورة من جوامع أحاديث النبي صلى الله عليه وسلم.'),
 Book('الأحاديث القدسية','أحاديث نبوية قدسية','الحديث الشريف','أربعون حديثاً قدسياً من النصوص الحديثية الموثقة المصدر.'),
 Book('الأربعون حديثاً للشاه ولي الله الدهلوي','الإمام شاه ولي الله الدهلوي','الحديث الشريف','أربعون حديثاً من مجموعة الشاه ولي الله الدهلوي.'),
 Book('الأدب المفرد','الإمام محمد بن إسماعيل البخاري','الحديث والآداب','مصنف في بر الوالدين وصلة الرحم وحسن الخلق.'),
 Book('الرسالة','الإمام محمد بن إدريس الشافعي','أصول الفقه','من أوائل المصنفات المستقلة في أصول الفقه.'),
 Book('تفسير القرآن العظيم','الإمام إسماعيل بن عمر ابن كثير','القرآن وعلومه','تفسير بالمأثور يعتني بالآيات والأحاديث وأقوال السلف.'),
 Book('العقيدة الواسطية','شيخ الإسلام ابن تيمية','العقيدة والتوحيد','رسالة موجزة في أصول الاعتقاد.'),
 Book('كتاب التوحيد','الإمام محمد بن عبد الوهاب','العقيدة والتوحيد','كتاب في تقرير توحيد العبادة.'),
 Book('بلوغ المرام','الحافظ ابن حجر العسقلاني','الفقه والحديث','جمع أحاديث الأحكام مع عزوها إلى مصادرها.'),
 Book('زاد المعاد','الإمام ابن قيم الجوزية','السيرة والشمائل','مصنف في هدي النبي صلى الله عليه وسلم وسيرته.'),
 Book('الأذكار','الإمام يحيى بن شرف النووي','الأذكار والرقائق','جمع للأذكار والأدعية الواردة في العبادات وأحوال اليوم.'),
 Book('سنن أبي داود','الإمام أبو داود سليمان بن الأشعث','الحديث الشريف','من كتب السنن المشهورة، ويضم أحاديث الأحكام وغيرها.'),
 Book('جامع الترمذي','الإمام محمد بن عيسى الترمذي','الحديث الشريف','من دواوين السنة، ويذكر الترمذي أحكاماً على كثير من الأحاديث.'),
 Book('سنن النسائي','الإمام أحمد بن شعيب النسائي','الحديث الشريف','أحد كتب السنن المعتمدة في الحديث النبوي.'),
 Book('سنن ابن ماجه','الإمام محمد بن يزيد ابن ماجه','الحديث الشريف','كتاب من كتب الحديث الستة المشهورة.'),
 Book('موطأ الإمام مالك','الإمام مالك بن أنس','الحديث الشريف','مصنف مبكر يجمع الحديث والآثار وأبواب الفقه.'),
 Book('مسند الإمام أحمد','الإمام أحمد بن حنبل','الحديث الشريف','مسند واسع مرتب على أسماء الصحابة رواة الحديث.'),
 Book('الشمائل المحمدية','الإمام محمد بن عيسى الترمذي','السيرة والشمائل','كتاب في صفات النبي صلى الله عليه وسلم وأخلاقه وآدابه.'),
 Book('تفسير السعدي','الشيخ عبد الرحمن بن ناصر السعدي','القرآن وعلومه','تفسير ميسر العبارة يعتني بالمعاني والهدايات.'),
 Book('أيسر التفاسير','الشيخ أبو بكر الجزائري','القرآن وعلومه','تفسير مختصر يجمع المعنى والإرشاد بأسلوب واضح.'),
 Book('لمعة الاعتقاد','الإمام موفق الدين ابن قدامة','العقيدة والتوحيد','رسالة مختصرة في أصول اعتقاد أهل السنة.'),
 Book('العقيدة الطحاوية','الإمام أبو جعفر الطحاوي','العقيدة والتوحيد','متن مشهور في تقرير جملة من مسائل الاعتقاد.'),
 Book('شرح العقيدة الطحاوية','ابن أبي العز الحنفي','العقيدة والتوحيد','شرح موسع لمتن العقيدة الطحاوية.'),
 Book('ثلاثة الأصول','الشيخ محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة تعليمية في معرفة العبد ربه ودينه ونبيه.'),
 Book('القواعد الأربع','الشيخ محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة موجزة في قواعد تتعلق بالتوحيد والشرك.'),
 Book('كشف الشبهات','الشيخ محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة في مناقشة شبهات تتعلق بمسائل التوحيد.'),
 Book('الحموية','شيخ الإسلام ابن تيمية','العقيدة والتوحيد','رسالة في مسائل الأسماء والصفات.'),
 Book('التدمرية','شيخ الإسلام ابن تيمية','العقيدة والتوحيد','رسالة في أصول جامعة في توحيد الله وأسمائه وصفاته.'),
 Book('العبودية','شيخ الإسلام ابن تيمية','العقيدة والتوحيد','رسالة في حقيقة عبادة الله وما تتضمنه من المحبة والذل.'),
 Book('الوابل الصيب','الإمام ابن قيم الجوزية','الأذكار والرقائق','كتاب في فضل الذكر وآثاره على القلب.'),
 Book('الفوائد','الإمام ابن قيم الجوزية','الأذكار والرقائق','فوائد وتأملات إيمانية وتربوية متنوعة.'),
 Book('الداء والدواء','الإمام ابن قيم الجوزية','الأذكار والرقائق','كتاب في أمراض القلوب وأسباب صلاحها وعلاجها.'),
 Book('مدارج السالكين','الإمام ابن قيم الجوزية','الأذكار والرقائق','شرح لمنازل السائرين في تزكية النفس والسلوك.'),
 Book('منهاج السنة النبوية','شيخ الإسلام ابن تيمية','العقيدة والتوحيد','مصنف مطول في مناقشة مسائل الاعتقاد والردود العلمية.'),
 Book('اقتضاء الصراط المستقيم','شيخ الإسلام ابن تيمية','الفقه والحديث','بحث في مخالفة أهل الكتاب وما يتعلق بذلك من مسائل.'),
 Book('جامع بيان العلم وفضله','الإمام ابن عبد البر','اللغة العربية','مصنف في فضل العلم وآدابه وأحوال أهله.'),
 Book('سير أعلام النبلاء','الإمام شمس الدين الذهبي','التاريخ والتراجم','تراجم واسعة لأعلام من القرون الإسلامية الأولى.'),
 Book('البداية والنهاية','الإمام إسماعيل بن عمر ابن كثير','التاريخ والتراجم','مصنف تاريخي يتناول أخبار الأمم والسيرة والتاريخ الإسلامي.'),
 Book('نخبة الفكر','الحافظ ابن حجر العسقلاني','الحديث والآداب','متن مختصر في مصطلح الحديث وأقسامه.'),
 Book('تيسير مصطلح الحديث','الدكتور محمود الطحان','الحديث والآداب','مدخل تعليمي معاصر إلى مباحث مصطلح الحديث.'),
 Book('الأم','الإمام محمد بن إدريس الشافعي','كتب أهل السنة والجماعة','من أوسع كتب الإمام الشافعي في الفقه والاستدلال.'), 
 Book('اختلاف الحديث','الإمام محمد بن إدريس الشافعي','كتب أهل السنة والجماعة','كتاب في بيان وجوه الجمع بين الأحاديث التي يظهر تعارضها.'), 
 Book('خلق أفعال العباد','الإمام محمد بن إسماعيل البخاري','كتب أهل السنة والجماعة','مصنف في مسائل الإيمان والرد على أقوال في خلق أفعال العباد.'), 
 Book('الأدب المفرد','الإمام محمد بن إسماعيل البخاري','كتب أهل السنة والجماعة','مصنف في الآداب والأخلاق وبر الوالدين وصلة الرحم.'), 
 Book('الزهد','الإمام أحمد بن حنبل','كتب أهل السنة والجماعة','روايات وآثار في الزهد والرقائق.'), 
 Book('فضائل الصحابة','الإمام أحمد بن حنبل','كتب أهل السنة والجماعة','روايات في فضائل أصحاب النبي صلى الله عليه وسلم.'), 
 Book('العلل ومعرفة الرجال','الإمام أحمد بن حنبل','كتب أهل السنة والجماعة','مسائل وروايات تتعلق بعلل الحديث ومعرفة الرجال.'), 
 Book('المدونة الكبرى','رواية سحنون عن ابن القاسم عن الإمام مالك','كتب أهل السنة والجماعة','من أشهر كتب الفقه المالكي، وهي رواية عن ابن القاسم عن مالك.'), 
 Book('إعلام الموقعين عن رب العالمين','الإمام ابن قيم الجوزية','كتب أهل السنة والجماعة','مصنف في أصول الفتوى والاجتهاد ومقاصد الشريعة.'), 
 Book('بدائع الفوائد','الإمام ابن قيم الجوزية','كتب أهل السنة والجماعة','فوائد علمية ولغوية وفقهية وتربوية متنوعة.'), 
 Book('تحفة المودود بأحكام المولود','الإمام ابن قيم الجوزية','كتب أهل السنة والجماعة','كتاب في أحكام المولود وآداب تربيته.'), 
 Book('اقتضاء الصراط المستقيم','شيخ الإسلام ابن تيمية','كتب أهل السنة والجماعة','بحث في مخالفة أهل الكتاب وما يتصل بها من مسائل.'), 
 Book('مجموع الفتاوى','شيخ الإسلام ابن تيمية','كتب أهل السنة والجماعة','مجموعة فتاوى ورسائل ومسائل علمية في أبواب متعددة.'), 
 Book('جامع العلوم والحكم','الإمام ابن رجب الحنبلي','كتب أهل السنة والجماعة','شرح لأحاديث جامعة في أصول الدين والآداب والأحكام.'), 
 Book('لطائف المعارف','الإمام ابن رجب الحنبلي','كتب أهل السنة والجماعة','كتاب في مواسم الطاعات والرقائق والآداب.'), 
 Book('التمهيد لما في الموطأ من المعاني والأسانيد','الإمام ابن عبد البر','كتب أهل السنة والجماعة','شرح حديثي وفقهي موسع لأحاديث موطأ الإمام مالك.'), 
 Book('الاستذكار','الإمام ابن عبد البر','كتب أهل السنة والجماعة','شرح فقهي وحديثي لمسائل موطأ الإمام مالك.'),
 Book('النحو الواضح','علي الجارم ومصطفى أمين','علوم اللغة العربية','كتاب تعليمي في قواعد النحو العربي مع أمثلة وتدريبات.'), 
 Book('شرح ابن عقيل على ألفية ابن مالك','بهاء الدين ابن عقيل','علوم اللغة العربية','شرح تراثي مشهور لأبواب النحو ومسائل الإعراب.'), 
 Book('شذا العرف في فن الصرف','أحمد الحملاوي','علوم اللغة العربية','مدخل مرتب إلى علم الصرف وأوزان الكلمات والاشتقاق.'), 
 Book('التطبيق الصرفي','عبده الراجحي','علوم اللغة العربية','عرض تعليمي لقواعد الصرف العربي وتطبيقاتها.'), 
 Book('البلاغة الواضحة','علي الجارم ومصطفى أمين','علوم اللغة العربية','مدخل إلى علوم المعاني والبيان والبديع مع شواهد تطبيقية.'), 
 Book('جواهر البلاغة','أحمد الهاشمي','علوم اللغة العربية','كتاب جامع لأبواب البلاغة العربية وعلومها الثلاثة.'), 
 Book('دلائل الإعجاز','عبد القاهر الجرجاني','علوم اللغة العربية','مصنف أصيل في علم المعاني وأسرار النظم والإعجاز البياني.'), 
 Book('أسرار البلاغة','عبد القاهر الجرجاني','علوم اللغة العربية','بحث تراثي في البيان والتشبيه والاستعارة ووجوه التصوير.'), 
 Book('مغني اللبيب عن كتب الأعاريب','ابن هشام الأنصاري','علوم اللغة العربية','مرجع نحوي في الحروف والأدوات والتراكيب والإعراب.'), 
 Book('قطر الندى وبل الصدى','ابن هشام الأنصاري','علوم اللغة العربية','متن مختصر في أبواب النحو مع شرح لمسائلها.')
 Book('صحيح ابن خزيمة','الإمام محمد بن إسحاق ابن خزيمة','الحديث الشريف','مصنف حديثي مرتب على أبواب الفقه، وتحتاج أحاديثه إلى مراجعة أحكامها بحسب الطبعات والتحقيقات.'),
 Book('صحيح ابن حبان','الإمام محمد بن حبان البستي','الحديث الشريف','مصنف حديثي مشهور رتبه ابن حبان على تقسيمات كتابه، وله طبعات وشروح متعددة.'),
 Book('المستدرك على الصحيحين','الإمام محمد بن عبد الله الحاكم النيسابوري','الحديث الشريف','كتاب حديثي جمع فيه الحاكم أحاديث قال إنها على شرط الصحيحين أو أحدهما، وتعقبه أئمة في أحكامه.'),
 Book('السنن الكبرى','الإمام أحمد بن الحسين البيهقي','الحديث الشريف','مصنف واسع في أحاديث الأحكام والآثار، مع عناية بالفقه والاستدلال.'),
 Book('معرفة السنن والآثار','الإمام أحمد بن الحسين البيهقي','الحديث الشريف','كتاب في الرواية والفقه والاستدلال، يعرض الأحاديث والآثار المتعلقة بالأحكام.'),
 Book('شرح السنة','الإمام الحسين بن مسعود البغوي','الحديث والآداب','كتاب يجمع أحاديث الاعتقاد والعبادات والآداب مع شرحها.'),
 Book('الشريعة','الإمام محمد بن الحسين الآجري','العقيدة والتوحيد','مصنف في مسائل الاعتقاد والاتباع والآثار المروية عن السلف.'),
 Book('السنة','عبد الله بن أحمد بن حنبل','العقيدة والتوحيد','روايات وآثار في مسائل الاعتقاد والردود، ضمن المرويات المنسوبة إلى رواية عبد الله عن أبيه وغيره.'),
 Book('الإبانة الكبرى','الإمام عبيد الله بن محمد ابن بطة','العقيدة والتوحيد','مصنف تراثي في مسائل الاعتقاد والاتباع والآثار.'),
 Book('الإيمان','الإمام أبو بكر ابن أبي شيبة','العقيدة والتوحيد','آثار وروايات في مسائل الإيمان وأقوال السلف.'),
 Book('كتاب السنة','الإمام أبو بكر الخلال','العقيدة والتوحيد','جمع للروايات والآثار عن الإمام أحمد وأصحابه في مسائل السنة والاعتقاد.'),
 Book('المغني','الإمام موفق الدين ابن قدامة','الفقه والحديث','مرجع فقهي حنبلي موسع يعرض المسائل وأدلتها وأقوال الفقهاء.'),
 Book('الكافي في فقه الإمام أحمد','الإمام موفق الدين ابن قدامة','الفقه والحديث','كتاب فقهي مرتب على أبواب العبادات والمعاملات في المذهب الحنبلي.'),
 Book('عمدة الفقه','الإمام موفق الدين ابن قدامة','الفقه والحديث','متن فقهي مختصر في أبواب العبادات والمعاملات.'),
 Book('روضة الناظر وجنة المناظر','الإمام موفق الدين ابن قدامة','أصول الفقه','مصنف في أصول الفقه وقواعد الاستدلال.'),
 Book('المجموع شرح المهذب','الإمام يحيى بن شرف النووي','الفقه والحديث','شرح فقهي مقارن على المهذب، وقد أكمل أجزاء منه علماء بعد النووي.'),
 Book('شرح صحيح مسلم','الإمام يحيى بن شرف النووي','الحديث الشريف','شرح مشهور لصحيح مسلم يجمع بيان الحديث واللغة والفقه.'),
 Book('فتح الباري شرح صحيح البخاري','الحافظ أحمد بن علي ابن حجر العسقلاني','الحديث الشريف','من أشهر شروح صحيح البخاري، مع تحريرات حديثية وفقهية ولغوية.'),
 Book('عمدة القاري شرح صحيح البخاري','الإمام بدر الدين العيني','الحديث الشريف','شرح موسع لصحيح البخاري في الحديث واللغة والفقه.'),
 Book('إرشاد الساري لشرح صحيح البخاري','الإمام أحمد بن محمد القسطلاني','الحديث الشريف','شرح لصحيح البخاري يجمع شرح الألفاظ والمسائل والفوائد.'),
 Book('عون المعبود شرح سنن أبي داود','الإمام شمس الحق العظيم آبادي','الحديث الشريف','شرح لسنن أبي داود مع عناية بطرق الحديث وألفاظه وفقهه.'),
 Book('تحفة الأحوذي شرح جامع الترمذي','الشيخ محمد عبد الرحمن المباركفوري','الحديث الشريف','شرح لجامع الترمذي يتناول الروايات وأحكام الحديث والمسائل الفقهية.'),
 Book('نيل الأوطار شرح منتقى الأخبار','الإمام محمد بن علي الشوكاني','الفقه والحديث','كتاب في شرح أحاديث الأحكام وبيان وجوه الاستدلال والخلاف الفقهي.'),
 Book('سبل السلام شرح بلوغ المرام','الإمام محمد بن إسماعيل الصنعاني','الفقه والحديث','شرح لأحاديث الأحكام الواردة في بلوغ المرام.'),
 Book('بداية المجتهد ونهاية المقتصد','الإمام محمد بن أحمد ابن رشد','الفقه والحديث','كتاب فقهي مقارن يوضح أسباب اختلاف الفقهاء وأدلتهم.'),
 Book('المحلى بالآثار','الإمام علي بن أحمد ابن حزم','الفقه والحديث','مصنف فقهي استدلالي يعرض المسائل والأقوال والآثار.'),
 Book('بدائع الصنائع في ترتيب الشرائع','الإمام علاء الدين الكاساني','الفقه والحديث','مرجع فقهي حنفي مرتب على أبواب العبادات والمعاملات.'),
 Book('الإنصاف في معرفة الراجح من الخلاف','الإمام علاء الدين المرداوي','الفقه والحديث','كتاب في تحرير الروايات والأقوال والترجيحات في المذهب الحنبلي.'),
 Book('الأشباه والنظائر','الإمام جلال الدين السيوطي','أصول الفقه','مصنف في القواعد الفقهية والنظائر والفروق.'),
 Book('الموافقات','الإمام إبراهيم بن موسى الشاطبي','أصول الفقه','كتاب في مقاصد الشريعة وأصولها وقواعد الاجتهاد.'),
 Book('الورقات','الإمام عبد الملك الجويني','أصول الفقه','متن مختصر مشهور في مبادئ أصول الفقه.'),
 Book('شرح الكوكب المنير','الإمام محمد بن أحمد الفتوحي ابن النجار','أصول الفقه','شرح موسع في أصول الفقه وقواعده ومباحثه.'),
 Book('جامع البيان عن تأويل آي القرآن','الإمام محمد بن جرير الطبري','القرآن وعلومه','تفسير بالمأثور يعرض الروايات وأقوال أهل العلم في تفسير الآيات.'),
 Book('الجامع لأحكام القرآن','الإمام محمد بن أحمد القرطبي','القرآن وعلومه','تفسير يعتني بالأحكام الفقهية واللغة والقراءات وأقوال المفسرين.'),
 Book('أضواء البيان في إيضاح القرآن بالقرآن','الشيخ محمد الأمين الشنقيطي','القرآن وعلومه','تفسير يعتني ببيان القرآن بالقرآن مع مباحث أصولية وفقهية.'),
 Book('تيسير الكريم الرحمن','الشيخ عبد الرحمن بن ناصر السعدي','القرآن وعلومه','تفسير ميسر العبارة، وهو موجود في الفهرس أيضاً باسم تفسير السعدي.'),
 Book('مقدمة ابن الصلاح في علوم الحديث','الإمام عثمان بن عبد الرحمن ابن الصلاح','الحديث والآداب','أصل مهم في مباحث علوم الحديث ومصطلحه.'),
 Book('تدريب الراوي في شرح تقريب النواوي','الإمام جلال الدين السيوطي','الحديث والآداب','شرح في مصطلح الحديث ومباحث الرواية والدراية.'),
 Book('ألفية العراقي','الحافظ عبد الرحيم العراقي','الحديث والآداب','منظومة في علوم الحديث، اشتهرت بشروحها وحواشيها.'),
 Book('تقريب التهذيب','الحافظ أحمد بن علي ابن حجر العسقلاني','الحديث والآداب','مختصر في تراجم رواة الكتب الستة ومراتبهم.'),
 Book('تهذيب الكمال في أسماء الرجال','الإمام جمال الدين المزي','الحديث والآداب','مرجع موسع في تراجم رواة الكتب الستة.'),
 Book('ميزان الاعتدال في نقد الرجال','الإمام شمس الدين الذهبي','الحديث والآداب','مصنف في نقد الرواة وبيان أحوالهم.'),
 Book('تذكرة الحفاظ','الإمام شمس الدين الذهبي','التاريخ والتراجم','تراجم لأئمة الحفظ والحديث عبر القرون.'),
 Book('الاستيعاب في معرفة الأصحاب','الإمام يوسف بن عبد الله ابن عبد البر','السيرة والشمائل','كتاب في تراجم الصحابة وذكر أخبارهم.'),
 Book('الإصابة في تمييز الصحابة','الحافظ أحمد بن علي ابن حجر العسقلاني','السيرة والشمائل','مرجع موسع في تراجم الصحابة وتمييز أسمائهم وأخبارهم.'),
 Book('أسد الغابة في معرفة الصحابة','الإمام علي بن محمد ابن الأثير','السيرة والشمائل','كتاب في تراجم الصحابة وجمع أخبارهم.'),
 Book('الطبقات الكبرى','الإمام محمد بن سعد كاتب الواقدي','التاريخ والتراجم','مصنف تراجم وتاريخ يذكر طبقات الصحابة والتابعين ومن بعدهم.'),
 Book('تاريخ بغداد','الإمام أحمد بن علي الخطيب البغدادي','التاريخ والتراجم','كتاب تراجم وتاريخ لعلماء بغداد ورجالها.'),
 Book('تاريخ دمشق','الإمام علي بن الحسن ابن عساكر','التاريخ والتراجم','مصنف تاريخي وتراجمي واسع عن دمشق وأعلامها.'),
 Book('الكامل في التاريخ','الإمام علي بن محمد ابن الأثير','التاريخ والتراجم','كتاب تاريخ عام لأحداث وأخبار الأمم والدول.'),
 Book('إغاثة اللهفان من مصايد الشيطان','الإمام ابن قيم الجوزية','الأذكار والرقائق','كتاب في أمراض القلوب ووساوس الشيطان وطرق الوقاية منها.'),
 Book('عدة الصابرين وذخيرة الشاكرين','الإمام ابن قيم الجوزية','الأذكار والرقائق','مصنف في الصبر والشكر وفضائلهما وآثارهما.'),
 Book('طريق الهجرتين وباب السعادتين','الإمام ابن قيم الجوزية','الأذكار والرقائق','كتاب في السير إلى الله ومنازل العبودية وأعمال القلوب.'),
 Book('مفتاح دار السعادة','الإمام ابن قيم الجوزية','الأذكار والرقائق','مصنف في العلم وفضله وأسبابه وآثاره.'),
 Book('الآجرومية','الإمام محمد بن محمد ابن آجروم','علوم اللغة العربية','متن موجز مشهور في مبادئ النحو العربي.'),
 Book('ألفية ابن مالك','الإمام محمد بن عبد الله ابن مالك','علوم اللغة العربية','منظومة جامعة في النحو والصرف، اشتهرت بكثرة شروحها.'),
 Book('شرح المفصل','الإمام يعيش بن علي ابن يعيش','علوم اللغة العربية','شرح تراثي موسع لأبواب النحو والتصريف.'),
 Book('الخصائص','الإمام أبو الفتح عثمان ابن جني','علوم اللغة العربية','مصنف في أصول اللغة وخصائص العربية ومسائلها.'),
 Book('الصاحبي في فقه اللغة','الإمام أحمد بن فارس','علوم اللغة العربية','كتاب في فقه اللغة العربية وأصولها وخصائصها.'),
];

// إزالة التكرار من الفهرس مع الحفاظ على ترتيب ظهور الكتب.
final catalogBooks = books.fold<List<Book>>([], (items, book) {
 if (!items.any((item) => item.title == book.title && item.author == book.author)) {
  items.add(book);
 }
 return items;
});

String normalizeArabic(String value) => value
 .toLowerCase()
 .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'),'')
 .replaceAll('ـ','')
 .replaceAll('أ','ا')
 .replaceAll('إ','ا')
 .replaceAll('آ','ا')
 .replaceAll('ى','ي');

class Book { final String title,author,category,summary; const Book(this.title,this.author,this.category,this.summary); }
const categories=['القرآن وعلومه','الحديث الشريف','العقيدة والتوحيد','الفقه والحديث','السيرة والشمائل','أصول الفقه','الحديث والآداب','الأذكار والرقائق','علوم اللغة العربية','كتب أهل السنة والجماعة','التاريخ والتراجم','المسلمون الجدد','قسم الأطفال'];

Future<void> main() async { WidgetsFlutterBinding.ensureInitialized(); final p=await SharedPreferences.getInstance(); runApp(NoorApp(firstRun:!(p.getBool('seen_intro')??false))); }
class NoorApp extends StatelessWidget { final bool firstRun; const NoorApp({super.key,required this.firstRun}); @override Widget build(BuildContext c)=>MaterialApp(title:'نور الهدى',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:paper,colorScheme:ColorScheme.fromSeed(seedColor:green,primary:green,secondary:gold),appBarTheme:const AppBarTheme(backgroundColor:green,foregroundColor:Colors.white,centerTitle:true)),home:LaunchPage(firstRun:firstRun)); }

class LaunchPage extends StatelessWidget {
 final bool firstRun;
 const LaunchPage({super.key,required this.firstRun});
 void continueToApp(BuildContext c) {
  Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>firstRun?const WelcomePage():const HomePage()));
 }
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:Container(width:double.infinity,decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF1D5A46),Color(0xFF09271F)])),child:SafeArea(child:Padding(padding:const EdgeInsets.symmetric(horizontal:25,vertical:30),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
  const Icon(Icons.auto_awesome,color:gold,size:38),
  const SizedBox(height:20),
  const Text('نُورُ الهُدَى',style:TextStyle(color:Colors.white,fontSize:38,fontWeight:FontWeight.bold)),
  const Text('الموسوعة الإسلامية',style:TextStyle(color:Color(0xFFE9D9B5),fontSize:17)),
  const SizedBox(height:34),
  Container(width:double.infinity,padding:const EdgeInsets.symmetric(horizontal:20,vertical:30),decoration:BoxDecoration(color:const Color(0x22FFFFFF),borderRadius:BorderRadius.circular(22),border:Border.all(color:gold,width:1.4)),child:const Column(children:[
   Text('﴿ وَقُلْ رَبِّ زِدْنِي عِلْمًا ﴾',textAlign:TextAlign.center,style:TextStyle(color:gold,fontSize:29,fontWeight:FontWeight.bold,height:2)),
  ])),
  const SizedBox(height:32),
  FilledButton(onPressed:()=>continueToApp(c),style:FilledButton.styleFrom(backgroundColor:gold,foregroundColor:green,minimumSize:const Size(double.infinity,54),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),child:Text(firstRun?'متابعة إلى الترحيب':'دخول الموسوعة',style:const TextStyle(fontSize:17,fontWeight:FontWeight.bold))),
 ]))))));
}

class WelcomePage extends StatelessWidget {
 const WelcomePage({super.key});
 Future<void> enter(BuildContext c) async { final p=await SharedPreferences.getInstance(); await p.setBool('seen_intro',true); if(!c.mounted)return; Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const HomePage())); }
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(body:Container(width:double.infinity,decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[Color(0xFF1D5A46),Color(0xFF09271F)])),child:SafeArea(child:Padding(padding:const EdgeInsets.all(25),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
 const Icon(Icons.menu_book_rounded,color:gold,size:78),const SizedBox(height:20),const Text('بِسْمِ اللهِ الرَّحْمَٰنِ الرَّحِيمِ',style:TextStyle(color:gold,fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:16),const Text('نُورُ الهُدَى',style:TextStyle(color:Colors.white,fontSize:40,fontWeight:FontWeight.bold)),const Text('الموسوعة الإسلامية',style:TextStyle(color:Color(0xFFE9D9B5),fontSize:18)),const SizedBox(height:28),const Divider(color:gold),const SizedBox(height:18),const Text('الحمد لله رب العالمين، والصلاة والسلام على نبينا محمد وعلى آله وصحبه أجمعين.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,height:2,fontSize:17)),const SizedBox(height:14),const Text('اللهم حُطَّ عني بهذا العمل خطيئةً، وارفعني به درجةً، ولوالديَّ، ولجميع المسلمين والمسلمات، الأحياء منهم والأموات.',textAlign:TextAlign.center,style:TextStyle(color:paper,height:2,fontSize:17,fontWeight:FontWeight.w500)),const SizedBox(height:28),FilledButton(onPressed:()=>enter(c),style:FilledButton.styleFrom(backgroundColor:gold,foregroundColor:green,minimumSize:const Size(double.infinity,54)),child:const Text('ابدأ رحلتك في طلب العلم')),
 ]))))));
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomeState(); }
class _HomeState extends State<HomePage> {
 String query=''; int tab=0; Set<String> saved={};
 @override void initState(){super.initState();load();}
 Future<void> load() async {final p=await SharedPreferences.getInstance();if(mounted)setState(()=>saved=(p.getStringList('saved_books')??[]).toSet());}
 Future<void> toggle(Book b) async {setState((){if(saved.contains(b.title)){saved.remove(b.title);}else{saved.add(b.title);}});final p=await SharedPreferences.getInstance();await p.setStringList('saved_books',saved.toList());}
 @override Widget build(BuildContext c){
 final normalizedQuery=normalizeArabic(query.trim()); final matches=catalogBooks.where((b)=>normalizeArabic(b.title+' '+b.author+' '+b.category+' '+b.summary).contains(normalizedQuery)).toList();
 return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Column(children:[Text('نور الهدى',style:TextStyle(fontWeight:FontWeight.bold)),Text('الموسوعة الإسلامية',style:TextStyle(fontSize:11,color:Color(0xFFE8D9B7)))])),
 drawer:Drawer(child:Column(children:[Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(20,55,20,25),color:green,child:const Column(children:[Icon(Icons.menu_book,color:gold,size:45),Text('نور الهدى',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold))])),ListTile(leading:const Icon(Icons.home),title:const Text('الرئيسية'),onTap:(){Navigator.pop(c);setState(()=>tab=0);}),ListTile(leading:const Icon(Icons.bookmark_outline),title:const Text('مكتبتي الخاصة'),onTap:(){Navigator.pop(c);setState(()=>tab=1);}),ListTile(leading:const Icon(Icons.person_outline),title:const Text('المسلمون الجدد'),onTap:(){Navigator.pop(c);setState(()=>tab=2);}),ListTile(leading:const Icon(Icons.child_care),title:const Text('قسم الأطفال'),onTap:(){Navigator.pop(c);setState(()=>tab=3);}),ListTile(leading:const Icon(Icons.collections_bookmark_outlined),title:const Text('كتب أهل السنة والجماعة'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>SunniBooksPage(saved:saved,onToggle:toggle)));}),ListTile(leading:const Icon(Icons.info_outline),title:const Text('حول الموسوعة ومصادرها'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>const InfoPage(title:'حول نور الهدى',body:'نور الهدى موسوعة إسلامية تهدف إلى تسهيل الوصول إلى فهارس الكتب والمواد العلمية الموثوقة.\n\nلا يُدرج نص كتاب كامل إلا بعد التحقق من مصدر النسخة وبيانات الطبعة والمحقق وحقوق إعادة التوزيع.\n\nقد تظهر بعض الكتب في الفهرس ببيانات تعريفية فقط إلى حين توفير نص رقمي موثوق ومسموح بإتاحته دون اتصال.\n\nنسأل الله أن يجعل هذا العمل خالصاً نافعاً.')));})])),
 body:tab==1?Favorites(saved:saved,onToggle:toggle):tab==2?const NewMuslimPage():tab==3?const ChildrenPage():ListView(padding:const EdgeInsets.all(16),children:[
 Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[green,Color(0xFF1D5A46)]),borderRadius:BorderRadius.circular(22),border:Border.all(color:gold)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',style:TextStyle(color:gold,fontSize:23,fontWeight:FontWeight.bold)),const SizedBox(height:7),const Text('بوابتك إلى مصادر العلم والتراث الإسلامي',style:TextStyle(color:Colors.white)),const SizedBox(height:15),TextField(onChanged:(v)=>setState(()=>query=v),decoration:InputDecoration(hintText:'ابحث عن كتاب أو مؤلف أو قسم...',prefixIcon:const Icon(Icons.search,color:green),filled:true,fillColor:paper,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none)))])),
 const SizedBox(height:20),const Heading('أقسام الموسوعة'),const SizedBox(height:10),
 GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:categories.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing:9,crossAxisSpacing:9,childAspectRatio:2.05),itemBuilder:(ctx,i)=>InkWell(onTap:()=>Navigator.push(ctx,MaterialPageRoute(builder:(_)=>CategoryPage(category:categories[i],saved:saved,onToggle:toggle))),child:Container(decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:const Color(0xFFDDCBA7))),child:Center(child:Text(categories[i],textAlign:TextAlign.center,style:const TextStyle(color:green,fontWeight:FontWeight.bold)))))),
 const SizedBox(height:20),Heading(query.isEmpty?'كتب مقترحة للفهرسة':'نتائج البحث'),
 if(matches.isEmpty)const Padding(padding:EdgeInsets.all(20),child:Text('لا توجد نتائج مطابقة.',textAlign:TextAlign.center))else ...matches.map((b)=>BookTile(book:b,saved:saved.contains(b.title),onSave:()=>toggle(b))),
 const SizedBox(height:10),const Text('تنبيه: هذه نسخة تأسيسية للفهرس والتصميم. النصوص الكاملة تحتاج إلى إدراج نسخ رقمية موثوقة ومراجعة بياناتها قبل إتاحتها.',style:TextStyle(color:Colors.brown,fontSize:12,height:1.7))
 ]),
 bottomNavigationBar:NavigationBar(selectedIndex:tab==1?1:0,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[NavigationDestination(icon:Icon(Icons.home_outlined),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.bookmark_outline),label:'مكتبتي')]),
 ));
 }
}
class Heading extends StatelessWidget {final String title;const Heading(this.title,{super.key});@override Widget build(BuildContext c)=>Row(children:[Container(width:4,height:22,color:gold),const SizedBox(width:9),Text(title,style:const TextStyle(color:green,fontSize:18,fontWeight:FontWeight.bold))]);}
class BookTile extends StatelessWidget {
 final Book book;final bool saved;final VoidCallback onSave;const BookTile({super.key,required this.book,required this.saved,required this.onSave});
 @override Widget build(BuildContext c)=>Card(color:Colors.white,elevation:0,margin:const EdgeInsets.symmetric(vertical:5),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14),side:const BorderSide(color:Color(0xFFDDCBA7))),child:ListTile(leading:Container(width:42,height:48,decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(8)),child:const Icon(Icons.menu_book,color:gold)),title:Text(book.title,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),subtitle:Text(book.author+'\n'+book.category,maxLines:2,overflow:TextOverflow.ellipsis),trailing:IconButton(onPressed:onSave,icon:Icon(saved?Icons.bookmark:Icons.bookmark_border,color:gold)),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>BookDetails(book:book,saved:saved,onSave:onSave)))));
}
class SunniBooksPage extends StatelessWidget {
 final Set<String> saved;
 final Future<void> Function(Book) onToggle;
 const SunniBooksPage({super.key,required this.saved,required this.onToggle});
 @override Widget build(BuildContext c) {
  final grouped=<String,List<Book>>{};
  final seenTitles=<String>{};
  for(final b in catalogBooks.where((b)=>b.category=='كتب أهل السنة والجماعة'||b.category!='قسم الأطفال'&&b.category!='المسلمون الجدد')) {
   if(seenTitles.add(b.title)) grouped.putIfAbsent(b.author,()=>[]).add(b);
  }
  const preferredAuthors=['الإمام محمد بن إدريس الشافعي','الإمام محمد بن إسماعيل البخاري','الإمام مالك بن أنس','الإمام أحمد بن حنبل','الإمام ابن قيم الجوزية','شيخ الإسلام ابن تيمية'];
  final authors=grouped.keys.toList()..sort((a,b){
   final ai=preferredAuthors.indexOf(a), bi=preferredAuthors.indexOf(b);
   if(ai>=0&&bi>=0)return ai.compareTo(bi);
   if(ai>=0)return -1;
   if(bi>=0)return 1;
   return a.compareTo(b);
  });
  return Directionality(textDirection:TextDirection.rtl,child:Scaffold(
   appBar:AppBar(title:const Text('كتب أهل السنة والجماعة')),
   body:ListView(padding:const EdgeInsets.all(12),children:[
    Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(16),border:Border.all(color:gold)),child:const Text('اختر اسم العالم لتظهر مؤلفاته وكتبه تحته',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize:16,fontWeight:FontWeight.bold))),
    const SizedBox(height:12),
    ...authors.map((author)=>Card(color:Colors.white,elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14),side:const BorderSide(color:Color(0xFFDDCBA7))),child:ExpansionTile(leading:const Icon(Icons.account_balance,color:gold),title:Text(author,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),children:grouped[author]!.map((b)=>BookTile(book:b,saved:saved.contains(b.title),onSave:()=>onToggle(b))).toList()))),
    const SizedBox(height:12),
    const Text('تنبيه: ترتيب الكتب بحسب المؤلف أو الراوي كما هو مثبت في بيانات الفهرس، وبعض المصنفات روايات أو جمعٌ عن العالم وليست كلها تأليفًا مباشرًا له.',style:TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
   ]),
  ));
 }
}
class CategoryPage extends StatelessWidget {
 final String category;final Set<String> saved;final Future<void> Function(Book) onToggle;const CategoryPage({super.key,required this.category,required this.saved,required this.onToggle});
 @override Widget build(BuildContext c){final list=category=='كتب أهل السنة والجماعة'?books.toList():catalogBooks.where((b)=>b.category==category||(category=='الحديث الشريف'&&b.category=='الحديث والآداب')).toList();return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(category)),body:list.isEmpty?const Center(child:Text('سيضاف فهرس هذا القسم بعد مراجعة مصادره.')):ListView(padding:const EdgeInsets.all(12),children:list.map((b)=>BookTile(book:b,saved:saved.contains(b.title),onSave:()=>onToggle(b))).toList())));}
}
class BookDetails extends StatefulWidget {
 final Book book;
 final bool saved;
 final VoidCallback onSave;
 const BookDetails({super.key,required this.book,required this.saved,required this.onSave});
 @override State<BookDetails> createState()=>_BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
 final TextEditingController noteController=TextEditingController();
 double fontSize=17;
 bool noteLoaded=false;
 bool noteSaving=false;
 @override void initState(){super.initState();loadNote();}
 Future<void> loadNote() async {
  final p=await SharedPreferences.getInstance();
  final value=p.getString('note_${widget.book.title}')??'';
  if(!mounted)return;
  noteController.text=value;
  setState(()=>noteLoaded=true);
 }
 Future<void> saveNote() async {
  setState(()=>noteSaving=true);
  final p=await SharedPreferences.getInstance();
  await p.setString('note_${widget.book.title}',noteController.text);
  if(!mounted)return;
  setState(()=>noteSaving=false);
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('حُفظت ملاحظتك على هذا الجهاز.')));
 }
 @override void dispose(){noteController.dispose();super.dispose();}
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
  appBar:AppBar(title:const Text('بيانات الكتاب')),
  body:ListView(padding:const EdgeInsets.all(18),children:[
   Container(height:142,decoration:BoxDecoration(gradient:const LinearGradient(colors:[green,Color(0xFF1D5A46)]),borderRadius:BorderRadius.circular(18),border:Border.all(color:gold)),child:const Icon(Icons.menu_book,color:gold,size:74)),
   const SizedBox(height:18),
   Text(widget.book.title,textAlign:TextAlign.center,style:const TextStyle(color:green,fontSize:25,fontWeight:FontWeight.bold)),
   const SizedBox(height:8),
   Text(widget.book.author,textAlign:TextAlign.center,style:const TextStyle(fontSize:15)),
   const SizedBox(height:18),
   const Heading('بيانات الفهرس'),
   const SizedBox(height:8),
   _BookMetaRow(label:'القسم',value:widget.book.category),
   _BookMetaRow(label:'المؤلف أو صاحب الرواية',value:widget.book.author),
   const SizedBox(height:14),
   const Heading('نبذة تعريفية'),
   const SizedBox(height:8),
   Row(children:[
    const Text('حجم الخط'),
    Expanded(child:Slider(min:14,max:26,divisions:6,value:fontSize,onChanged:(v)=>setState(()=>fontSize=v))),
    Text(fontSize.round().toString()),
   ]),
   SelectableText(widget.book.summary,style:TextStyle(fontSize:fontSize,height:2.0,color:Colors.black87)),
   const SizedBox(height:18),
   FilledButton.icon(onPressed:widget.onSave,icon:Icon(widget.saved?Icons.bookmark:Icons.bookmark_add_outlined),label:Text(widget.saved?'إزالة من مكتبتي':'أضف إلى مكتبتي')),
   const SizedBox(height:18),
   FilledButton.icon(onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>OfflineReaderPage(book:widget.book))),icon:const Icon(Icons.chrome_reader_mode_outlined),label:const Text('فتح قارئ الكتاب'),style:FilledButton.styleFrom(minimumSize:const Size(double.infinity,50))),
   const SizedBox(height:18),
   const Heading('ملاحظاتي الخاصة'),
   const SizedBox(height:8),
   TextField(controller:noteController,minLines:3,maxLines:7,decoration:InputDecoration(hintText:'اكتب فوائدك أو ملاحظاتك حول هذا الكتاب...',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
   const SizedBox(height:8),
   FilledButton.tonalIcon(onPressed:!noteLoaded||noteSaving?null:saveNote,icon:const Icon(Icons.save_outlined),label:Text(noteSaving?'جارٍ الحفظ...':'احفظ ملاحظاتي على الجهاز')),
   const SizedBox(height:18),
   if(widget.book.title=='القرآن الكريم') Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFFFF4DD),borderRadius:BorderRadius.circular(12),border:Border.all(color:gold)),child:const Text('النص القرآني الكامل متاح داخل التطبيق دون إنترنت، منقول حرفياً عن مشروع تنزيل بالرسم العثماني، مع حفظ إشعار المصدر والترخيص.',style:TextStyle(color:green,height:1.9))) else Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFFFF4DD),borderRadius:BorderRadius.circular(12),border:Border.all(color:gold)),child:const Text('تنبيه علمي: هذه الصفحة تعرض بيانات الفهرس والنبذة فقط. النص الكامل لهذا الكتاب غير مرفق بعد. لن ننسب نصوصاً إلى مؤلفيها قبل التحقق من النسخة والطبعة والمصدر وحقوق الإتاحة.',style:TextStyle(color:Colors.brown,height:1.9))),
  ]),
 ));
}

class OfflineReaderPage extends StatefulWidget {
 final Book book;
 const OfflineReaderPage({super.key,required this.book});
 @override State<OfflineReaderPage> createState()=>_OfflineReaderPageState();
}
class _OfflineReaderPageState extends State<OfflineReaderPage> {
 Map<String,dynamic>? record;
 bool loading=true;
 String? error;
 double fontSize=19;
 String searchQuery='';
 final TextEditingController searchController=TextEditingController();
 final ScrollController readerScrollController=ScrollController();
 double lastSavedPosition=0;
 String get _fontKey=>'reader_font_${widget.book.title}';
 String get _positionKey=>'reader_position_${widget.book.title}';
 @override void initState(){super.initState();readerScrollController.addListener(_saveReadingPosition);loadBook();}
 @override void dispose(){readerScrollController.removeListener(_saveReadingPosition);searchController.dispose();readerScrollController.dispose();super.dispose();}
 Future<void> _saveReadingPosition() async {
  if(!readerScrollController.hasClients)return;
  final position=readerScrollController.position.pixels;
  if((position-lastSavedPosition).abs()<250)return;
  lastSavedPosition=position;
  final prefs=await SharedPreferences.getInstance();
  await prefs.setDouble(_positionKey,position);
 }
 Future<void> _saveFontSize(double value) async {
  setState(()=>fontSize=value);
  final prefs=await SharedPreferences.getInstance();
  await prefs.setDouble(_fontKey,value);
 }
 static const _splitBookAssets=<String,List<String>>{
  'صحيح البخاري':[
   'assets/books/sahih_bukhari_01.json','assets/books/sahih_bukhari_02.json','assets/books/sahih_bukhari_03.json',
   'assets/books/sahih_bukhari_04.json','assets/books/sahih_bukhari_05.json','assets/books/sahih_bukhari_06.json',
  ],
  'صحيح مسلم':[
   'assets/books/sahih_muslim_01.json','assets/books/sahih_muslim_02.json','assets/books/sahih_muslim_03.json',
   'assets/books/sahih_muslim_04.json','assets/books/sahih_muslim_05.json','assets/books/sahih_muslim_06.json',
  ],
  'سنن أبي داود':[
   'assets/books/sunan_abi_dawud_01.json','assets/books/sunan_abi_dawud_02.json','assets/books/sunan_abi_dawud_03.json',
   'assets/books/sunan_abi_dawud_04.json','assets/books/sunan_abi_dawud_05.json','assets/books/sunan_abi_dawud_06.json',
  ],
  'جامع الترمذي':[
   'assets/books/jami_tirmidhi_01.json','assets/books/jami_tirmidhi_02.json','assets/books/jami_tirmidhi_03.json',
   'assets/books/jami_tirmidhi_04.json','assets/books/jami_tirmidhi_05.json','assets/books/jami_tirmidhi_06.json',
  ],
  'سنن النسائي':[
   'assets/books/sunan_nasai_01.json','assets/books/sunan_nasai_02.json','assets/books/sunan_nasai_03.json',
   'assets/books/sunan_nasai_04.json','assets/books/sunan_nasai_05.json','assets/books/sunan_nasai_06.json',
  ],
  'سنن ابن ماجه':[
   'assets/books/sunan_ibn_majah_01.json',
   'assets/books/sunan_ibn_majah_02.json',
   'assets/books/sunan_ibn_majah_03.json',
   'assets/books/sunan_ibn_majah_04.json',
   'assets/books/sunan_ibn_majah_05.json'
  ],
 };
 static final Map<String,Future<Map<String,dynamic>>> _bookCache={};
 Future<Map<String,dynamic>> _loadBookRecord() => _bookCache.putIfAbsent(widget.book.title,() async {
  final paths=_splitBookAssets[widget.book.title];
  if(paths!=null){
   final raws=await Future.wait(paths.map((path)=>rootBundle.loadString(path)));
   final records=raws.map((raw){
    final decoded=jsonDecode(raw) as Map<String,dynamic>;
    final all=decoded['books'] as Map<String,dynamic>;
    return Map<String,dynamic>.from(all[widget.book.title] as Map);
   }).toList();
   final combined=Map<String,dynamic>.from(records.first);
   combined['chapters']=records.expand((item)=>(item['chapters'] as List<dynamic>? ?? [])).toList();
   return combined;
  }
  final raw=await rootBundle.loadString('assets/books/library.json');
  final decoded=jsonDecode(raw) as Map<String,dynamic>;
  final all=decoded['books'] as Map<String,dynamic>? ?? {};
  final item=all[widget.book.title];
  return item is Map?Map<String,dynamic>.from(item):<String,dynamic>{};
 });
 Future<void> loadBook() async {
  try {
   final item=await _loadBookRecord();
   final prefs=await SharedPreferences.getInstance();
   final savedFont=prefs.getDouble(_fontKey);
   final savedPosition=prefs.getDouble(_positionKey)??0;
   if(!mounted)return;
   setState((){
    record=item.isEmpty?null:item;
    if(savedFont!=null)fontSize=savedFont.clamp(15.0,30.0).toDouble();
    loading=false;
   });
   if(item.isNotEmpty && savedPosition>0){
    WidgetsBinding.instance.addPostFrameCallback((_){
     if(!mounted||!readerScrollController.hasClients)return;
     final max=readerScrollController.position.maxScrollExtent;
     final restored=savedPosition.clamp(0.0,max).toDouble();
     readerScrollController.jumpTo(restored);
     lastSavedPosition=restored;
    });
   }
  } catch (_) {
   if(!mounted)return;
   setState((){loading=false;error='تعذر تحميل فهرس المحتوى المحلي.';});
  }
 }
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
  appBar:AppBar(title:const Text('قارئ الكتب')),
  body:loading?const Center(child:CircularProgressIndicator()):error!=null
   ?Center(child:Padding(padding:const EdgeInsets.all(24),child:Text(error!,textAlign:TextAlign.center)))
   :record==null?_emptyState():_readerContent(),
 ));
 Widget _emptyState()=>ListView(padding:const EdgeInsets.all(22),children:[
  const SizedBox(height:24),const Icon(Icons.menu_book_outlined,color:gold,size:68),const SizedBox(height:18),
  Text(widget.book.title,textAlign:TextAlign.center,style:const TextStyle(color:green,fontSize:24,fontWeight:FontWeight.bold)),
  const SizedBox(height:10),Text(widget.book.author,textAlign:TextAlign.center),const SizedBox(height:24),
  Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFFFFF4DD),borderRadius:BorderRadius.circular(14),border:Border.all(color:gold)),child:const Column(children:[
   Icon(Icons.library_books_outlined,color:green,size:32),SizedBox(height:10),
   Text('النص الكامل لهذا الكتاب غير متاح داخل النسخة الحالية',textAlign:TextAlign.center,style:TextStyle(fontWeight:FontWeight.bold,color:green,fontSize:17)),
   SizedBox(height:8),
   Text('أُعدّ القارئ للعمل دون إنترنت، وسيظهر النص هنا بعد إضافة نسخة موثوقة موثقة المصدر والطبعة ومسموح بإعادة توزيعها. لم نضع نصاً تجريبياً أو منسوباً للمؤلف بغير تحقق.',textAlign:TextAlign.center,style:TextStyle(height:1.9)),
  ])),
 ]);
 Widget _readerContent(){
  final chapters=(record!['chapters'] as List<dynamic>? ?? []).where((chapter)=>chapter is Map).map((chapter)=>Map<String,dynamic>.from(chapter as Map)).toList();
  final source=record!['source']?.toString() ?? '';
  final edition=record!['edition']?.toString() ?? '';
  final normalized=normalizeArabic(searchQuery.trim());
  final visibleChapters=chapters.where((chapter)=>normalized.isEmpty||normalizeArabic((chapter['title']??'').toString()+' '+(chapter['text']??'').toString()).contains(normalized)).toList();
  return ListView(controller:readerScrollController,padding:const EdgeInsets.all(16),children:[
   Text(widget.book.title,textAlign:TextAlign.center,style:const TextStyle(color:green,fontSize:24,fontWeight:FontWeight.bold)),
   const SizedBox(height:6),Text(widget.book.author,textAlign:TextAlign.center),
   if(source.isNotEmpty||edition.isNotEmpty)...[
    const SizedBox(height:14),Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12),border:Border.all(color:gold)),child:Text('المصدر: $source\nالطبعة: $edition',style:const TextStyle(height:1.8))),
   ],
   const SizedBox(height:14),
   TextField(controller:searchController,onChanged:(value)=>setState(()=>searchQuery=value),decoration:InputDecoration(hintText:'ابحث داخل فصول الكتاب...',prefixIcon:const Icon(Icons.search,color:green),suffixIcon:searchQuery.isEmpty?null:IconButton(onPressed:(){searchController.clear();setState(()=>searchQuery='');},icon:const Icon(Icons.close)),filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
   const SizedBox(height:8),
   Row(children:[const Text('حجم الخط'),Expanded(child:Slider(min:15,max:30,divisions:10,value:fontSize,onChanged:_saveFontSize)),Text(fontSize.round().toString())]),
   if(chapters.isEmpty)const Padding(padding:EdgeInsets.all(20),child:Text('لا توجد فصول مضافة لهذا الكتاب بعد.',textAlign:TextAlign.center))
   else if(visibleChapters.isEmpty)const Padding(padding:EdgeInsets.all(20),child:Text('لا توجد فصول أو مقاطع تطابق عبارة البحث.',textAlign:TextAlign.center))
   else ...visibleChapters.map((item)=>Card(color:Colors.white,child:ExpansionTile(title:Text(item['title']?.toString()??'فصل',style:const TextStyle(color:green,fontWeight:FontWeight.bold)),children:[Padding(padding:const EdgeInsets.all(16),child:SelectableText(item['text']?.toString()??'',style:TextStyle(fontSize:fontSize,height:2.0)))]))),
   if(record!['review_note']!=null)Padding(padding:const EdgeInsets.only(top:12),child:Text(record!['review_note'].toString(),style:const TextStyle(color:Colors.brown,height:1.8,fontSize:12))),
  ]);
 }
}
class _BookMetaRow extends StatelessWidget {
 final String label,value;
 const _BookMetaRow({required this.label,required this.value});
 @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
  SizedBox(width:125,child:Text(label,style:const TextStyle(color:green,fontWeight:FontWeight.bold))),
  Expanded(child:Text(value,style:const TextStyle(height:1.6))),
 ]));
}

class Favorites extends StatelessWidget {final Set<String> saved;final Future<void> Function(Book) onToggle;const Favorites({super.key,required this.saved,required this.onToggle});@override Widget build(BuildContext c){final list=catalogBooks.where((b)=>saved.contains(b.title)).toList();return list.isEmpty?const Center(child:Text('لم تضف كتباً إلى مكتبتك بعد.')):ListView(padding:const EdgeInsets.all(12),children:list.map((b)=>BookTile(book:b,saved:true,onSave:()=>onToggle(b))).toList());}}
class InfoPage extends StatelessWidget {final String title,body;const InfoPage({super.key,required this.title,required this.body});@override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(title)),body:Padding(padding:const EdgeInsets.all(22),child:Text(body,style:const TextStyle(fontSize:17,height:2)))));}

class NewMuslimPage extends StatelessWidget {
 const NewMuslimPage({super.key});
 static const lessons = <String, String>{
  'معنى الشهادتين':'التعرّف إلى معنى لا إله إلا الله وأن محمداً رسول الله، وما تدلان عليه من إفراد الله بالعبادة واتباع الرسول صلى الله عليه وسلم.',
  'أركان الإسلام':'الشهادتان، وإقامة الصلاة، وإيتاء الزكاة، وصوم رمضان، وحج البيت لمن استطاع إليه سبيلاً.',
  'الطهارة والوضوء':'مقدمة مبسطة عن الطهارة، ثم تعلم صفة الوضوء خطوة خطوة.',
  'تعلم الصلاة':'التعرف إلى أوقات الصلاة وشروطها وأركانها، ثم تطبيق عملي متدرج.',
  'قصار السور':'بدء التعلم بسور قصيرة مع الاستماع إلى تلاوة صحيحة وتصحيح النطق.',
 };
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:ListView(padding:const EdgeInsets.all(16),children:[
  const Heading('مرحباً بك في طريق العلم'),
  const SizedBox(height:8),
  const Text('دروس مرتبة للمسلم الجديد، بلغة سهلة وخطوات متدرجة. ستراجع المواد علمياً قبل نشر الدروس التفصيلية.',style:TextStyle(height:1.9)),
  const SizedBox(height:12),
  ...lessons.entries.map((e)=>Card(child:ExpansionTile(leading:const Icon(Icons.menu_book,color:gold),title:Text(e.key,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),children:[Padding(padding:const EdgeInsets.all(16),child:Text(e.value,style:const TextStyle(height:1.9)))]))),
 ]));
}

class ChildrenPage extends StatelessWidget {
 const ChildrenPage({super.key});
 static const activities = <String, List<String>>{
  'تعلم الوضوء':['غسل الكفين','المضمضة والاستنشاق','غسل الوجه','غسل اليدين إلى المرفقين','مسح الرأس والأذنين','غسل القدمين إلى الكعبين'],
  'تعلم الصلاة':['التعرف إلى القبلة ودخول الوقت','تكبيرة الإحرام','قراءة الفاتحة وما تيسر','الركوع والرفع منه','السجود والجلوس بين السجدتين','التشهد والسلام'],
  'آداب المسلم الصغير':['الصدق والأمانة','بر الوالدين','الرفق بالناس','المحافظة على النظافة','إفشاء السلام'],
 };
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:ListView(padding:const EdgeInsets.all(16),children:[
  const Heading('براعم نور الهدى'),
  const SizedBox(height:8),
  const Text('تعلم ممتع ومتدرج للصغار، مع رسومات تعليمية بلا ملامح وجه ظاهرة؛ مثل الشخصيات الظلية أو المرسومة من الخلف.',style:TextStyle(height:1.9)),
  const SizedBox(height:12),
  ...activities.entries.map((e)=>Card(child:ExpansionTile(leading:const Icon(Icons.auto_stories,color:gold),title:Text(e.key,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),children:e.value.asMap().entries.map((step)=>ListTile(leading:CircleAvatar(backgroundColor:green,foregroundColor:gold,child:Text('${step.key+1}')),title:Text(step.value))).toList()))),
 ]));
}
