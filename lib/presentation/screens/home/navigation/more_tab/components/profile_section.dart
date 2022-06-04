import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../logic/authentication/cubit/authentication_cubit.dart';
import '../../../../../../logic/completed_shifts_count/cubit/completed_shifts_count.dart';

import '../../../../../../utils/routes.dart';
import '../../../../../../utils/strings.dart';

import '../../../../../../utils/assets.dart';
import '../../../../../../utils/styles.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AuthenticationSuccess? authState =
        context.read<AuthenticationCubit>().state as AuthenticationSuccess;

    return Stack(
      children: [
        Positioned.fill(
          left: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 8,
            ),
            decoration: Styles.boxDecoration(false),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        Styles.boxShadow,
                      ],
                      image: const DecorationImage(
                        image: AssetImage(
                          Assets.DEFAULT_STAFF,
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset(Assets.USER),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.46,
                            ),
                            child: Text(
                              authState.staff?.name ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.PROFILE,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 15,
                            height: 15,
                            child: Image.asset(Assets.MAIL),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.5,
                            ),
                            child: Text(
                              authState.staff?.email ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 15,
                              height: 15,
                              child: Image.asset(Assets.BADGE)),
                          const SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<CompletedShiftsCountCubit,
                              CompletedShiftsCountState>(
                            builder: (context, state) {
                              return Text(
                                '${state.count}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                              );
                            },
                          ),
                          Text(
                            ' Tasks done',
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 30,
          child: SizedBox(
            height: 25,
            width: 100,
            child: Container(
              decoration: Styles.boxDecoration(
                false,
                elevation: 0,
                spreadRadius: 2,
                cornerRadius: 8,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 10,
                  ),
                  child: Text(
                    Strings.MY_PROFILE,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
