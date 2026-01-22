import 'package:flutter/material.dart';
import 'package:al_muslim/core/constants/cst_config_key.dart';
import 'package:al_muslim/core/constants/cst_fake_data.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Constants {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static CSTConfigKey get configKeys => CSTConfigKey();
  static CstFakeData get fakeData => CstFakeData();

  static bool get showTalker => false;

  static final Talker talker = TalkerFlutter.init(
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(enable: true, defaultTitle: 'ELMUSLIM LOGGER', enableColors: true),
    ),
  );

  static List<int> successStatusCodes = [200, 201, 202, 204];

  static int navbarHeight = 110;

  static String prayTimeApiKey = '3cbJ9hkDgWoIex0tIhfM0wrcE9sazUhCotASgShkJy4bAnVT';

  static const String androidAppLink = 'https://play.google.com/store/apps/details?id=com.elmuslim.app';
  static const String iosAppLink = 'https://apps.apple.com/us/app/al-muslim-%D8%A7%D9%84%D9%85%D8%B3%D9%84%D9%85/id6757352101';

  static const String termsArabicText =
      '1. باستخدامك لتطبيق المسلم، فإنك توافق على السماح للتطبيق باستخدام خدمة الموقع (GPS) لتحديد اتجاه القبلة بدقة.\n'
      '2. التطبيق يحتاج إلى الاتصال بالإنترنت للحصول على مواقيت الصلاة وتحديثها بشكل صحيح.\n'
      '3. عند الموافقة على الإشعارات، سيقوم التطبيق بإرسال تنبيهات لمواقيت الصلاة والأذكار اليومية.\n'
      '4. جميع هذه الأذونات تهدف إلى تحسين تجربتك وضمان وصولك إلى المعلومات في الوقت المناسب.\n'
      '5. التطبيق لا يجمع بيانات شخصية حساسة، ويقتصر استخدامه على ما يخدم الوظائف الأساسية.\n'
      '6. يلتزم التطبيق بالحفاظ على خصوصية المستخدم وعدم مشاركة أي بيانات مع أطراف خارجية.\n'
      '7. يحق للمستخدم إيقاف الإشعارات أو تعطيل الموقع من إعدادات الجهاز في أي وقت، مع العلم أن بعض الوظائف قد لا تعمل بشكل كامل.\n'
      '8. استمرارك في استخدام التطبيق يعني موافقتك على هذه الشروط والأذونات.\n'
      '9. الهدف الأساسي للتطبيق هو خدمة المسلمين وتسهيل الوصول إلى القرآن والأذكار ومواقيت الصلاة بشكل آمن وسهل.\n'
      '10. نحن نسعى لتقديم تجربة روحانية مبسطة، وكل الأذونات المطلوبة مخصصة فقط لدعم هذه التجربة.';

  static const String termsEnglishText =
      '1. By using the Muslim App, you agree to allow the app to use location services (GPS) to determine the Qibla direction accurately.\n'
      '2. The app requires internet access to retrieve and update prayer times correctly.\n'
      '3. By enabling notifications, the app will send you alerts for prayer times and daily supplications.\n'
      '4. These permissions are solely intended to enhance your experience and provide timely information.\n'
      '5. The app does not collect sensitive personal data and only uses permissions necessary for core features.\n'
      '6. User privacy is respected, and no data is shared with third parties.\n'
      '7. Users may disable notifications or location services from device settings at any time, though some features may not function fully.\n'
      '8. Continued use of the app indicates your acceptance of these terms and permissions.\n'
      '9. The primary purpose of the app is to serve Muslims and provide easy, safe access to the Quran, supplications, and prayer times.\n'
      '10. We aim to deliver a simple spiritual experience, and all requested permissions are solely to support this purpose.';

  static const String aboutArabicText =
      'تطبيق المسلم هو رفيقك اليومي في طريق الإيمان والسكينة.\n'
      'يمكنك قراءة الآيات وتدبرها في أي وقت وأي مكان.\n'
      'يوفر لك الأذكار اليومية لتبقى قريبًا من الله في كل لحظة.\n'
      'يحتوي على أدعية مختارة لتقوية القلب وزيادة الطمأنينة.\n'
      'يعرض لك مواقيت الصلاة بدقة لتكون دائمًا على موعد مع الفريضة.\n'
      'يوجهك نحو القبلة أينما كنت ليبقى قلبك حاضرًا مع الله.\n'
      'تم تصميمه ليكون بسيطًا وسهل الاستخدام لكل مسلم.\n'
      'يساعدك على تنظيم وقتك حول العبادات والذكر.\n'
      'يهدف التطبيق إلى أن يكون مصدرًا للنور في حياتك اليومية.\n'
      'يجمع بين البساطة والروحانية في تجربة واحدة متكاملة.\n'
      'يذكرك دومًا بما يقوي إيمانك ويزيد يقينك.\n'
      'مع المسلم، تجد الطمأنينة والسكينة ترافقك أينما كنت.\n'
      'هو أكثر من تطبيق، إنه رفيق روحي في رحلتك مع الله.';

  static const String aboutEnglishText =
      'Muslim App is your daily companion on the path of faith and peace.\n'
      'It brings the beauty of the Holy Quran in authentic script, always easy to access.\n'
      'Read and reflect on verses anytime, anywhere.\n'
      'Daily supplications keep you close to Allah in every moment.\n'
      'Selected prayers strengthen the heart and bring tranquility.\n'
      'Accurate prayer times remind you of your sacred duties.\n'
      'Qibla guidance ensures your heart is always aligned with worship.\n'
      'Designed to be simple and easy for every Muslim to use.\n'
      'Customize fonts and colors to match your style and comfort.\n'
      'Helps you organize your time around worship and remembrance.\n'
      'The app aims to be a source of light in your daily life.\n'
      'It combines simplicity and spirituality in one complete experience.\n'
      'Always reminding you of faith and strengthening your devotion.\n'
      'With Muslim App, peace and serenity accompany you everywhere.\n'
      'It is more than an app, it is a spiritual companion in your journey with Allah.';

  /// Notification id bases
  static const int prayNotificationBaseId = 4200;
  static const int werdNotificationBaseId = 1000;
  static const int morningAzkarNotificationId = 9000;
  static const int eveningAzkarNotificationId = 9001;
  static const int almulkQuranNotificationId = 9002;
  static const int albakraQuranNotificationId = 9003;
  static const int sleepAzkarNotificationId = 9004;
  static const int alkahfQuranNotificationId = 9005;
  static const int hourlyZekrNotificationId = 9100;
}
