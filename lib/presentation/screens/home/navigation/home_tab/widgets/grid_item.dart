import 'package:flutter/material.dart';
import '../../../../../common/badge.dart';
import '../../../../../../utils/styles.dart';

class GridItem extends StatelessWidget {
  final String? count;
  final String title;
  final String icon;
  const GridItem({
    Key? key,
    required this.title,
    required this.icon,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: Styles.boxDecoration(true),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          if (count != null)
            Positioned(
              right: 5,
              top: 5,
              child: Badge(count: count),
            )
        ],
      ),
    );
  }
}
