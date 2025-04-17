import 'package:flutx/flutx.dart';

class SplashController extends FxController {
  @override
  String getTag() {
    return "splash_controller";
  }

  void goToSearchScreen() {
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(builder: (context) => EstateSearchScreen()),
    // );
  }

  void goToLogin() {
    // Navigator.of(context, rootNavigator: true).push(
    //   MaterialPageRoute(builder: (context) => EstateLoginScreen()),
    // );
  }
}
