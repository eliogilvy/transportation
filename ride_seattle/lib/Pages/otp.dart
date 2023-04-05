import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen(
      {Key? key, required this.callback, required this.verificationId})
      : super(key: key);
  final Function callback;
  final String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
      ),
      body: Center(
        child: Pinput(
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
            callback(context, verificationId, value);
          },
        ),
      ),
    );
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
