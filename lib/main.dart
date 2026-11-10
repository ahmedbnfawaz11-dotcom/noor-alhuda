import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdfrx/pdfrx.dart';

const green = Color(0xFF123B30), gold = Color(0xFFC6A45C), paper = Color(0xFFF6F0E4);
const books = <Book>[
 Book('صحيح البخاري','الإمام محمد بن إسماعيل البخاري','الحديث الشريف','من أمهات كتب الحديث النبوي.'),
 Book('صحيح مسلم','الإمام مسلم بن الحجاج','الحديث الشريف','مصنف من أشهر دواوين السنة النبوية.'),
 Book('رياض الصالحين','الإمام يحيى بن شرف النووي','الحديث والآداب','أحاديث في الإيمان والعبادات والأخلاق والآداب.'),
 Book('الأربعون النووية','الإمام يحيى بن شرف النووي','الحديث الشريف','مجموعة مشهورة من جوامع أحاديث النبي صلى الله عليه وسلم.'),
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
 Book('ثلاثة الأصول','الإمام محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة تعليمية في معرفة العبد ربه ودينه ونبيه.',contentAsset:'assets/books/thalathat_alusul.json'),
 Book('القواعد الأربع','الإمام محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة موجزة في قواعد تتعلق بالتوحيد والشرك.',contentAsset:'assets/books/alqawaid_alarbaa.json'),
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
 Book('قطر الندى وبل الصدى','ابن هشام الأنصاري','علوم اللغة العربية','متن مختصر في أبواب النحو مع شرح لمسائلها.'),
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
 Book('الآجرومية','الإمام محمد بن محمد ابن آجروم','علوم اللغة العربية','متن موجز مشهور في مبادئ النحو العربي.',contentAsset:'assets/books/alajurrumiyyah.json'),
 Book('ألفية ابن مالك','الإمام محمد بن عبد الله ابن مالك','علوم اللغة العربية','منظومة جامعة في النحو والصرف، اشتهرت بكثرة شروحها.'),
 Book('شرح المفصل','الإمام يعيش بن علي ابن يعيش','علوم اللغة العربية','شرح تراثي موسع لأبواب النحو والتصريف.'),
 Book('الخصائص','الإمام أبو الفتح عثمان ابن جني','علوم اللغة العربية','مصنف في أصول اللغة وخصائص العربية ومسائلها.'),
 Book('الصاحبي في فقه اللغة','الإمام أحمد بن فارس','علوم اللغة العربية','كتاب في فقه اللغة العربية وأصولها وخصائصها.'),
 Book('جماع العلم','الإمام محمد بن إدريس الشافعي','أصول الفقه','نص رقمي مرفق من مدونة OpenITI، يحتاج إلى مقابلة علمية على الطبعة قبل الاعتماد.',contentAsset:'assets/books/shafii_jima_alilm.json'),
 Book('عمدة الأحكام','الإمام عبد الغني المقدسي','الحديث والفقه','مختصر لأحاديث الأحكام المنتقاة من الصحيحين.'),
 Book('الأصول الثلاثة','الإمام محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة موجزة في أصول معرفة العبد ربه ودينه ونبيه.'),
 Book('فضل الإسلام','الإمام محمد بن عبد الوهاب','العقيدة والتوحيد','رسالة في فضل الإسلام والتحذير مما يضاده.'),
 Book('كتاب التوحيد لابن خزيمة','الإمام محمد بن إسحاق ابن خزيمة','العقيدة والتوحيد','مصنف في تقرير توحيد الله وأسمائه وصفاته، وتختلف عناوين وترتيبات نسخه.'),
 Book('صفة صلاة النبي','الشيخ محمد ناصر الدين الألباني','الفقه والحديث','كتاب معاصر يجمع أحاديث صفة الصلاة مع التخريج؛ يلزم التحقق من حقوق النسخة قبل إرفاقها.'),
 Book('مختصر صحيح البخاري','الإمام زين الدين الزبيدي','الحديث الشريف','مختصر مشهور لصحيح البخاري بحذف الأسانيد وتبويب الأحاديث.'),
 Book('مختصر صحيح مسلم','الإمام المنذري','الحديث الشريف','مختصر لأحاديث صحيح مسلم، وله روايات وطبعات متعددة.'),
 Book('الترغيب والترهيب','الإمام عبد العظيم المنذري','الحديث والآداب','مصنف في أحاديث الترغيب والترهيب مع عزوها إلى مصادرها.'),
 Book('المحلى بالآثار','الإمام علي بن أحمد ابن حزم','الفقه والحديث','مصنف فقهي استدلالي واسع يعرض المسائل وأدلتها وآثارها.'),
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

class Book { final String title,author,category,summary; final String? pdfAsset; final String? pdfFilePath; final String? contentAsset; const Book(this.title,this.author,this.category,this.summary,{this.pdfAsset,this.pdfFilePath,this.contentAsset}); String get key => '$title::$author'; }
const categories=['القرآن وعلومه','الحديث الشريف','العقيدة والتوحيد','الفقه والحديث','السيرة والشمائل','أصول الفقه','الحديث والآداب','الأذكار والرقائق','علوم اللغة العربية','كتب أهل السنة والجماعة','التاريخ والتراجم','المسلمون الجدد','قسم الأطفال'];

Future<void> main() async { WidgetsFlutterBinding.ensureInitialized(); final p=await SharedPreferences.getInstance(); runApp(NoorApp(firstRun:!(p.getBool('seen_intro')??false))); }
class NoorApp extends StatelessWidget { final bool firstRun; const NoorApp({super.key,required this.firstRun}); @override Widget build(BuildContext c)=>MaterialApp(title:'نور الهدى',debugShowCheckedModeBanner:false,theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:paper,colorScheme:ColorScheme.fromSeed(seedColor:green,primary:green,secondary:gold),appBarTheme:const AppBarTheme(backgroundColor:Color(0xFF09271F),foregroundColor:Colors.white,centerTitle:true,elevation:0),cardTheme:const CardThemeData(color:Color(0xFFFFFCF5),elevation:1,margin:EdgeInsets.symmetric(vertical:6),shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(16)),side:BorderSide(color:gold,width:0.8))),dividerColor:gold),home:LaunchPage(firstRun:firstRun)); }

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
 Future<void> load() async {final p=await SharedPreferences.getInstance();final stored=p.getStringList('saved_books')??[];final migrated=<String>{};for(final b in catalogBooks){if(stored.contains(b.key)||stored.contains(b.title))migrated.add(b.key);}if(mounted)setState(()=>saved=migrated);if(migrated.length!=stored.length)await p.setStringList('saved_books',migrated.toList());}
 Future<void> toggle(Book b) async {setState((){if(saved.contains(b.key)){saved.remove(b.key);}else{saved.add(b.key);}});final p=await SharedPreferences.getInstance();await p.setStringList('saved_books',saved.toList());}
 @override Widget build(BuildContext c){
 final normalizedQuery=normalizeArabic(query.trim()); final matches=catalogBooks.where((b)=>normalizeArabic(b.title+' '+b.author+' '+b.category+' '+b.summary).contains(normalizedQuery)).toList();
 return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Column(children:[Text('نور الهدى',style:TextStyle(fontWeight:FontWeight.bold)),Text('الموسوعة الإسلامية',style:TextStyle(fontSize:11,color:Color(0xFFE8D9B7)))])),
 drawer:Drawer(child:Column(children:[Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(20,55,20,25),color:green,child:const Column(children:[Icon(Icons.menu_book,color:gold,size:45),Text('نور الهدى',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold))])),ListTile(leading:const Icon(Icons.home),title:const Text('الرئيسية'),onTap:(){Navigator.pop(c);setState(()=>tab=0);}),ListTile(leading:const Icon(Icons.bookmark_outline),title:const Text('مكتبتي الخاصة'),onTap:(){Navigator.pop(c);setState(()=>tab=1);}),ListTile(leading:const Icon(Icons.person_outline),title:const Text('المسلمون الجدد'),onTap:(){Navigator.pop(c);setState(()=>tab=2);}),ListTile(leading:const Icon(Icons.child_care),title:const Text('قسم الأطفال'),onTap:(){Navigator.pop(c);setState(()=>tab=3);}),ListTile(leading:const Icon(Icons.collections_bookmark_outlined),title:const Text('كتب أهل السنة والجماعة'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>SunniBooksPage(saved:saved,onToggle:toggle)));}),ListTile(leading:const Icon(Icons.library_books_outlined),title:const Text('الأحاديث والأسانيد'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>const HadithLibraryPage()));}),ListTile(leading:const Icon(Icons.info_outline),title:const Text('حول الموسوعة ومصادرها'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>const InfoPage(title:'حول نور الهدى',body:'نور الهدى موسوعة إسلامية تهدف إلى تسهيل الوصول إلى فهارس الكتب والمواد العلمية الموثوقة.\n\nلا يُدرج نص كتاب كامل إلا بعد التحقق من مصدر النسخة وبيانات الطبعة والمحقق وحقوق إعادة التوزيع.\n\nقد تظهر بعض الكتب في الفهرس ببيانات تعريفية فقط إلى حين توفير نص رقمي موثوق ومسموح بإتاحته دون اتصال.\n\nنسأل الله أن يجعل هذا العمل خالصاً نافعاً.')));})])),
 body:tab==1?Favorites(saved:saved,onToggle:toggle):tab==2?const NewMuslimPage():tab==3?const ChildrenPage():ListView(padding:const EdgeInsets.all(16),children:[
 Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(gradient:const LinearGradient(colors:[green,Color(0xFF1D5A46)]),borderRadius:BorderRadius.circular(22),border:Border.all(color:gold)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('﴿ وَقُل رَّبِّ زِدْنِي عِلْمًا ﴾',style:TextStyle(color:gold,fontSize:23,fontWeight:FontWeight.bold)),const SizedBox(height:7),const Text('بوابتك إلى مصادر العلم والتراث الإسلامي',style:TextStyle(color:Colors.white)),const SizedBox(height:15),TextField(onChanged:(v)=>setState(()=>query=v),decoration:InputDecoration(hintText:'ابحث عن كتاب أو مؤلف أو قسم...',prefixIcon:const Icon(Icons.search,color:green),filled:true,fillColor:paper,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide.none)))])),
 const SizedBox(height:20),const Heading('أقسام الموسوعة'),const SizedBox(height:10),
 GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:categories.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing:9,crossAxisSpacing:9,childAspectRatio:2.05),itemBuilder:(ctx,i)=>InkWell(onTap:()=>Navigator.push(ctx,MaterialPageRoute(builder:(_)=>CategoryPage(category:categories[i],saved:saved,onToggle:toggle))),child:Container(decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:const Color(0xFFDDCBA7))),child:Center(child:Text(categories[i],textAlign:TextAlign.center,style:const TextStyle(color:green,fontWeight:FontWeight.bold)))))),
 const SizedBox(height:20),Heading(query.isEmpty?'كتب مقترحة للفهرسة':'نتائج البحث'),
 if(matches.isEmpty)const Padding(padding:EdgeInsets.all(20),child:Text('لا توجد نتائج مطابقة.',textAlign:TextAlign.center))else ...matches.map((b)=>BookTile(book:b,saved:saved.contains(b.key),onSave:()=>toggle(b))),
 const SizedBox(height:10),const Text('تنبيه: هذه نسخة تأسيسية للفهرس والتصميم. النصوص الكاملة تحتاج إلى إدراج نسخ رقمية موثوقة ومراجعة بياناتها قبل إتاحتها.',style:TextStyle(color:Colors.brown,fontSize:12,height:1.7))
 ]),
 bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(v)=>setState(()=>tab=v),destinations:const[NavigationDestination(icon:Icon(Icons.home_outlined),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.bookmark_outline),label:'مكتبتي'),NavigationDestination(icon:Icon(Icons.person_outline),label:'المسلم الجديد'),NavigationDestination(icon:Icon(Icons.child_care),label:'الأطفال')]),
 ));
 }
}
class Heading extends StatelessWidget {final String title;const Heading(this.title,{super.key});@override Widget build(BuildContext c)=>Row(children:[Container(width:4,height:22,color:gold),const SizedBox(width:9),Text(title,style:const TextStyle(color:green,fontSize:18,fontWeight:FontWeight.bold))]);}
class BookTile extends StatelessWidget {
 final Book book;final bool saved;final VoidCallback onSave;const BookTile({super.key,required this.book,required this.saved,required this.onSave});
 @override Widget build(BuildContext c)=>Card(color:Colors.white,elevation:0,margin:const EdgeInsets.symmetric(vertical:5),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14),side:const BorderSide(color:Color(0xFFDDCBA7))),child:ListTile(leading:Container(width:42,height:48,decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(8)),child:const Icon(Icons.menu_book,color:gold)),title:Text(book.title,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),subtitle:Text(book.author+'\n'+book.category+' • '+(book.contentAsset!=null||book.pdfAsset!=null||book.pdfFilePath!=null?'نص مرفق':'بيانات الفهرس فقط'),maxLines:2,overflow:TextOverflow.ellipsis),trailing:IconButton(onPressed:onSave,icon:Icon(saved?Icons.bookmark:Icons.bookmark_border,color:gold)),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>BookDetails(book:book,saved:saved,onSave:onSave)))));
}
class SunniBooksPage extends StatelessWidget {
 final Set<String> saved;
 final Future<void> Function(Book) onToggle;
 const SunniBooksPage({super.key,required this.saved,required this.onToggle});
 @override Widget build(BuildContext c) {
  final grouped=<String,List<Book>>{};
  final seenBooks=<String>{};
  for(final b in catalogBooks.where((b)=>b.category=='كتب أهل السنة والجماعة'||b.category!='قسم الأطفال'&&b.category!='المسلمون الجدد')) {
   if(seenBooks.add(b.key)) grouped.putIfAbsent(b.author,()=>[]).add(b);
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
    ...authors.map((author)=>Card(color:Colors.white,elevation:0,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14),side:const BorderSide(color:Color(0xFFDDCBA7))),child:ExpansionTile(leading:const Icon(Icons.account_balance,color:gold),title:Text(author,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),children:grouped[author]!.map((b)=>BookTile(book:b,saved:saved.contains(b.key),onSave:()=>onToggle(b))).toList()))),
    const SizedBox(height:12),
    const Text('تنبيه: ترتيب الكتب بحسب المؤلف أو الراوي كما هو مثبت في بيانات الفهرس، وبعض المصنفات روايات أو جمعٌ عن العالم وليست كلها تأليفًا مباشرًا له.',style:TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
   ]),
  ));
 }
}
class CategoryPage extends StatelessWidget {
 final String category;final Set<String> saved;final Future<void> Function(Book) onToggle;const CategoryPage({super.key,required this.category,required this.saved,required this.onToggle});
 @override Widget build(BuildContext c){final list=category=='كتب أهل السنة والجماعة'?catalogBooks.toList():catalogBooks.where((b)=>b.category==category||(category=='الحديث الشريف'&&b.category=='الحديث والآداب')).toList();return Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:Text(category)),body:list.isEmpty?const Center(child:Text('سيضاف فهرس هذا القسم بعد مراجعة مصادره.')):ListView(padding:const EdgeInsets.all(12),children:list.map((b)=>BookTile(book:b,saved:saved.contains(b.key),onSave:()=>onToggle(b))).toList())));}
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
  final value=p.getString('note_${widget.book.key}')??'';
  if(!mounted)return;
  noteController.text=value;
  setState(()=>noteLoaded=true);
 }
 Future<void> saveNote() async {
  setState(()=>noteSaving=true);
  final p=await SharedPreferences.getInstance();
  await p.setString('note_${widget.book.key}',noteController.text);
  if(!mounted)return;
  setState(()=>noteSaving=false);
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('حُفظت ملاحظتك على هذا الجهاز.')));
 }
 @override void dispose(){noteController.dispose();super.dispose();}
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
  appBar:AppBar(title:const Text('بيانات الكتاب')),
  body:CustomPaint(painter:OrnatePagePainter(),child:ListView(padding:const EdgeInsets.fromLTRB(28,22,28,30),children:[
    Container(padding:const EdgeInsets.symmetric(vertical:18,horizontal:12),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF09271F),green,Color(0xFF09271F)]),borderRadius:BorderRadius.circular(16),border:Border.all(color:gold,width:1.8),boxShadow:[BoxShadow(color:green.withOpacity(0.16),blurRadius:10,offset:const Offset(0,4))]),child:const Column(children:[Icon(Icons.auto_awesome,color:gold,size:22),SizedBox(height:5),Text('موسوعة نُور الهُدَى',style:TextStyle(color:gold,fontSize:17,fontWeight:FontWeight.bold)),SizedBox(height:7),Icon(Icons.menu_book,color:Color(0xFFE8D5A5),size:52),SizedBox(height:5),Text('صفحة من كنوز العلم والتراث',style:TextStyle(color:paper,fontSize:12))])),
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
   if(widget.book.contentAsset!=null) ...[
    const SizedBox(height:18),
    const Heading('النص الرقمي المرفق'),
    const SizedBox(height:8),
    FutureBuilder<String>(
     future:rootBundle.loadString(widget.book.contentAsset!),
     builder:(context,snapshot){
      if(snapshot.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
      if(snapshot.hasError||!snapshot.hasData)return const Text('تعذر تحميل النص. تحقق من تضمين ملف الكتاب في التطبيق.');
      try {
       final data=jsonDecode(snapshot.data!);
       final bookData=data['books'][widget.book.title] as Map<String,dynamic>;
       final chapters=bookData['chapters'] as List;
       final text=chapters.map((chapter)=>'${chapter['title']??''}\n\n${chapter['text'] as String}').join('\n\n');
       return Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        if(bookData['source']!=null) Text('المصدر: ${bookData['source']}',style:const TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
        if(bookData['edition']!=null) Text('النسخة: ${bookData['edition']}',style:const TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
        if(bookData['license']!=null) Text('الإتاحة والترخيص: ${bookData['license']}',style:const TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
        const SizedBox(height:10),
        SelectableText(text,style:TextStyle(fontSize:fontSize,height:2.0,color:Colors.black87)),
       ]);
      } catch (_) {
       return const Text('صيغة ملف الكتاب غير صالحة للعرض.');
      }
     },
    ),
    const SizedBox(height:8),
    Text('المصدر الرقمي: راجع بيانات المصدر والترخيص في ملف الكتاب داخل المستودع. النص يحتاج إلى مقابلة علمية على الطبعة قبل الاعتماد النهائي.',style:const TextStyle(color:Colors.brown,fontSize:12,height:1.8)),
   ],
   const SizedBox(height:18),
   if(widget.book.pdfAsset!=null||widget.book.pdfFilePath!=null) ...[
    const SizedBox(height:18),
    FilledButton.icon(
     onPressed:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>InAppPdfReader(title:widget.book.title,assetPath:widget.book.pdfAsset,filePath:widget.book.pdfFilePath))),
     icon:const Icon(Icons.picture_as_pdf),
     label:const Text('اقرأ الكتاب داخل نور الهدى'),
     style:FilledButton.styleFrom(backgroundColor:green,foregroundColor:gold),
    ),
   ],
   FilledButton.icon(onPressed:widget.onSave,icon:Icon(widget.saved?Icons.bookmark:Icons.bookmark_add_outlined),label:Text(widget.saved?'إزالة من مكتبتي':'أضف إلى مكتبتي')),
   const SizedBox(height:20),
   const Heading('ملاحظاتي الخاصة'),
   const SizedBox(height:8),
   TextField(controller:noteController,minLines:3,maxLines:7,decoration:InputDecoration(hintText:'اكتب فوائدك أو ملاحظاتك حول هذا الكتاب...',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
   const SizedBox(height:8),
   FilledButton.tonalIcon(onPressed:!noteLoaded||noteSaving?null:saveNote,icon:const Icon(Icons.save_outlined),label:Text(noteSaving?'جارٍ الحفظ...':'احفظ ملاحظاتي على الجهاز')),
   const SizedBox(height:18),
   if(widget.book.contentAsset==null&&widget.book.pdfAsset==null&&widget.book.pdfFilePath==null) Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFFFF4DD),borderRadius:BorderRadius.circular(12),border:Border.all(color:gold)),child:const Text('هذا الكتاب مدرج في الفهرس ببياناته التعريفية فقط؛ لم يُرفق نصه الكامل بعد. لن نعرض مقتطفاً على أنه كتاب كامل، ولن نضيف نصاً قبل التحقق من مصدره وحقوق إتاحته.',style:TextStyle(color:Colors.brown,height:1.9))),
   ])),
  ));
}

