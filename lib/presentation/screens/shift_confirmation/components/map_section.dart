import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/shift.dart';

class MapSection extends StatelessWidget {
  final Shift shift;

  const MapSection({Key? key, required this.shift}) : super(key: key);

  _launchMap(
      BuildContext context, double? lat, double? lng, String? postcode) async {
    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      if (lat != null) {
        url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
      } else {
        postcode = postcode!.replaceAll(" ", "+");
        url = "https://www.google.com/maps/search/?api=1&query=${postcode}";
      }
      try {
        await launch(url);
      } catch (e) {
        throw Exception("Could not launch $urlAppleMaps : ${e.toString()}");
      }
    } else {
      if (lat != null) {
        urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      } else {
        postcode = postcode!.replaceAll(" ", "+");
        urlAppleMaps = 'https://maps.apple.com/?address=$postcode';
      }
      if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * 0.15,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                    Assets.MAP_SAMPLE,
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              decoration: Styles.boxDecoration(false).copyWith(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.accent,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      fontSize: 16,
                                    ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            shift.customer!.address +
                                ", " +
                                shift.customer!.post_code,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (shift.distance != null && shift.distance != 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  Assets.LOCATION,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  Utils.meterToMiles(shift.distance!)
                                          .toStringAsFixed(2) +
                                      " miles",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                if (shift.status == "confirmed" &&
                                    shift.l != null &&
                                    shift.staff!.email ==
                                        FirebaseAuth
                                            .instance.currentUser!.email) {
                                  _launchMap(context, shift.l!.first,
                                      shift.l!.last, null);
                                } else {
                                  _launchMap(
                                    context,
                                    null,
                                    null,
                                    shift.customer!.post_code,
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text(
                                "View on Map",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
