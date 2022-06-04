import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/faq.dart';

import 'package:http/http.dart' as http;

import '../../../utils/constants.dart';
import '../../models/profession.dart';
import '../../models/service_provider.dart';
import '../../models/staff.dart';

class CommonRepository {
  Future<Map<String, List<String>>> getProviders() async {
    List<ServiceProvider> providers =
        (await FirebaseFirestore.instance.collection("providers").get())
            .docs
            .map(
              (e) => ServiceProvider.fromMap(
                e.data(),
              ),
            )
            .toList();

    List<String> types = providers.map((e) => e.type).toSet().toList();
    List<String> locations = providers.map((e) => e.city).toSet().toList();
    List<String> service_providers =
        providers.map((e) => e.name).toSet().toList();

    return {
      "types": types,
      "locations": locations,
      "service_providers": service_providers,
    };
  }

  Future<Map<String, List<String>>> getStaffs() async {
    List<Staff> staffs =
        (await FirebaseFirestore.instance.collection("staffs").get())
            .docs
            .map(
              (e) => Staff.fromMap(
                e.data(),
              ),
            )
            .toList();

    List<String> staffsFinal = staffs.map((e) => e.name).toSet().toList();

    return {
      "staffs": staffsFinal,
    };
  }

  Future<List<Profession>> getPrefessions() async {
    List<Profession> prefessions =
        (await FirebaseFirestore.instance.collection("professions").get())
            .docs
            .map(
              (e) => Profession.fromMap(
                e.data(),
              ),
            )
            .toList();

    return prefessions;
  }

  Future<String> getCityFromPostCode(String postcode) async {
    var res = await http.get(
      Uri.parse("https://api.postcodes.io/postcodes/$postcode"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['result']['admin_district'];
    } else {
      throw Exception("Invalid Postcode!");
    }
  }

  Future<LatLng> getLatLngFromPlaceId(String placeId) async {
    // http.Response res = await http.get(
    //   Uri.parse(
    //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Strings.GOOGLE_MAP_API_KEY}'),
    // );

    var res = jsonDecode((await http.get(Uri.parse(
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constants.mGoogleMapsKey}')))
        .body);

    double lat = res['result']['geometry']['location']['lat'];
    double lng = res['result']['geometry']['location']['lng'];

    return LatLng(lat, lng);
  }

  sendEmail(String subject, String message, String to, Staff staff) async {
    await FirebaseFirestore.instance.collection("contact").doc().set({
      "message": message,
      "subject": subject,
      "to": to,
      "created_on": DateTime.now().toString(),
      "created_by": FirebaseAuth.instance.currentUser!.email,
      "created_by_name": staff.toMap(),
    });
  }

  Future<List<FaqModel>> loadFaqs() async {
    final res = (await FirebaseFirestore.instance
            .collection("faqs")
            .orderBy(
              "created_on",
              descending: true,
            )
            .get())
        .docs
        .map((e) => FaqModel.fromMap(e.data()))
        .toList();
    return res;
  }
}
