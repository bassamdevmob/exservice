part of 'verification_bloc.dart';

abstract class VerificationFactory {
  final String session;

  VerificationFactory(this.session);

  Future<void> onResend();

  Future<void> onVerify(String code);

  void afterVerified(BuildContext context);
}

class VerificationOnAuthFactory extends VerificationFactory {
  VerificationOnAuthFactory(String session) : super(session);

  @override
  Future<void> onResend() async {
    return GetIt.I.get<AuthRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) async {
    return GetIt.I.get<AuthRepository>().verify(session, code);
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginBloc(),
          child: LoginLayout(),
        ),
      ),
      (route) => false,
    );
  }
}

class VerificationOnResetPasswordFactory extends VerificationFactory {
  VerificationOnResetPasswordFactory(String session) : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I.get<AuthRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) {
    return GetIt.I.get<AuthRepository>().verifyResetPassword(session, code);
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ResetPasswordBloc(context, session),
        child: ResetPasswordLayout(),
      ),
    ));
  }
}

class VerificationOnChangePhoneNumberFactory extends VerificationFactory {
  final ProfileBloc _bloc;

  VerificationOnChangePhoneNumberFactory(String session, this._bloc)
      : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I.get<UserRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) async {
    var response = await GetIt.I.get<UserRepository>().verify(session, code);
    _bloc.add(ProfileUpdateEvent(response.data));
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(SettingsLayout.route));
  }
}

class VerificationOnChangeEmailFactory extends VerificationFactory {
  final ProfileBloc _bloc;

  VerificationOnChangeEmailFactory(String session, this._bloc) : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I.get<UserRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) async {
    var response = await GetIt.I.get<UserRepository>().verify(session, code);
    _bloc.add(ProfileUpdateEvent(response.data));
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(SettingsLayout.route));
  }
}
