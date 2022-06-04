import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart'
    as encoder; //This import needs to be added in the file this is being done

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';

class Utils {
  static Future<Uint8List> encodeImage(ui.Image image) async {
    int width = image.width;
    int height = image.height;
    ByteData? data = await image.toByteData();
    Uint8List listData = data!.buffer.asUint8List();

    encoder.Image toEncodeImage =
        encoder.Image.fromBytes(width, height, listData);
    encoder.JpegEncoder jpgEncoder = encoder.JpegEncoder();

    List<int> encodedImage = jpgEncoder.encodeImage(toEncodeImage);
    return Uint8List.fromList(encodedImage);
  }

  static String formatDate(String date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);

    return DateFormat("h:mm a, dd MMM, yyyy").format(dateTime);
  }

  static String formatDateOnlyInReadFormat(String date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(date);

    return DateFormat("dd MMM, yyyy").format(dateTime);
  }

  static formatTimeOnly(String date) {
    return date.split(" ")[1].substring(0, 5);
  }

  static double meterToMiles(double meters) {
    return meters * 0.00062137;
  }

  static formatDateOnly(String date) {
    date = date.split(" ")[0].substring(0, 10);
    date = date.split("-")[2] +
        "-" +
        date.split("-")[1] +
        "-" +
        date.split("-")[0];
    return date;
  }

  static int generateRandomNumber() {
    Random rnd;
    int min = 10000;
    int max = 99999;
    rnd = Random();
    return min + rnd.nextInt(max - min);
  }

  static String generateConfirmationNumber() {
    return generateRandomNumber().toString();
  }

  static String getDayOfWeekFromDate(String date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(date);
    switch (dateTime.weekday) {
      case DateTime.sunday:
        return "Sunday";
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      default:
        return "";
    }
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1000 * 12742 * asin(sqrt(a));
  }

  static String getMonth(int m) {
    switch (m) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "January";
    }
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  static String getWeekDay(int d) {
    switch (d) {
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
      case 6:
        return "SAT";
      case 7:
        return "SUN";
      default:
        return "MON";
    }
  }

  static int getDaysInMonth(int year, int month) {
    final firstDay = DateTime.utc(year, month, 1).weekday;

    List days = [
      31 + firstDay,
      -1,
      31 + firstDay,
      30 + firstDay,
      31 + firstDay,
      30 + firstDay,
      31 + firstDay,
      31 + firstDay,
      30 + firstDay,
      31 + firstDay,
      30 + firstDay,
      31 + firstDay
    ];

    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      if (isLeapYear) return 29 + firstDay;
      return 28 + firstDay;
    }
    return days[month - 1];
  }
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '-');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

class TimeTextFormatter extends TextInputFormatter {
  static const _maxChars = 4;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, ':');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
