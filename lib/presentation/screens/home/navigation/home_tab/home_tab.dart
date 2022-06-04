import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../logic/home_tab/cubit/home_tab_cubit.dart';
import '../../../../common/refer_widget.dart';
import 'components/buttons_section.dart';
import 'components/todays_shift_section.dart';
import 'components/top_section.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => HomeTabCubit(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              TopSection(),
              SizedBox(
                height: 16,
              ),
              ButtonsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
