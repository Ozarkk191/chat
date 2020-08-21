import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinkService {
  Future handleDeepLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeeplink(data);
  }

  void _handleDeeplink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print("deepLink | -$deepLink");
    }
  }
}
