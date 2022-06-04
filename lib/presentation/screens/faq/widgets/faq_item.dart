import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../data/models/faq.dart';
import '../../../../utils/utils.dart';
import '../../../../../../utils/styles.dart';

class FaqItem extends StatelessWidget {
  final FaqModel faqModel;
  const FaqItem({
    Key? key,
    required this.faqModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 6,
        top: 6,
      ),
      decoration: Styles.boxDecoration(
        true,
      ),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Text(
          faqModel.question ?? "",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
              left: 16,
              right: 16,
            ),
            child: Text(
              faqModel.answer ?? "",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }
}
