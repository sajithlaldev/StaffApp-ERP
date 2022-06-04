import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/utils.dart';
import '../../models/shift.dart';

class PastShiftsRepository {
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

    if (filters != null && filters.isNotEmpty) {
      List finalFilters = [];
      for (var element in filters) {
        // for from date and time

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

    // Shift.fromMap(Map<String, dynamic>.from(e)
  }
}
