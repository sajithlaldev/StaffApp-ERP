import 'package:flutter/material.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../utils/styles.dart';

import '../../../utils/routes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                WelcomeSection(),
                ButtonsSection(),
                BottomSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      children: [
        Image.asset(
          Assets.LOGO,
        ),
        SizedBox(
          height: _size.height * 0.025,
        ),
        Text(
          Strings.WELCOME_MESSAGE_TITLE,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(
          height: _size.height * 0.03,
        ),
        Text(
          Strings.WELCOME_MESSAGE,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: _size.height * 0.15,
        ),
      ],
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.REGISTER,
              );
            },
            child: const Text(
              Strings.SIGNUP,
            ),
          ),
        ),
        SizedBox(
          height: _size.height * 0.055,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: Styles.SECONDARY_ELEVATED_BUTTON_THEME,
            onPressed: () {},
            child: const Text(
              Strings.GUEST,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
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
        Row(
          children: [
            const Spacer(),
            Checkbox(
              value: true,
              onChanged: (val) {},
              checkColor: AppColors.accent,
              fillColor: MaterialStateProperty.all(Colors.white),
            ),
            Text(
              Strings.I_AGREE,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                Strings.TC.toLowerCase(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: _size.height * 0.06,
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
                Navigator.pushReplacementNamed(
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
