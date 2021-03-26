import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker_flutter/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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
      await widget.bloc.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete(EmailSignInModel? model) {
    final _newFocus = model!.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(_newFocus);
  }

  void _toggleFromType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    return [
      _buildEmailTextField(model),
      SizedBox(height: 10.0),
      _buildPasswordTextField(model),
      SizedBox(height: 20.0),
      FormSubmitButton(
        text: model!.primaryButtonText,
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

  TextField _buildEmailTextField(EmailSignInModel? model) {
    return TextField(
      autocorrect: false,
      controller: _emailController,
      decoration: InputDecoration(
        errorText: model!.emailErrorText,
        enabled: model.isLoading == false,
        hintText: 'test@test.com',
        labelText: 'Email',
      ),
      focusNode: _emailFocusNode,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel? model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: model!.passwordErrorText,
        enabled: model.isLoading == false,
        labelText: 'Password',
      ),
      focusNode: _passwordFocusNode,
      obscureText: true,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _submit,
      textInputAction: TextInputAction.done,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Container(
          child: Column(
            children: _buildChildren(model),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
          ),
          padding: const EdgeInsets.all(16.0),
        );
      },
      initialData: EmailSignInModel(),
      stream: widget.bloc.modelStream,
    );
  }
}
