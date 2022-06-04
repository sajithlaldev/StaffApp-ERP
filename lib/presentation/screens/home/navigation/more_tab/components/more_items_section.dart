import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/routes.dart';
import '../../../../../../utils/strings.dart';
import '../../../../../../utils/styles.dart';
import '../../../../../common/default_cofirmation_popup.dart';

class MoreItemsSection extends StatelessWidget {
  const MoreItemsSection({Key? key}) : super(key: key);

  showFinishPopup(BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) => DefaultConfirmationPopup(
        title: Strings.LOGOUT,
        caption: Strings.LOGOUT_CAPTION,
        yesText: Strings.LOGOUT,
        noText: Strings.CANCEL,
        yesFunction: () {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            Routes.LOGIN,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Constants.MoreItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == 1) {
                showFinishPopup(context);
              }

              if (index == 0) {
                Navigator.pushNamed(
                  context,
                  Routes.CONTACT_US,
                );
              }
            },
            child: Container(
              decoration: Styles.boxDecoration(
                true,
                cornerRadius: 4,
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      Constants.MoreItems[index],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                    size: 36,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
