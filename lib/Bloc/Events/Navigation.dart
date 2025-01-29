import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/Repo/SharePreferences.dart';
import '../States/NavigationState.dart';



class NavigationCubit extends Cubit<NavigationState> {
  final List<bool> _backGroundItemFunction = [false, false,false, false, false];
  NavigationCubit() : super(initialNavigator());

  final repoRefs = repoSharePreferences();

  List<bool> get backGroundItemFunction => _backGroundItemFunction;

  Future<void> getCurrentIndex() async{
    emit(loadNavigator());
    final index = await repoRefs.getNavigator();
    final currentIndex= index ?? 0;
    for (int i = 0; i < _backGroundItemFunction.length; i++) {
      _backGroundItemFunction[i] = i == currentIndex;
    }
    emit(loadedNavigator(currentIndex));
  }

  void nextScreen(int index)async {
    for (int i = 0; i < _backGroundItemFunction.length; i++) {
      _backGroundItemFunction[i] = i == index;
    }
    await repoRefs.setNavigatior(index);
    emit(loadedNavigator(index));

  }
}
