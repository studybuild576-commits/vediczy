export 'ad_service_stub.dart' // Default fallback
    if (dart.library.html) 'ad_service_web.dart' // Web ke liye
    if (dart.library.io) 'ad_service_mobile.dart'; // Mobile ke liye