class OrnatePagePainter extends CustomPainter {
 @override void paint(Canvas canvas, Size size) {
  final outer=Paint()..color=gold..style=PaintingStyle.stroke..strokeWidth=2.2;
  final inner=Paint()..color=green..style=PaintingStyle.stroke..strokeWidth=1.1;
  canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(9,9,size.width-18,size.height-18),const Radius.circular(18)),outer);
  canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(15,15,size.width-30,size.height-30),const Radius.circular(14)),inner);
  final ornament=Paint()..color=gold..style=PaintingStyle.stroke..strokeWidth=1.4;
  for(final y in [28.0,size.height-28]) {
   for(final x in [28.0,size.width-28]) {
    final path=Path()..moveTo(x,y-7)..lineTo(x+7,y)..lineTo(x,y+7)..lineTo(x-7,y)..close();
    canvas.drawPath(path,ornament);
    canvas.drawCircle(Offset(x,y),2.2,Paint()..color=gold);
   }
  }
  final center=size.width/2;
  for(final y in [20.0,size.height-20]) {
   final path=Path()..moveTo(center,y-5)..lineTo(center+5,y)..lineTo(center,y+5)..lineTo(center-5,y)..close();
   canvas.drawPath(path,ornament);
  }
 }
 @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _BookMetaRow extends StatelessWidget {
 final String label,value;
 const _BookMetaRow({required this.label,required this.value});
 @override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
  SizedBox(width:125,child:Text(label,style:const TextStyle(color:green,fontWeight:FontWeight.bold))),
  Expanded(child:Text(value,style:const TextStyle(height:1.6))),
 ]));
}

