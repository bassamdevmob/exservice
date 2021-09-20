part of 'verification_bloc.dart';

abstract class VerificationFactory {
  Future<void> onResend();

  Future<void> onVerify(String code);

  void afterVerified(BuildContext context);
}

class VerificationOnAuthFactory extends VerificationFactory {
  final String account;

  VerificationOnAuthFactory(this.account);

  @override
  Future<void> onResend() {
    return GetIt.I
        .get<ApiProviderDelegate>()
        .fetchResendVerificationCode(account);
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
    var response =
        await GetIt.I.get<ApiProviderDelegate>().fetchVerifyUser(account, code);
    DataStore.instance.user = response;
    print(DataStore.instance.user.toJson());
  }
}

class VerificationOnChangePasswordFactory extends VerificationFactory {
  final String account;
  String _code;

  VerificationOnChangePasswordFactory(this.account);

  @override
  Future<void> onResend() {
    return GetIt.I.get<ApiProviderDelegate>().fetchForgetPassword(account);
  }

  @override
  void afterVerified(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ResetPasswordBloc(context, account, _code),
        child: ResetPasswordLayout(),
      ),
    ));
  }

  @override
  Future<void> onVerify(String code) async {
    var response =
        await GetIt.I.get<ApiProviderDelegate>().fetchVerifyUser(account, code);
    _code = code;
    DataStore.instance.user = response;
  }
}
