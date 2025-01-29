import 'package:flutter_application_1/Models/Repo/SharePreferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutState{
  final String nameLayout;
  LayoutState(this.nameLayout);
}

class LayoutCubit extends Cubit<LayoutState>{
  LayoutCubit() : super(LayoutState('luoi-vua'));

  Future<void> getLayout() async{
    final String? nameLayout = await repoSharePreferences().getLayout();
    emit(LayoutState(nameLayout ?? 'luoi-vua'));
  }

  Future<void> changeLayout(String? value)async{
    await repoSharePreferences().setLayout(value!);
    if(value == 'luoi-nho'){
      emit(LayoutState(value.toString()));
    }else if(value == 'luoi-vua'){
      emit(LayoutState(value.toString()));
    }else if(value == 'danh-sach'){
      emit(LayoutState(value.toString()));
    }
  }
}