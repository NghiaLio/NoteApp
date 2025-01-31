import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc/Events/ThemeEvent.dart';
import 'Bloc/Events/LayoutCubit.dart';
import 'Bloc/Events/ManageFolderCubit.dart';
import 'Views/mainHome.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'Bloc/Events/HomeEvent.dart';
import 'Bloc/Events/Navigation.dart';
import 'Bloc/Events/NoteScreenEvent.dart';
import 'Bloc/Events/SortNote.dart';
import 'Bloc/Events/openDrawer.dart';


void main()async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>themeEvent()..getTheme()),
        BlocProvider(create: (create) => Opendrawer(false)),
        BlocProvider(create: (create) => NavigationCubit()),
        BlocProvider(create: (create)=> homeEvent()),
        BlocProvider(create: (create)=>noteScreenEvent()),
        BlocProvider(create: (create)=>SortCubit()),
        BlocProvider(create: (create)=>LayoutCubit()),
        BlocProvider(create: (create)=>manageFolderCubit()..getAllFolder()),
      ],
      child: BlocBuilder<themeEvent,themeState>(
        builder: (context,state) {
          ThemeData _theme = state.themeData;
          return MaterialApp(
              home:const Mainhome(),
            theme: _theme,
          );
        }
      ),
    );
  }
}
