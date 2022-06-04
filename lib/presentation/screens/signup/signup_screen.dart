import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/consent_cubit/cubit/consent_cubit.dart';
import '../../common/default_textfield.dart';
import '../../common/error_sheet.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';

import '../../../logic/signup/cubit/signup_cubit.dart';
import '../../../utils/assets.dart';
import '../../common/widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupCubit(),
        ),
        BlocProvider(
          create: (context) => ConsentCubit(),
        )
      ],
      child: Scaffold(
        backgroundColor: AppColors.accent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 1,
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
          Text(
            Strings.SIGNUP,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            Strings.SIGNUP_CAPTION,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class FieldsSection extends StatefulWidget {
  FieldsSection({Key? key}) : super(key: key);

  @override
  State<FieldsSection> createState() => _FieldsSectionState();
}

class _FieldsSectionState extends State<FieldsSection> {
  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();
  final passFocusNode = FocusNode();

  final _fullnameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _cnfpasswordController = TextEditingController();

  preSignup(BuildContext context, bool isGoogleSignIn, {bool? isAppleSignIn}) {
    if (context.read<ConsentCubit>().state.isAgreed) {
      if (isGoogleSignIn) {
        BlocProvider.of<SignupCubit>(context).signUpWithGoogle(
          phone: _phoneController.text.trim(),
          name: _fullnameController.text.trim(),
        );
      } else {
        if (isAppleSignIn != null) {
          BlocProvider.of<SignupCubit>(context).signUpWithApple(
            phone: _phoneController.text.trim(),
            name: _fullnameController.text.trim(),
          );
        } else {
          BlocProvider.of<SignupCubit>(context).signUp(
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            name: _fullnameController.text.trim(),
            password: _passwordController.text.trim(),
            cnfpass: _cnfpasswordController.text.trim(),
          );
        }
      }
    } else {
      showBottomSheet(
        context: context,
        backgroundColor: Colors.black.withOpacity(0.5),
        builder: (context) => buildErrorSheet(
          context,
          errorMessage: Strings.CONSENT_WARNING,
          title: "Error",
        ),
      );
    }
  }

  onPhoneChanged() {
    if (_phoneController.text.length == 10) {
      passFocusNode.requestFocus();
      _phoneController.removeListener(onPhoneChanged);
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(onPhoneChanged);
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          if (state.isGoogleSignUp != null) {
            Navigator.pushNamed(
              context,
              Routes.HOME,
            );
          } else {
            Navigator.pushNamed(
              context,
              Routes.VERIFY,
            );
          }
        }
        if (state is SignupLoaded &&
            state.error != null &&
            !(state.error!.startsWith("e_") || state.error!.startsWith("e_"))) {
          Utils.showSnackBar(context, state.error!);
        }
      },
      builder: (context, state) {
        String errorText = state is SignupLoaded ? state.error ?? "" : "";
        return Column(
          children: [
            DefaultTextField(
              controller: _fullnameController,
              hintText: Strings.FULL_NAME,
              isDense: true,
              errorText: errorText == "e_name" ? "Name cannot be empty" : null,
              textInputType: TextInputType.name,
            ),
            const SizedBox(
              height: 4,
            ),
            DefaultTextField(
              controller: _emailController,
              hintText: Strings.EMAIL,
              isDense: true,
              errorText: errorText == "e_email"
                  ? "Email cannot be empty"
                  : errorText == "i_email"
                      ? "Invalid Email!"
                      : null,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 4,
            ),
            DefaultTextField(
              controller: _phoneController,
              hintText: Strings.PHONE,
              isDense: true,
              prefix: SizedBox(
                width: 5,
                child: Align(
                  alignment: const Alignment(0, -0.05),
                  child: Text(
                    '+44',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              errorText:
                  errorText == "e_phone" ? "Phone cannot be empty" : null,
              textInputType: TextInputType.number,
              maxLength: 10,
            ),
            const SizedBox(
              height: 4,
            ),
            DefaultTextField(
              focusNode: passFocusNode,
              controller: _passwordController,
              hintText: Strings.PASSWORD,
              obscure: true,
              errorText:
                  errorText == "e_pass" ? "Password cannot be empty" : null,
              isDense: true,
              textInputType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 4,
            ),
            DefaultTextField(
              controller: _cnfpasswordController,
              hintText: Strings.CONFIRM_PASSWORD,
              obscure: true,
              isDense: true,
              errorText: errorText == "e_cnfpass"
                  ? "Confirm Password cannot be empty"
                  : errorText == "no_match"
                      ? "Passwords doesn\'t match"
                      : null,
              textInputType: TextInputType.visiblePassword,
            ),
            SizedBox(
              height: _size.height * 0.02,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  preSignup(context, false);
                },
                child: state is SignupLoading
                    ? const Loader()
                    : const Text(
                        Strings.SIGNUP,
                      ),
              ),
            ),
            BlocBuilder<ConsentCubit, ConsentState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: context.read<ConsentCubit>().state.isAgreed,
                      onChanged: (val) {
                        context.read<ConsentCubit>().change(val!);
                      },
                      checkColor: AppColors.accent,
                      fillColor: MaterialStateProperty.all(Colors.white),
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            Strings.I_AGREE,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.WEBVIEW,
                                arguments: Constants.TC,
                              );
                            },
                            child: Text(
                              Strings.TC.toLowerCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                          Text(
                            ' and ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.WEBVIEW,
                                arguments: Constants.PP,
                              );
                            },
                            child: Text(
                              Strings.PP.toLowerCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => preSignup(context, false, isAppleSignIn: true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Image.asset(
                      Assets.APPLE,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () => preSignup(context, true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Image.asset(
                      Assets.GOOGLE,
                    ),
                  ),
                )
              ],
            )
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
          height: _size.height * 0.04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.ALREADY_ACCOUNT,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.LOGIN,
                );
              },
              child: Text(
                Strings.LOGIN,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
