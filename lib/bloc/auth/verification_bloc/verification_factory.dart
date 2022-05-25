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
          create: (context) => LoginBloc(context),
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
    return GetIt.I.get<AuthRepository>().verify(session, code);
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
  VerificationOnChangePhoneNumberFactory(String session) : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I.get<AuthRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) {
    return GetIt.I.get<AuthRepository>().verify(session, code);
  }

  @override
  void afterVerified(BuildContext context) {
    DataStore.instance.deleteUser();
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginBloc(context),
          child: LoginLayout(),
        ),
      ),
      (route) => false,
    );
  }
}

class VerificationOnChangeEmailAddressFactory extends VerificationFactory {
  VerificationOnChangeEmailAddressFactory(String session) : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I.get<AuthRepository>().resendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) {
    return GetIt.I.get<AuthRepository>().verify(session, code);
  }

  @override
  void afterVerified(BuildContext context) {
    DataStore.instance.deleteUser();
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginBloc(context),
          child: LoginLayout(),
        ),
      ),
      (route) => false,
    );
  }
}
