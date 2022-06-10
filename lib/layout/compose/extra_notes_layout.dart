import 'package:exservice/bloc/ad_details_bloc/ad_details_bloc.dart';
import 'package:exservice/bloc/post/composition_repository.dart';
import 'package:exservice/bloc/post/info_bloc/compose_details_cubit.dart';
import 'package:exservice/bloc/profile_bloc/profile_bloc.dart';
import 'package:exservice/layout/ad_details_layout.dart';
import 'package:exservice/localization/app_localization.dart';
import 'package:exservice/styles/app_colors.dart';
import 'package:exservice/styles/app_text_style.dart';
import 'package:exservice/widget/bottom_sheets/note_input_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExtraNotesLayout extends StatefulWidget {
  const ExtraNotesLayout({Key key}) : super(key: key);

  @override
  State<ExtraNotesLayout> createState() => _ExtraNotesLayoutState();
}

class _ExtraNotesLayoutState extends State<ExtraNotesLayout> {
  ComposeDetailsCubit _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<ComposeDetailsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _bloc.newNote();
        },
      ),
      appBar: AppBar(
        actions: [
          Center(
            child: getNextButton(),
          ),
        ],
      ),
      body: BlocBuilder<ComposeDetailsCubit, ComposeDetailsState>(
        buildWhen: (previous, current) => current is ComposeDetailsUpdateState,
        builder: (context, state) {
          return ReorderableListView.builder(
            itemCount: _bloc.repository.notes.length,
            onReorder: (int oldIndex, int newIndex) {
              _bloc.reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              return Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  trailing: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 25,
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      _bloc.removeNote(index);
                    },
                  ),
                  tileColor: AppColors.gray.withOpacity(0.1),
                  onTap: () {
                    NoteInputBottomSheet.show(
                      context,
                      initValue: NoteResult(
                        note: _bloc.repository.notes[index],
                      ),
                    ).then((value) {
                      if (value != null) {
                        _bloc.updateNote(index, value);
                      }
                    });
                  },
                  title: Text(
                    _bloc.repository.notes[index].isEmpty
                        ? "${AppLocalization.of(context).translate("write_caption")}..."
                        : _bloc.repository.notes[index],
                    style: _bloc.repository.notes[index].isEmpty
                        ? Theme.of(context).primaryTextTheme.titleMedium
                        : Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget getNextButton() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalization.of(context).translate("next"),
          style: AppTextStyle.largeBlue,
        ),
      ),
      onTap: () {
        var repository = _bloc.repository;
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => AdDetailsBloc.review(
                repository.toModel(
                  context.read<ProfileBloc>().model,
                ),
              ),
              child: AdDetailsLayout(),
            ),
          ),
        );
        // Navigator.of(context).push(
        //   CupertinoPageRoute(
        //     builder: (context) => BlocProvider(
        //       create: (context) => ManagePaymentCubit(),
        //       child: ManagePaymentLayout(),
        //     ),
        //   ),
        // );
      },
    );
  }
}
