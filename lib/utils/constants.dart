// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:hiftapp/data/models/home_grid_item.dart';
import 'package:hiftapp/utils/assets.dart';
import 'package:hiftapp/utils/routes.dart';
import 'package:hiftapp/utils/strings.dart';

class Constants {
  static const BOTTOM_NAV_ITEMS = [
    'Home',
    'My Shifts',
    'Available Shifts',
    'More'
  ];

  static const TC = "https://shiftcover.co.uk/terms/";
  static const PP = "https://shiftcover.co.uk/privacy-policy/";
  static const FAQ = "";
  static const CU = "https://shiftcover.co.uk/contact/";

  static const shareSubject = 'Shift App Invitation';
  static const shareMessage =
      'Check out Shift App \nAndroid: ${Constants.playStoreUrl}\niOS: ${Constants.appStoreUrl}';

  static const playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.shiftventures.shiftapp";
  static const appStoreUrl =
      "https://apps.apple.com/in/app/freechat-for-whatsapp/id1084346074?mt=12";

  static const mGoogleMapsKey = "AIzaSyDpkWi89Sz-JLd56mj4gtZ6WPfkhMh7SV0";

  static final HOME_GRID_ITEMS = [
    HomeGridItem(
      icon: Assets.ENROLLMENT_KEY,
      title: Strings.ATTENDENCE,
      route: Routes.ATTENDENCE,
    ),
    HomeGridItem(
      icon: Assets.PROVIDERS,
      title: Strings.PROVIDERS,
      route: Routes.PROVIDERS,
    ),
    HomeGridItem(
      icon: Assets.MY_SHIFTS,
      title: Strings.PAST_SHIFTS,
      route: Routes.PAST_SHIFTS,
    ),
    HomeGridItem(
      icon: Assets.TIMESHEETS,
      title: Strings.TIMESHEETS,
      route: Routes.TIMESHEETS,
    ),
  ];

  static const List weeks = [
    "S",
    "M",
    "T",
    "W",
    "T",
    "F",
    "S",
  ];
  static const List weeks2 = [
    "M",
    "T",
    "W",
    "T",
    "F",
    "S",
    "S",
  ];

  static const List MoreItems = [
    Strings.CONTACT_US,
    Strings.LOGOUT,
  ];
}
