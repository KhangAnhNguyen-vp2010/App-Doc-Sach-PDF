import 'package:url_launcher/url_launcher.dart';

Future<void> openGooglePlay(String packageName) async {
  final Uri googlePlayUri = Uri.parse('market://details?id=$packageName');
  final Uri googlePlayWebUri = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');

  if (await canLaunchUrl(googlePlayUri)) {
    await launchUrl(googlePlayUri);
  } else {
    await launchUrl(googlePlayWebUri);
  }
}

Future<void> openAppStore(String appId) async {
  final Uri appStoreUri = Uri.parse('itms-apps://itunes.apple.com/app/id$appId');
  final Uri appStoreWebUri = Uri.parse('https://apps.apple.com/app/id$appId');

  if (await canLaunchUrl(appStoreUri)) {
    await launchUrl(appStoreUri);
  } else {
    await launchUrl(appStoreWebUri);
  }
}
