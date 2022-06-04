import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/faq/faq_cubit.dart';
import '../../../logic/notifications/notifications_cubit.dart';
import '../../../utils/colors.dart';
import 'components/appbar.dart';
import 'components/faq_list.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => FaqCubit(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
        ),
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBarWidget(),
          ),
          backgroundColor: AppColors.accent,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: _size.height * 0.82,
                  child: const FaqList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
