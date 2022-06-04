import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/bottom_nav/bottom_nav_cubit.dart';
import '../../../logic/completed_shifts_count/cubit/completed_shifts_count.dart';
import 'navigation/available_shifts_tab/available_shifts_tab.dart';
import 'navigation/home_tab/home_tab.dart';
import 'navigation/more_tab/more_tab.dart';
import 'navigation/my_shifts_tab/my_shifts_tab.dart';
import '../../../utils/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  final List<Widget> widgets = [
    HomeTab(),
    MyShiftsTab(),
    AvailableShiftsTab(),
    MoreTab(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<BottomNavsCubit>(context).onBottomNavSwitch(0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => CompletedShiftsCountCubit(),
      child: Scaffold(
        backgroundColor: AppColors.accent,
        bottomNavigationBar: BottomNav(),
        body: SafeArea(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: BlocListener<BottomNavsCubit, BottomNavState>(
                listener: (context, state) {
                  _pageController.jumpToPage(state.currentIndex);
                },
                child: SizedBox(
                  height: size.height,
                  child: PageView(
                    controller: _pageController,
                    children: widgets,
                    onPageChanged: (index) {
                      context.read<BottomNavsCubit>().onBottomNavSwitch(index);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BottomNavsCubit, BottomNavState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.read<BottomNavsCubit>().onBottomNavSwitch(0);
                  },
                  child: BottomNavItem(
                    asset: Assets.HOME,
                    title: Strings.HOME,
                    isSelected: state.currentIndex == 0 ? true : false,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomNavsCubit>().onBottomNavSwitch(1);
                  },
                  child: BottomNavItem(
                    asset: Assets.MY_SHIFTS,
                    title: Strings.MY_SHIFTS,
                    isSelected: state.currentIndex == 1 ? true : false,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomNavsCubit>().onBottomNavSwitch(2);
                  },
                  child: BottomNavItem(
                    asset: Assets.AVAILABLE_SHIFTS,
                    title: Strings.AVAILABLE_SHIFTS,
                    isSelected: state.currentIndex == 2 ? true : false,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomNavsCubit>().onBottomNavSwitch(3);
                  },
                  child: BottomNavItem(
                    asset: Assets.MORE,
                    title: Strings.MORE,
                    isSelected: state.currentIndex == 3 ? true : false,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String asset;
  final bool isSelected;
  final String title;
  const BottomNavItem(
      {Key? key,
      required this.asset,
      required this.title,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          asset,
          color: isSelected
              ? AppColors.bottomNavIconColor
              : AppColors.bottomNavUnselectedIconColor,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: isSelected
                    ? AppColors.bottomNavIconColor
                    : AppColors.bottomNavUnselectedIconColor,
              ),
        )
      ],
    );
  }
}
