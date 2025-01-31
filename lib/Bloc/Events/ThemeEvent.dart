import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Theme/ThemeData.dart';

import '../../Models/Repo/SharePreferences.dart';

class themeState {
  ThemeData themeData;
  themeState(this.themeData);
}

class themeEvent extends Cubit<themeState>{

  themeEvent(): super(themeState(lightMode));
  final repoRefs = repoSharePreferences();

  ThemeData? _themeData;

  ThemeData? get themeData => _themeData;

  Future<void> getTheme() async{
    String result = await repoRefs.getTheme() ?? '';
    if(result == 'lightMode'){
      _themeData = lightMode;
      emit(themeState(lightMode));
    }else if(result == 'darkMode'){
      _themeData = darkMode;
      emit(themeState(darkMode));
    }
  }

  void changeTheme(ThemeData theme)async{
    if(theme ==  lightMode){
      _themeData = lightMode;
      await repoRefs.setTheme('lightMode');
      emit(themeState(lightMode));
    }else{
      _themeData = darkMode;
      await repoRefs.setTheme('darkMode');
      emit(themeState(darkMode));
    }
  }
}