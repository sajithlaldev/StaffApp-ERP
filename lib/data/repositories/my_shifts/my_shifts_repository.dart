import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/utils.dart';
import '../../models/shift.dart';
import '../../models/staff.dart';

class MyShiftsRepository {
  Future<List<Shift>> loadShifts(
      {String? date, LatLng? currentLocation}) async {
    print(date);
    Query query = FirebaseFirestore.instance
        .collection("shifts")
        .where(
          "staffId",
          isEqualTo: FirebaseAuth.instance.currentUser!.email,
        )
        .where(
          "status",
          isEqualTo: "confirmed",
        );
    List<Shift> finalShifts = [];
    if (date != null) {
      finalShifts.addAll((await query
              .where(
                "from",
                isGreaterThanOrEqualTo: date.split(" ")[0] + " 00:00",
              )
              .where(
                "from",
                isLessThanOrEqualTo: date.split(" ")[0] + " 23:59",
              )
              .get())
          .docs
          .map((e) => Shift.fromMap(e.data() as Map<String, dynamic>))
          .toList());

      finalShifts.addAll((await query
              .where(
                "till",
                isGreaterThanOrEqualTo: date.split(" ")[0] + " 00:00",
              )
              .where(
                "till",
                isLessThanOrEqualTo: date.split(" ")[0] + " 23:59",
              )
              .get())
          .docs
          .map((e) => Shift.fromMap(e.data() as Map<String, dynamic>))
          .toList());
    }

    Map<String, Shift> mp = {};
    for (var item in finalShifts) {
      mp[item.id!] = item;
    }

    return mp.values.toList().map((e) {
      Shift shift = e;
      if (shift.l != null && shift.l!.isNotEmpty) {
        shift.distance = Utils.calculateDistance(
          shift.l?.first,
          shift.l?.last,
          currentLocation!.latitude,
          currentLocation.longitude,
        );
      }
      return shift;
    }).toList();
  }

  Future<void> completeShift(String id) async {
    await FirebaseFirestore.instance.collection("shifts").doc(id).update(
      {
        "status": "completed",
      },
    );
  }

  Future cancelShift(String shiftId, Staff staff, {String? cNo}) async {
    String confirmationNumber = cNo ?? Utils.generateConfirmationNumber();

    CollectionReference shiftsRef =
        FirebaseFirestore.instance.collection("shifts");
  }
}
