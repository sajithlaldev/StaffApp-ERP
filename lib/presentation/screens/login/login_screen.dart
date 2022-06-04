import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiftapp/utils/styles.dart';
import '../../../logic/login/cubit/login_cubit.dart';
import '../../common/default_textfield.dart';
import '../../common/widgets.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';

import '../../../utils/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                decoration: Styles.boxDecoration(
                  false,
                  bgColor: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleSection(),
                    FieldsSection(),
                    const BottomSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: _size.height * 0.05,
          ),
          Text(
            Strings.LOGIN,
            style: Theme.of(context).textTheme.headline2!,
          ),
          Text(
            Strings.LOGIN_CAPTION,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 12,
                  color: AppColors.lightAccent,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class FieldsSection extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FieldsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSucess) {
          Navigator.pushNamed(
            context,
            Routes.HOME,
          );
        }
        if (state is LoginFailure) {
          if (state.message == "not_verified") {
            Utils.showSnackBar(context,
                "Email not verified! Verification email has sent to your email.");
          } else if (!(state.message.startsWith("e_") ||
              state.message.startsWith("i_"))) {
            Utils.showSnackBar(context, state.message);
          }
        }
      },
      builder: (context, state) {
        String errorText = state is LoginFailure ? state.message : "";

        return Column(
          children: [
            DefaultTextField(
              controller: _emailController,
              hintText: Strings.EMAIL,
              isDense: true,
              errorText: errorText == "e_email"
                  ? "Email cannot be empty!"
                  : errorText == "i_email"
                      ? "Invalid Email!"
                      : null,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 8,
            ),
            DefaultTextField(
              controller: _passwordController,
              hintText: Strings.PASSWORD,
              isDense: true,
              obscure: true,
              errorText:
                  errorText == "e_pass" ? "Password cannot be empty!" : null,
              textInputType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: _size.height * 0.04,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LoginCubit>(context).login(
                      _emailController.text.trim(),
                      _passwordController.text.trim());
                },
                child: state is LoginLoading
                    ? const Loader()
                    : const Text(
                        Strings.LOGIN,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BottomSection extends StatelessWidget {
  const BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          height: _size.height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.NOT_REGISTERED,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 12,
                  ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                Strings.CONTACT_ADMIN,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: _size.height * 0.05,
        ),
      ],
    );
  }
}
