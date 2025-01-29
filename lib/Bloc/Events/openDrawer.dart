import 'package:flutter_bloc/flutter_bloc.dart';

class Opendrawer extends Cubit<bool> {
  // bool _openDrawer = false;
  Opendrawer(super.initialState);

  // bool get openDrawer => _openDrawer ;

  void getOpen(){
    emit(true);
  }

  void getClose(){
    emit(false);
  }
}