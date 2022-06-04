import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../utils/utils.dart';
import '../../models/shift.dart';
import '../../models/staff.dart';

class AvailableShiftsRepository {
  Future<List<Shift>> loadShifts({
    String? orderBy,
    String? tag,
    bool? isDescending,
    LatLng? currentLocation,
    List<Map<String, String>>? filters,
  }) async {
    var param = {};

    if (orderBy != null) {
      param['order_by'] = {
        "name": orderBy,
        "is_descending": isDescending != null && isDescending ? 'desc' : 'asc'
      };
    }
    //status for available shifts
    param["status"] = "available";
    param["staff"] = FirebaseAuth.instance.currentUser!.email;

    if (filters != null && filters.isNotEmpty) {
      List finalFilters = [];
      for (var element in filters) {
        // for from date and time

        if (element['name'] == 'from') {
          //checking whether has from time
          final fromTime = filters.firstWhere(
              (element) => element['name'] == 'fromTime',
              orElse: () => {});

          element['value'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('dd-MM-yyyy HH:mm').parse(
              element['value'].toString() +
                  " " +
                  (fromTime.keys.isNotEmpty
                      ? fromTime['value'].toString()
                      : "00:00:00.000"),
            ),
          );
        }

        // for till date and time
        if (element['name'] == 'till') {
          //checking whether till date and time is present
          final tillTime = filters.firstWhere(
              (element) => element['name'] == 'tillTime',
              orElse: () => {});

          //checking whether till time is present
          element['value'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('dd-MM-yyyy HH:mm').parse(
              element['value'].toString() +
                  " " +
                  (tillTime.keys.isNotEmpty
                      ? tillTime['value'].toString()
                      : "23:59:59.999"),
            ),
          );
        }

        var data = {"name": element['name']!, "value": element['value']};
        finalFilters.add(data);
      }

      param['filters'] = finalFilters;
    }

    //for retrieving shifts of the particular provider which is enrolled by staff

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('listShifts');
    final results = await callable.call(param);
    return (results.data as List).map((e) {
      Shift shift = Shift.fromMap(Map<String, dynamic>.from(
        json.decode(
          jsonEncode(e),
        ),
      ));

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

  Future assignStaff(String shiftId, Staff staff, {String? cNo}) async {
    String confirmationNumber = cNo ?? Utils.generateConfirmationNumber();

    CollectionReference shiftsRef =
        FirebaseFirestore.instance.collection("shifts");

    if ((await shiftsRef
            .where("confirmation_number", isEqualTo: confirmationNumber)
            .get())
        .docs
        .isNotEmpty) {
      assignStaff(shiftId, staff);
    } else {
      Shift shift = Shift.fromMap(Map<String, dynamic>.from(
          (await shiftsRef.doc(shiftId).get()).data() as Map<String, dynamic>));

      if (shift.staff == null) {
        await shiftsRef.doc(shiftId).update(
          {
            "staffId": staff.email,
            "staffName": staff.name,
            "staff": staff.toMap(),
            "status": "confirmed",
            "confirmation_number": confirmationNumber,
          },
        );
      } else {
        throw Exception("Shift has already assigned to a staff");
      }
    }
  }

  Future expressInterest(String shiftId, Staff staff) async {
    CollectionReference shiftsRef = FirebaseFirestore.instance
        .collection("shifts")
        .doc(shiftId)
        .collection("interested_staffs");
    await shiftsRef.doc(staff.email).set(staff.toMap());
  }

  Future cancelShift(Shift shift, Staff staff) async {
    CollectionReference shiftsRef =
        FirebaseFirestore.instance.collection("shifts");
    CollectionReference adminNotifcations = FirebaseFirestore.instance
        .collection("providers")
        .doc(shift.provider.email)
        .collection("notifications");

    await shiftsRef.doc(shift.id).update(
      {
        "staffId": null,
        "staffName": null,
        "staff": null,
        "status": "pooled",
      },
    );

    await adminNotifcations.doc().set(
      {
        "created_on": DateTime.now().toString(),
        "created_by_name": staff.toMap(),
        "created_by": staff.email,
        "shift": shift.toSmallMap(),
        "type": "shift_cancelled",
      },
    );
  }
}
