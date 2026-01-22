import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<bool> lunch(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return _launchUri(uri);
  }

  static Future<bool> launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    return _launchUri(uri);
  }

  static Future<bool> _launchUri(Uri uri) async {
    final launchedDefault = await launchUrl(uri, mode: LaunchMode.platformDefault);
    if (launchedDefault) return true;
    final launchedExternal = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launchedExternal) return true;
    return canLaunchUrl(uri);
  }
}
