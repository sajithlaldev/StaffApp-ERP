import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import '../../models/profession.dart';

class IntroRepository {
  Future updateIntroFields({
    required String location,
    required String position,
    required List<Profession> profession,
  }) async {
    //inserting location info
    GeoFirestore geoFirestore =
        GeoFirestore(FirebaseFirestore.instance.collection('staffs'));

    GeoPoint point = GeoPoint(double.parse(position.split(",")[0]),
        double.parse(position.split(",")[1]));

    await geoFirestore.setLocation(
        FirebaseAuth.instance.currentUser!.email!, point);

    //inserting location name and professions
    Map<String, dynamic> data = {
      "location": location,
      "professions": profession.map((e) => e.toMap()).toList(),
    };
    await FirebaseFirestore.instance
        .collection("staffs")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update(
          data,
        );
  }

  Future updateProvider(Map<String, dynamic> provider) async {
    await FirebaseFirestore.instance
        .collection("providers")
        .doc(provider['email'])
        .update(provider);
  }

  Future<List<Profession>> fetchProfessions() async {
    return (await FirebaseFirestore.instance.collection("professions").get())
        .docs
        .map((e) => Profession.fromMap(e.data()))
        .toList();
  }
}