class Favorites extends StatelessWidget {final Set<String> saved;final Future<void> Function(Book) onToggle;const Favorites({super.key,required this.saved,required this.onToggle});@override Widget build(BuildContext c){final list=catalogBooks.where((b)=>saved.contains(b.key)).toList();return list.isEmpty?const Center(child:Text('لم تضف كتباً إلى مكتبتك بعد.')):ListView(padding:const EdgeInsets.all(12),children:list.map((b)=>BookTile(book:b,saved:true,onSave:()=>onToggle(b))).toList());}}
class HadithLibraryPage extends StatelessWidget {
 const HadithLibraryPage({super.key});
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
  appBar:AppBar(title:const Text('الأحاديث والأسانيد')),
  body:FutureBuilder<String>(
   future:rootBundle.loadString('assets/hadith/hadiths.json'),
   builder:(context,snapshot){
    if(snapshot.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());
    if(snapshot.hasError||!snapshot.hasData)return const Center(child:Text('تعذر تحميل قاعدة الأحاديث.'));
    try {
     final data=jsonDecode(snapshot.data!) as Map<String,dynamic>;
     final items=data['hadiths'] as List<dynamic>;
     return ListView(padding:const EdgeInsets.all(14),children:[
      Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:green,borderRadius:BorderRadius.circular(14),border:Border.all(color:gold)),child:Text(data['note']??'',style:const TextStyle(color:Colors.white,height:1.8))),
      const SizedBox(height:10),
      ...items.map((raw){
       final h=raw as Map<String,dynamic>;
       final narrators=(h['narrators'] as List<dynamic>? ?? []);
       final alternates=(h['alternate_routes'] as List<dynamic>? ?? []);
       return Card(child:ExpansionTile(
        leading:const Icon(Icons.menu_book,color:gold),
        title:Text(h['title']??'حديث',style:const TextStyle(color:green,fontWeight:FontWeight.bold)),
        subtitle:Text('${h['source']??''} • ${h['reference']??''}',maxLines:2,overflow:TextOverflow.ellipsis),
        children:[
         Padding(padding:const EdgeInsets.fromLTRB(16,4,16,16),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          Text('الصحابي الراوي: ${h['narrator']??'غير محدد'}',style:const TextStyle(fontWeight:FontWeight.bold)),
          const SizedBox(height:8),
          if(h['matn']!=null) ...[
           const Text('متن الحديث',style:TextStyle(color:green,fontWeight:FontWeight.bold)),
           SelectableText(h['matn'],style:const TextStyle(height:2,fontSize:17)),
          ] else if(h['matn_summary']!=null) ...[
           const Text('ملخص تعريفي — ليس المتن الكامل',style:TextStyle(color:Colors.brown,fontWeight:FontWeight.bold)),
           Text(h['matn_summary'],style:const TextStyle(height:1.9)),
          ],
          const SizedBox(height:10),
          const Text('نص الإسناد المحفوظ',style:TextStyle(color:green,fontWeight:FontWeight.bold)),
          SelectableText(h['isnad_text']??'',style:const TextStyle(height:1.9)),
          const SizedBox(height:8),
          const Text('الرواة بالترتيب',style:TextStyle(color:green,fontWeight:FontWeight.bold)),
          ...narrators.asMap().entries.map((entry)=>Padding(padding:const EdgeInsets.symmetric(vertical:3),child:Text('${entry.key+1}. ${entry.value}'))),
          if(alternates.isNotEmpty) ...[
           const SizedBox(height:8),
           const Text('طريق بديل مذكور في المصدر',style:TextStyle(color:green,fontWeight:FontWeight.bold)),
           ...alternates.asMap().entries.map((entry)=>Padding(padding:const EdgeInsets.symmetric(vertical:3),child:Text('${entry.key+1}. ${entry.value}'))),
          ],
          const SizedBox(height:8),
          Text('الحكم المنقول: ${h['grade']??'لم يدرج'}',style:const TextStyle(fontWeight:FontWeight.bold)),
          Text(h['verification_note']??'',style:const TextStyle(color:Colors.brown,height:1.8,fontSize:12)),
          if(h['source_url']!=null) SelectableText('المصدر: ${h['source_url']}',style:const TextStyle(color:green,fontSize:12)),
         ]))
        ],
       ));
      }),
     ]);
    } catch (_) {
     return const Center(child:Text('تعذر قراءة تنسيق قاعدة الأحاديث؛ يلزم فحص ملف البيانات.'));
    }
   },
  ),
 ));
}

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

