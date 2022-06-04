import 'package:flutter/material.dart';
import '../../../../common/refer_widget.dart';
import 'components/profile_section.dart';
import 'components/more_items_section.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
        maxWidth: double.infinity,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 150,
              child: ProfileSection(),
            ),
            MoreItemsSection(),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
