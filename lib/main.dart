import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc/Events/ThemeEvent.dart';
import 'Bloc/Events/LayoutCubit.dart';
import 'Bloc/Events/ManageFolderCubit.dart';
import 'Theme/ThemeData.dart';
import 'Views/mainHome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/Events/HomeEvent.dart';
import 'Bloc/Events/Navigation.dart';
import 'Bloc/Events/NoteScreenEvent.dart';
import 'Bloc/Events/SortNote.dart';
import 'Bloc/Events/openDrawer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>themeEvent(lightMode)),
        BlocProvider(create: (create) => Opendrawer(false)),
        BlocProvider(create: (create) => NavigationCubit()),
        BlocProvider(create: (create)=> homeEvent()),
        BlocProvider(create: (create)=>noteScreenEvent()),
        BlocProvider(create: (create)=>SortCubit()),
        BlocProvider(create: (create)=>LayoutCubit()),
        BlocProvider(create: (create)=>manageFolderCubit()..getAllFolder()),
      ],
      child: BlocBuilder<themeEvent,ThemeData>(
        builder: (context,state) {
          ThemeData _theme = state;
          return MaterialApp(
              home:const Mainhome(),
            theme: _theme,
          );
        }
      ),
    );
  }
}