class ChildrenPage extends StatefulWidget {
 const ChildrenPage({super.key});
 @override State<ChildrenPage> createState()=>_ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
 static const activities = <String, List<String>>{
  'تعلم الوضوء':['غسل الكفين','المضمضة والاستنشاق','غسل الوجه','غسل اليدين إلى المرفقين','مسح الرأس والأذنين','غسل القدمين إلى الكعبين'],
  'تعلم الصلاة':['التعرف إلى القبلة ودخول الوقت','تكبيرة الإحرام','قراءة الفاتحة وما تيسر','الركوع والرفع منه','السجود والجلوس بين السجدتين','التشهد والسلام'],
  'آداب المسلم الصغير':['الصدق والأمانة','بر الوالدين','الرفق بالناس','المحافظة على النظافة','إفشاء السلام'],
 };
 Set<String> completed={};
 @override void initState(){super.initState();_loadProgress();}
 Future<void> _loadProgress() async {final p=await SharedPreferences.getInstance();if(mounted)setState(()=>completed=p.getStringList('children_completed_steps')?.toSet()??{});}
 Future<void> _toggleStep(String key,bool value) async {setState((){if(value){completed.add(key);}else{completed.remove(key);}});final p=await SharedPreferences.getInstance();await p.setStringList('children_completed_steps',completed.toList());}
 @override Widget build(BuildContext c) {
  final total=activities.values.fold<int>(0,(sum,steps)=>sum+steps.length);
  return Directionality(textDirection:TextDirection.rtl,child:ListView(padding:const EdgeInsets.all(16),children:[
   const Heading('براعم نور الهدى'),
   const SizedBox(height:8),
   const Text('تعلم متدرج للصغار، مع رسومات تعليمية بلا ملامح وجه ظاهرة؛ مثل الشخصيات الظلية أو المرسومة من الخلف. ضع علامة عند إتمام كل خطوة، وسيُحفظ التقدم على هذا الجهاز.',style:TextStyle(height:1.9)),
   const SizedBox(height:10),
   LinearProgressIndicator(value:total==0?0:completed.length/total,color:green,backgroundColor:gold,minHeight:8),
   const SizedBox(height:6),
   Text('أنجزت ${completed.length} من ${total} خطوات',textAlign:TextAlign.center,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),
   const SizedBox(height:12),
   ...activities.entries.map((e)=>Card(child:ExpansionTile(leading:const Icon(Icons.auto_stories,color:gold),title:Text(e.key,style:const TextStyle(color:green,fontWeight:FontWeight.bold)),subtitle:Text('${e.value.where((step)=>completed.contains('${e.key}::$step')).length} من ${e.value.length} مكتملة'),children:e.value.map((step){final key='${e.key}::$step';return CheckboxListTile(value:completed.contains(key),activeColor:green,controlAffinity:ListTileControlAffinity.leading,title:Text(step),onChanged:(value)=>_toggleStep(key,value??false));}).toList()))),
  ]));
 }
}


/// قارئ PDF مدمج: يعرض المستند داخل التطبيق ولا يرسله إلى مشغل خارجي.
class InAppPdfReader extends StatelessWidget {
 final String title;
 final String? assetPath;
 final String? filePath;
 const InAppPdfReader({super.key,required this.title,this.assetPath,this.filePath}) : assert(assetPath!=null||filePath!=null);
 @override Widget build(BuildContext context)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(
  appBar:AppBar(title:Text(title),actions:[const Padding(padding:EdgeInsets.symmetric(horizontal:12),child:Center(child:Text('نور الهدى',style:TextStyle(color:gold,fontSize:12))))]),
  backgroundColor:paper,
  body:Container(margin:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,border:Border.all(color:gold,width:1.4),borderRadius:BorderRadius.circular(10)),clipBehavior:Clip.antiAlias,child:assetPath!=null?PdfViewer.asset(assetPath!):PdfViewer.file(filePath!)),
 ));
}
