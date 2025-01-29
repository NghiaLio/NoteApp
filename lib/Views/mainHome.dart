import 'package:flutter/material.dart';
import 'package:flutter_application_1/Views/OfficeView/FolderScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/Events/Navigation.dart';
import '../Bloc/Events/openDrawer.dart';
import '../Bloc/States/NavigationState.dart';
import 'Components/Drawer.dart';
import 'OfficeView/Home.dart';

class Mainhome extends StatefulWidget {
  const Mainhome({super.key});

  @override
  State<Mainhome> createState() => _MainhomeState();
}

class _MainhomeState extends State<Mainhome> {
  @override
  void initState() {
    context.read<NavigationCubit>().getCurrentIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<Opendrawer, bool>(builder: (context, state) {
        final bool isDrawer = state;
        List<Widget> screnn = [
          Home(
            key: const ValueKey(
                0), // đánh dấu đây là các page khác nhau nhưng cùng chung 1 widget
            openDrawer: () {
              if (isDrawer) {
                context.read<Opendrawer>().getClose();
              } else {
                context.read<Opendrawer>().getOpen();
              }
            },
            headerTitle: 'Tất cả ghi chú',
            Screen: 'all',
          ),
          Home(
            key: const ValueKey(
                1), // đánh dấu đây là các page khác nhau nhưng cùng chung 1 widget
            openDrawer: () {
              if (isDrawer) {
                context.read<Opendrawer>().getClose();
              } else {
                context.read<Opendrawer>().getOpen();
              }
            },
            headerTitle: 'Ghi chú bị khóa',
            Screen: 'lock',
          ),
          Home(
            key: const ValueKey(
                2), // đánh dấu đây là các page khác nhau nhưng cùng chung 1 widget
            openDrawer: () {
              if (isDrawer) {
                context.read<Opendrawer>().getClose();
              } else {
                context.read<Opendrawer>().getOpen();
              }
            },
            headerTitle: 'Mục yêu thích',
            Screen: 'favorite',
          ),
          Home(
            key: const ValueKey(
                3), // đánh dấu đây là các page khác nhau nhưng cùng chung 1 widget
            openDrawer: () {
              if (isDrawer) {
                context.read<Opendrawer>().getClose();
              } else {
                context.read<Opendrawer>().getOpen();
              }
            },
            headerTitle: 'Thùng rác',
            Screen: 'cyclebin',
          ),
          folderScreen(
            openDrawer: () {
              if (isDrawer) {
                context.read<Opendrawer>().getClose();
              } else {
                context.read<Opendrawer>().getOpen();
              }
            },
          )
        ];
        return BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            if (state is loadedNavigator) {
              return Stack(
                children: [
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      left: isDrawer
                          ? MediaQuery.of(context).size.width * 0.8
                          : 0,
                      child: screnn[state.currentIndex]),
                  AnimatedPositioned(
                      top: 50,
                      left: !isDrawer
                          ? -MediaQuery.of(context).size.width * 0.8
                          : 0,
                      duration: const Duration(milliseconds: 200),
                      child: HomeDrawer(currentIndexPage: state.currentIndex,))
                ],
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        );
      }),
    );
  }
}
