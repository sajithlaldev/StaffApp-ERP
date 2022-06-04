import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'logic/authentication/cubit/authentication_cubit.dart';
import 'utils/colors.dart';
import 'utils/styles.dart';

import 'firebase_options.dart';
import 'logic/bottom_nav/bottom_nav_cubit.dart';
import 'presentation/common/widgets.dart';
import 'presentation/router/app_router.dart';
import 'utils/routes.dart';
import 'utils/strings.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");

  showNotification(message);
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'notification',
    'notification',
    channelDescription: 'notification_desc',
    importance: Importance.max,
    priority: Priority.high,
  );
  IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert:
        true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentBadge:
        false, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentSound:
        true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    subtitle: message
        .notification!.body, //Secondary description  (only from iOS 10 onwards)
    threadIdentifier: "notification",
  );
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: 'notification');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const isEMULATOR = true;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());

  if (isEMULATOR) {
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  init(BuildContext context) async {
    //initialize app check
    // await FirebaseAppCheck.instance.activate().onError(
    //       (error, stackTrace) => print(
    //         "Couldn't init app check" + error.toString(),
    //       ),
    //     );

    void onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title ?? ""),
          content: Text(body ?? ""),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.pushNamed(
                  context,
                  Routes.NOTIFICATIONS,
                );
              },
            )
          ],
        ),
      );
    }

    void selectNotification(String? payload) async {
      debugPrint('notification payload: $payload');

      await Navigator.pushNamed(
        context,
        Routes.HOME,
      );
      if (payload != null && payload == "notification") {
        await Navigator.pushNamed(
          context,
          Routes.NOTIFICATIONS,
        );
      }
    }

    //requesting permission for notification
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification}');

      if (message.notification != null) {
        showNotification(message);
      }
    });

    //subscribing to topic
    if (FirebaseAuth.instance.currentUser != null) {
      final topic = FirebaseAuth.instance.currentUser!.uid;

      print("Subscribed to " + topic);
      FirebaseMessaging.instance.subscribeToTopic(topic);
    }

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. notification_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        init(context);
        return BlocProvider(
          create: (context) => AuthenticationCubit(),
          child: BlocProvider(
            create: (context) => BottomNavsCubit(),
            child: MaterialApp(
              title: Strings.APP_NAME,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Nunito Sans',
                backgroundColor: AppColors.accent,
                elevatedButtonTheme: Styles.DEFAULT_ELEVATED_BUTTON_THEME,
                textTheme: Styles.DEFAULT_TEXT_THEME,
              ),
              onGenerateRoute: RouteGenerator.onGenerateRoute,
              initialRoute: Routes.HOME,
            ),
          ),
        );
      },
    );
  }
}
