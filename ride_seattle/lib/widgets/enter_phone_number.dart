import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

class PhoneSignIn extends StatefulWidget {
  PhoneSignIn({super.key});

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.mounted && loading) {
      context.pop();
      loading = false;
    }
  }

  TextEditingController controller = TextEditingController();
  bool loading = false;
  bool validated = true;
  bool failed = false;
  String message = '';
  String phone = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    var phoneFormatter = MaskTextInputFormatter(
        mask: '(###) ### -####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          if (context.mounted) {
            context.pop();
          }
        }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '+1',
                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        inputFormatters: [phoneFormatter],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autofocus: true,
                        controller: controller,
                        validator: (value) =>
                            phoneFormatter.getUnmaskedText().length == 10
                                ? null
                                : 'Enter a valid phone number.',
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: '',
                            errorStyle: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'route',
                                fontSize: 12),
                            hintStyle:
                                Theme.of(context).primaryTextTheme.bodyMedium),
                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            message != ''
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'route',
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          validated = _formKey.currentState!.validate();
          if (validated) {
            FocusScope.of(context).unfocus();
            setState(() {
              fire.auth.signInWithPhone(
                  context, '+1${phoneFormatter.getUnmaskedText()}', failure);
              showDialog(
                context: context,
                builder: ((context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: LoadingAnimationWidget.inkDrop(
                        color: Theme.of(context).colorScheme.primary, size: 100),
                  );
                }),
              );
            });
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void failure(String m) {
    setState(() {
      failed = true;
      validated = false;
      message = m;
      if (context.mounted) {
        context.pop();
      }
    });
  }
}
