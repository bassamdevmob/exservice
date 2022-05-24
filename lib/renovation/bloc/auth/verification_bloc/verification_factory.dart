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
  Future<void> onResend() {
    return GetIt.I
        .get<ApiProviderDelegate>()
        .fetchResendVerificationCode(session);
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => WelcomeLayout(),
      ),
    );
  }

  @override
  Future<void> onVerify(String code) async {
    var response = await GetIt.I.get<AuthRepository>().verify(session, code);
    DataStore.instance.user = response.data.user;
    print(DataStore.instance.user.toJson());
  }
}

class VerificationOnChangePasswordFactory extends VerificationFactory {
  String _code;

  VerificationOnChangePasswordFactory(String session) : super(session);

  @override
  Future<void> onResend() {
    return GetIt.I
        .get<ApiProviderDelegate>()
        .fetchResendVerificationCode(session);
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ResetPasswordBloc(context, session, _code),
        child: ResetPasswordLayout(),
      ),
    ));
  }

  @override
  Future<void> onVerify(String code) async {
    var response =
        await GetIt.I.get<ApiProviderDelegate>().fetchVerifyUser(session, code);
    _code = code;
    DataStore.instance.user = response;
  }
}

class VerificationOnChangePhoneNumberFactory extends VerificationFactory {
  VerificationOnChangePhoneNumberFactory(String session) : super(session);

  @override
  void afterVerified(BuildContext context) {
    DataStore.instance.deleteUser();
    BlocProvider.of<ApplicationCubit>(context).refresh();
  }

  @override
  Future<void> onResend() {
    return GetIt.I
        .get<ApiProviderDelegate>()
        .fetchResendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) {
    return GetIt.I.get<ApiProviderDelegate>().fetchVerifyPin(session, code);
  }
}

class VerificationOnChangeEmailAddressFactory extends VerificationFactory {
  VerificationOnChangeEmailAddressFactory(String session) : super(session);

  @override
  void afterVerified(BuildContext context) {
    DataStore.instance.deleteUser();
    BlocProvider.of<ApplicationCubit>(context).refresh();
  }

  @override
  Future<void> onResend() {
    return GetIt.I
        .get<ApiProviderDelegate>()
        .fetchResendVerificationCode(session);
  }

  @override
  Future<void> onVerify(String code) {
    return GetIt.I.get<ApiProviderDelegate>().fetchVerifyPin(session, code);
  }
}
