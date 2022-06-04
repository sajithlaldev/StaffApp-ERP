import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/authentication/cubit/authentication_cubit.dart';
import '../common/widgets.dart';
import '../screens/contact_us/contactus_screen.dart';
import '../screens/faq/faq_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/past_shifts/past_shifts_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/shift_confirmation/shift_confirmation_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/signup/verify_screen.dart';
import '../screens/timesheet/timesheet_screen.dart';
import '../screens/webview_screen/webview_screen.dart';

import '../../data/models/shift.dart';
import '../../utils/routes.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(builder: (context) {
          BlocProvider.of<AuthenticationCubit>(context).checkAuthentication();
          return BlocConsumer<AuthenticationCubit, AuthenticationState>(
            listenWhen: (previous, current) =>
                current is AuthenticationSuccess && current.staff == null,
            listener: (context, state) {
              if (state is AuthenticationSuccess && state.staff == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'You are not registered as Staff! Please register before login.',
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthenticationSuccess) {
                if (state.staff == null) {
                  BlocProvider.of<AuthenticationCubit>(context).logout();

                  return const LoginScreen();
                } else {
                  return HomeScreen();
                }
              } else if (state is AuthenticationFailure) {
                return const LoginScreen();
              } else {
                return const SplashScreen();
              }
            },
          );
        });

      case Routes.LANDING:
        return MaterialPageRoute(
          builder: (context) => const LandingScreen(),
        );
      case Routes.VERIFY:
        return MaterialPageRoute(
          builder: (context) => const VerifyScreen(),
        );

      case Routes.REGISTER:
        return MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        );
      case Routes.LOGIN:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

      case Routes.PAST_SHIFTS:
        return MaterialPageRoute(
          builder: (context) => const PastShiftsScreen(),
        );
      case Routes.CONFIRMATION:
        Shift shift = settings.arguments as Shift;
        return MaterialPageRoute(
          builder: (context) => ShiftConfirmationScreen(shift: shift),
        );
      case Routes.NOTIFICATIONS:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );
      case Routes.TIMESHEET:
        if (settings.arguments.runtimeType == Shift) {
          Shift shift = settings.arguments as Shift;
          return MaterialPageRoute(
            builder: (context) => TimeSheetScreen(
              shift: shift,
            ),
          );
        } else {
          var shift = settings.arguments as dynamic;
          return MaterialPageRoute(
            builder: (context) => TimeSheetScreen(
              shiftId: shift['shiftId'],
            ),
          );
        }

      case Routes.PROFILE:
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );
      case Routes.WEBVIEW:
        String url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => CustomWebviewScreen(
            url: url,
          ),
        );
      case Routes.ATTENDENCE:
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );
      case Routes.CONTACT_US:
        return MaterialPageRoute(
          builder: (context) => ContactUsScreen(),
        );
      case Routes.FAQ:
        return MaterialPageRoute(
          builder: (context) => const FaqScreen(),
        );

      default:
        throw Exception('Route not found!');
    }
  }
}
