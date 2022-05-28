import 'package:exservice/bloc/contact_us_bloc/contact_us_bloc.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:exservice/widget/application/directional_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsLayout extends StatelessWidget {
  const ContactUsLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("contact_us")),
      ),
      body: Padding(
        padding: Sizer.scaffoldPadding,
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      getTitleField(),
                      SizedBox(height: Sizer.vs2),
                      getContentField(),
                    ],
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Sizer.vs3,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalization.of(context).translate("send"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getTitleField() {
    return BlocBuilder<ContactUsBloc, ContactUsState>(
      buildWhen: (_, current) => current is ContactUsValidationState,
      builder: (context, state) {
        ContactUsBloc _bloc = BlocProvider.of<ContactUsBloc>(context);
        return DirectionalTextField(
          controller: _bloc.titleController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: AppLocalization.of(context).translate("enter_message_title"),
            errorText: _bloc.titleMessage?.toString(),
          ),
        );
      },
    );
  }

  Widget getContentField() {
    return BlocBuilder<ContactUsBloc, ContactUsState>(
      buildWhen: (_, current) => current is ContactUsValidationState,
      builder: (context, state) {
        ContactUsBloc _bloc = BlocProvider.of<ContactUsBloc>(context);
        return DirectionalTextField(
          controller: _bloc.contentController,
          keyboardType: TextInputType.phone,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: AppLocalization.of(context).translate("enter_message_here"),
            errorText: _bloc.contentMessage?.toString(),
          ),
        );
      },
    );
  }
}
