import 'package:flutter/material.dart';

import 'package:time_tracker_flutter/app/sign_in/validators.dart';
import 'package:time_tracker_flutter/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({
    required this.auth,
  });

  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  bool _isLoading = false;
  bool _submitted = false;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _submitted = true;
    });

    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } catch (e) {
      await showAlertDialog(
        context,
        title: 'Sign in Failed',
        content: e.toString(),
        defaultActionText: 'OK',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final _newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFromType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    bool _submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    final _primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';

    final _secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    return [
      _buildEmailTextField(),
      SizedBox(height: 10.0),
      _buildPasswordTextField(),
      SizedBox(height: 20.0),
      FormSubmitButton(
        text: _primaryText,
        onPressed: _submitEnabled ? _submit : null,
      ),
      SizedBox(height: 10.0),
      TextButton(
        child: Text(
          _secondaryText,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        onPressed: _isLoading ? null : _toggleFromType,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool _showErrorText = _submitted && !widget.emailValidator.isValid(_email);

    return TextField(
      autocorrect: false,
      controller: _emailController,
      decoration: InputDecoration(
        errorText: _showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
        hintText: 'test@test.com',
        labelText: 'Email',
      ),
      focusNode: _emailFocusNode,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    bool _showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);

    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: _showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
        labelText: 'Password',
      ),
      focusNode: _passwordFocusNode,
      obscureText: true,
      onChanged: (password) => _updateState(),
      onEditingComplete: _showErrorText ? null : _submit,
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
