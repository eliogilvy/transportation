import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ride_seattle/helpers/nfc_helper.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final nfc = NFCHelper(nfc: NfcManager.instance);
  ValueNotifier<dynamic> result = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buy a Ticket",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: nfc.canRead,
          builder: (context, ss) => ss.data != true
              ? Center(
                  child: Text(
                    'NFC functionality unavailable',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                )
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 3,
                      child: GridView.count(
                        padding: EdgeInsets.all(4),
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        children: [
                          ElevatedButton(
                              child: Text('Tag Read'), onPressed: nfc.readTag),
                          ElevatedButton(
                              child: Text('Ndef Write'),
                              onPressed: nfc.writeTag),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
