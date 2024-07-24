import 'package:fluttertoast/fluttertoast.dart';
import 'package:sm/utils/colors.dart';

class Utils {
  static void toastmessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryColor,
        textColor: secondaryColor,
        fontSize: 16.0);
  }
}
