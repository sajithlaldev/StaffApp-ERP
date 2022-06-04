import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../logic/edit_profile/cubit/edit_profile_cubit.dart';
import '../../common/widgets.dart';
import '../../../utils/colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/utils.dart';

import '../../../data/models/staff.dart';
import '../../../utils/strings.dart';
import '../../common/default_textfield.dart';
import 'components/appbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    Key? key,
  }) : super(key: key);

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passWordController = TextEditingController();
  final professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Staff staff =
        (context.read<AuthenticationCubit>().state as AuthenticationSuccess)
            .staff!;

    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: Scaffold(
        backgroundColor: AppColors.accent,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBarWidget(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12,
          ),
          child: Column(
            children: [
              DefaultTextField(
                controller: fullNameController..text = staff.name,
                hintText: Strings.FULL_NAME,
                isDense: true,
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: emailController..text = staff.email,
                hintText: Strings.EMAIL,
                isDense: true,
                readOnly: true,
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: phoneController..text = staff.phone,
                hintText: Strings.PHONE,
                isDense: true,
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: professionController,
                hintText: Strings.PROFESSION,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.INTRO,
                  arguments: 1,
                ),
                isDense: true,
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: professionController,
                hintText: Strings.LOCATION,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.INTRO,
                  arguments: 0,
                ),
                isDense: true,
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const Spacer(),
              BlocConsumer<EditProfileCubit, EditProfileState>(
                listener: (context, state) {
                  if (state is EditProfileFailure) {
                    Utils.showSnackBar(context, state.error!);
                  } else if (state is EditProfileSuccess) {
                    Utils.showSnackBar(context, "Updated profile!");
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.HOME,
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<EditProfileCubit>(context).EditProfile(
                          name: fullNameController.text.trim(),
                          phone: phoneController.text.trim(),
                        );
                      },
                      child: state is EditProfileLoading
                          ? const Loader()
                          : const Text(
                              Strings.UPDATE,
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
