import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Theme/ThemeData.dart';

class themeEvent extends Cubit<ThemeData>{

  themeEvent(super.initialState);

  void changeTheme(ThemeData _themeData){
    if(_themeData ==  lightMode){
      emit(lightMode);
    }else{
      emit(darkMode);
    }
  }
}