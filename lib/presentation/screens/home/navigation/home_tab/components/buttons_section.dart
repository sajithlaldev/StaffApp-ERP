import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../data/models/service_provider.dart';
import '../../../../../../logic/bottom_nav/bottom_nav_cubit.dart';
import '../widgets/grid_item.dart';
import '../../../../../../utils/constants.dart';

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: Constants.HOME_GRID_ITEMS.length,
      itemBuilder: (context, index) {
        final item = Constants.HOME_GRID_ITEMS[index];
        return GestureDetector(
          onTap: () async {
            var res = await Navigator.pushNamed(
              context,
              item.route!,
            );
            if (res != null) {
              BlocProvider.of<BottomNavsCubit>(context).onBottomNavSwitch(
                2,
                provider: res as ServiceProvider,
              );
            }
          },
          child: GridItem(
            title: item.title,
            icon: item.icon,
            count: item.count,
          ),
        );
      },
    );
  }
}
