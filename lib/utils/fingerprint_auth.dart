import 'package:local_auth/local_auth.dart';

class FingerprintAuth {
  bool didAuthenticate = false;
  LocalAuthentication localAuth;

  FingerprintAuth() {
    didAuthenticate = false;
    localAuth = new LocalAuthentication();
  }

  authenticateFingerprint() async {
    try {
      bool didAuthenticate =
          await localAuth.authenticate(localizedReason: "Authentication");
      return didAuthenticate;
    } catch (e) {
      print('Error : ' + e.toString());
      return true;
    }
  }

  mainAuthenticateFingerprint() async {
    try {
      bool didAuthenticate =
          await localAuth.authenticate(localizedReason: "Authentication");
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  stopAuthentication() async {
    localAuth.stopAuthentication();
  }
}
