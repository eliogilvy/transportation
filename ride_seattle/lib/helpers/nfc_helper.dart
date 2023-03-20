import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class NFCHelper {
  NFCHelper({required this.nfc});

  NfcManager nfc;
  int count = 0;

  Future<bool> get canRead => nfc.isAvailable();

  void readTag() {
    nfc.startSession(onDiscovered: (tag) async {
      print('reading');
      var result = tag.data;
      print(result.entries.first);
      nfc.stopSession();
    });
  }

  void writeTag() {
    nfc.startSession(onDiscovered: (tag) async {
      var ndef = Ndef.from(tag);

      if (ndef == null || !ndef.isWritable) {
        print('cant read');
        return;
      }
      NdefMessage message =
          NdefMessage([NdefRecord.createText(count.toString())]);
      try {
        await ndef.write(message);
        count += 1;
        nfc.stopSession();
      } catch (e) {
        print('error writing');
        nfc.stopSession();
      }
    });
  }
}
