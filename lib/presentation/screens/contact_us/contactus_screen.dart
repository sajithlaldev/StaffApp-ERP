import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../logic/contact_us/cubit/contact_us_cubit.dart';
import '../../common/widgets.dart';
import '../../../utils/colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/utils.dart';

import '../../../data/models/staff.dart';
import '../../../utils/strings.dart';
import '../../common/default_textfield.dart';
import 'components/appbar.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({
    Key? key,
  }) : super(key: key);

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Staff staff =
        (context.read<AuthenticationCubit>().state as AuthenticationSuccess)
            .staff!;

    return BlocProvider(
      create: (context) => ContactUsCubit(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextField(
                controller: subjectController..text,
                hintText: 'Subject',
                isDense: true,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: DefaultTextField(
                  controller: messageController..text,
                  hintText: "Message",
                  textInputType: TextInputType.streetAddress,
                  isColapsed: true,
                  maxLines: 4,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              BlocConsumer<ContactUsCubit, ContactUsState>(
                listener: (context, state) {
                  if (state is ContactUsFailure) {
                    Utils.showSnackBar(context, state.error!);
                  } else if (state is ContactUsSuccess) {
                    Utils.showSnackBar(context, "Message has sent");
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<ContactUsCubit>(context).ContactUs(
                          subject: "Query on \"" +
                              subjectController.text.trim() +
                              "\" From ${staff.name}",
                          message: messageController.text.trim(),
                          staff:staff
                        );
                      },
                      child: state is ContactUsLoading
                          ? const Loader()
                          : const Text(
                              Strings.SEND,
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
