import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker_flutter/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final _newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFromType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 10.0),
      _buildPasswordTextField(),
      SizedBox(height: 20.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 10.0),
      TextButton(
        child: Text(
          model.secondaryButtonText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        onPressed: model.isLoading ? null : _toggleFromType,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      autocorrect: false,
      controller: _emailController,
      decoration: InputDecoration(
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
        hintText: 'test@test.com',
        labelText: 'Email',
      ),
      focusNode: _emailFocusNode,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
        labelText: 'Password',
      ),
      focusNode: _passwordFocusNode,
      obscureText: true,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
      textInputAction: TextInputAction.done,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _buildChildren(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
      ),
      padding: const EdgeInsets.all(16.0),
    );
  }
}
