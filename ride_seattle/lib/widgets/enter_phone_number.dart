import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

class PhoneSignIn extends StatelessWidget {
  PhoneSignIn({super.key});
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          if (context.mounted) {
            context.pop();
          }
        }),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '+1',
              style: Theme.of(context).primaryTextTheme.bodyMedium,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColorLight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: TextFormField(
                  autofocus: true,
                  controller: controller,
                  validator: (value) => value!.length == 9 ? null : 'Enter a valid phone number.',
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                      hintStyle: Theme.of(context).primaryTextTheme.bodyMedium),
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await fire.auth.signInWithPhone(context, '+1${controller.text}');
       
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
