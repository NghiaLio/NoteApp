import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc/Events/HomeEvent.dart';
import 'package:flutter_application_1/Bloc/States/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/Events/openDrawer.dart';

class folderScreen extends StatelessWidget {
  Function()? openDrawer;
  folderScreen({super.key, this.openDrawer});

  @override
  Widget build(BuildContext context) {
    final isOpenDrawer = context.read<Opendrawer>().state;
    return GestureDetector(
      onTap: isOpenDrawer ? openDrawer : null,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: isOpenDrawer ? null : openDrawer,
                  icon:  Icon(
                    Icons.menu,
                    size: 30,
                    color: Theme.of(context).colorScheme.surface,
                  )),
              Expanded(
                  child: Center(
                    child: Text(
                      'Mở menu để xem thư mục',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surface),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
