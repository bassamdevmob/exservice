part of 'edit_account_cubit.dart';

abstract class EditAccountFactory {
  bool get valid;

  void validate();

  Future<void> update();

  void dispose();
}

abstract class EditFieldAccountFactory implements EditAccountFactory {
  final TextEditingController controller = TextEditingController();
  String errorMessage;

  bool get valid => errorMessage == null;

  @override
  void dispose() {
    controller.dispose();
  }
}

class EditAccountCompanyFactory extends EditFieldAccountFactory {
  final BuildContext context;
  final User user;

  EditAccountCompanyFactory(this.context)
      : this.user = context.read<AccountBloc>().profile.user {
    controller.text = user.companyName;
  }

  @override
  Future<void> update() async {
    await GetIt.I
        .get<ApiProviderDelegate>()
        .fetchEditProfile(context, companyName: controller.text);
    user.companyName = controller.text;
    context.read<AccountBloc>().add(AccountRefreshEvent());
    Fluttertoast.showToast(
      msg: AppLocalization.of(context).trans("edited"),
    );
  }

  @override
  void validate() {
    if (user.companyName == controller.text) {
      errorMessage =
          AppLocalization.of(context).trans("cannot_submit_same_value");
    } else if (controller.text.isEmpty) {
      errorMessage = AppLocalization.of(context).trans("invalid");
    } else {
      errorMessage = null;
    }
  }
}
