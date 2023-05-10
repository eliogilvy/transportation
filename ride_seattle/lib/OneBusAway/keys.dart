import 'package:flutter_dotenv/flutter_dotenv.dart';

class Key {
  String getOBA() {
    var oba = dotenv.env['OBA'];
    return oba!;
  }

  String getOTP() {
    var otp = dotenv.env['OTP'];
    return otp!;
  }
}
