import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/user_account.dart';
import 'package:mobile/features/user_account.dart';
import 'package:mobile/features/util.dart';
import 'package:talker_flutter/talker_flutter.dart';

class UserAccountWidget extends StatefulWidget {
  const UserAccountWidget({super.key});

  @override
  State<StatefulWidget> createState() => _UserAccountWidgetState();

}

class _UserAccountWidgetState extends State<UserAccountWidget> {
  final _formKey = GlobalKey<FormState>();
  final _accountIdController = TextEditingController();
  final _accountNameController = TextEditingController();

  String? _buttonValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  _saveButtonOnPressed() async {
    if (_formKey.currentState!.validate()) {
      final account = UserAccount(
          accountId: _accountIdController.text,
          name: _accountNameController.text,
      );
      await saveUserAccount(account);
      GetIt.I<Talker>().info('user account saved');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    }
  }

  _generateOnPressed() async {
    _accountIdController.text = generateUUID();
  }

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: getUserAccount(),
        builder: (context, AsyncSnapshot<UserAccount?> snapshot) {
          if (snapshot.hasData) {
            _accountIdController.text = snapshot.data!.accountId;
            _accountNameController.text = snapshot.data!.name;
            GetIt.I<Talker>().info('user account loaded');
          }
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _accountIdController,
                    decoration: const InputDecoration(
                      labelText: 'Account ID'
                    ),
                    validator: _buttonValidator,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _accountNameController,
                    decoration: const InputDecoration(
                        labelText: 'Account Name'
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: _generateOnPressed, child: const Text('Generate ID')),
                      const SizedBox(width: 20),
                      ElevatedButton( onPressed: _saveButtonOnPressed, child: const Text('Save')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      );
  }

}
