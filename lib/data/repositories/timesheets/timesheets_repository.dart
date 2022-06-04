import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiftapp/data/models/view_timesheets/expense_entry_model.dart';
import 'package:hiftapp/utils/utils.dart';
import 'package:image/image.dart'
    as encoder; //This import needs to be added in the file this is being done

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/view_timesheets/signatures.dart';
import 'package:intl/intl.dart';

import '../../models/view_timesheets/timesheet.dart';

class TimeSheetsRepository {
  Future addTimesheet(
    TimeSheet timeSheet, {
    required bool isAdd,
    required Signatures signatures,
  }) async {
    if (isAdd) {
      DocumentReference db_reference =
          FirebaseFirestore.instance.collection("timesheets").doc();
      timeSheet.id = db_reference.id;

      String ref = 'timesheets/' + timeSheet.id!;

      if (signatures.shiftSign == null) {
        throw Exception("Shift Authorization signature is missing!");
      }

      //uploading shift auth signature
      timeSheet.shiftEntry!.authorizedBy = await uploadSignature(
        ref + "/shift_auth_signature.jpg",
        await Utils.encodeImage(signatures.shiftSign!),
      );

      //uploading expense auth signature
      int i = 0;
      await Future.forEach(timeSheet.expenseEntries!, (item) async {
        if (timeSheet.expenseEntries![i]!.isDrawn == false) {
          throw Exception("Expense authorization signatures are missing!");
        }
        timeSheet.expenseEntries![i]!.authorizedBy = await uploadSignature(
          ref + "/expense_auth_signature$i.jpg",
          await Utils.encodeImage(await timeSheet
              .expenseEntries![i]!.signatureKey!.currentState!
              .toImage()),
        );
        timeSheet..expenseEntries![i]!.signatureKey = null;
        i++;
      });

      //uploading client auth signature
      if (signatures.clientAuthSign == null) {
        throw Exception("Client signature is missing!");
      }
      timeSheet.clientAuthModel!.signature = await uploadSignature(
        ref + "/client_auth_signature.jpg",
        await Utils.encodeImage(signatures.clientAuthSign!),
      );

      //uploading agency worker signature
      if (signatures.agencyWorkerSign == null) {
        throw Exception("Agency worker signature is missing!");
      }
      timeSheet.agencyWorkerSignature = await uploadSignature(
        ref + "/agency_worker_signature.jpg",
        await Utils.encodeImage(signatures.agencyWorkerSign!),
      );

      //uploading the final timesheet
      await db_reference.set(timeSheet.toMap());

      await FirebaseFirestore.instance
          .collection("shifts")
          .doc(timeSheet.shift_id)
          .update(
        {"status": "completed"},
      );
    } else {
      DocumentReference reference =
          FirebaseFirestore.instance.collection("timesheets").doc(timeSheet.id);
      await reference.update(timeSheet.toMap());
    }
  }

  Future updateShift(Map<String, dynamic> provider) async {
    await FirebaseFirestore.instance
        .collection("shifts")
        .doc(provider['email'])
        .update(provider);
  }

  Future<String> uploadSignature(String ref, Uint8List image) async {
    var reference = FirebaseStorage.instance.ref(ref);

    await reference.putData(image);
    return await reference.getDownloadURL();
  }

  Future<TimeSheet?> loadTimesheet(String shift_id) async {
    var res = (await FirebaseFirestore.instance
        .collection("timesheets")
        .where(
          "shift_id",
          isEqualTo: shift_id,
        )
        .get());
    if (res.docs.isNotEmpty) {
      return TimeSheet.fromMap(res.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<TimeSheet>> loadTimeSheets({
    String? orderBy,
    bool? isDescending,
    List<Map<String, String>>? filters,
  }) async {
    var param = {};

    if (orderBy != null) {
      param['order_by'] = {
        "name": orderBy,
        "is_descending": isDescending != null && isDescending ? 'desc' : 'asc'
      };
    }
    if (filters != null && filters.isNotEmpty) {
      List finalFilters = [];
      for (var element in filters) {
        // for from date and time

        var data = {"name": element['name']!, "value": element['value']};
        finalFilters.add(data);
      }

      param['filters'] = finalFilters;
    }

    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('listTimesheets');
    final results = await callable.call(param);

    return (results.data as List).map((e) {
      return TimeSheet.fromMap(Map<String, dynamic>.from(
        json.decode(
          jsonEncode(e),
        ),
      ));
    }).toList();
  }
}
