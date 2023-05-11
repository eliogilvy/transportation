import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {Key? key, required this.callback, required this.verificationId})
      : super(key: key);
  final Function callback;
  final String verificationId;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
      ),
      body: Center(
        child: Pinput(
          errorText: error ? 'Try again' : null,
          closeKeyboardWhenCompleted: true,
          autofocus: true,
          keyboardType: TextInputType.number,
          mainAxisAlignment: MainAxisAlignment.center,
          length: 6,
          showCursor: true,
          defaultPinTheme: PinTheme(
            width: 50,
            height: 50,
            textStyle: Theme.of(context).primaryTextTheme.bodyMedium,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColorLight),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onCompleted: (value) {
            widget.callback(context, widget.verificationId, value, otpFail);
          },
        ),
      ),
    );
  }

  void otpFail() {
    if (context.mounted) {
      setState(() {
        error = true;
      });
    }
  }

  Widget buildOtpBox(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
