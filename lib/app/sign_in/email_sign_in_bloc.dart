import 'dart:async';

import 'package:time_tracker_flutter/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  EmailSignInModel _model = EmailSignInModel();

  final AuthBase auth;
  final _modelController = StreamController<EmailSignInModel>();

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);

    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  void dispose() => _modelController.close();

  void toggleFormType() {
    final _formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;

    updateWith(
      email: '',
      password: '',
      formType: _formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }
}
