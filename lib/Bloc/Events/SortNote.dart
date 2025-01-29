import '../../Models/Repo/SharePreferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortState{
  final String nameSort;
  final String currentSort;
  SortState(this.nameSort, this.currentSort);
}

class SortCubit extends Cubit<SortState>{

  final repoRefs = repoSharePreferences();

  String? _nameSort ;
  String? _currentSort;
  SortCubit() : super(SortState('Tiêu đề', 'DESC'));

  String get currentSort =>  _currentSort!;
  String get nameSort => _nameSort!;

  Future<void> getSort() async{
    final result = await repoRefs.getSort();
    _nameSort = result[0] ?? 'Tiêu đề';
    _currentSort = result[1] ?? 'DESC';
    emit(SortState(_nameSort!, _currentSort!));
  }

  Future<void> changeNameSort(Object value) async{
    if(value == 'Tiêu đề'){
      _nameSort = value.toString();
      await repoRefs.setSort(_nameSort!, _currentSort!);
      emit(SortState(_nameSort!, _currentSort!));
    }else if(value == 'Ngày tạo'){
      _nameSort = value.toString();
      await repoRefs.setSort(_nameSort!, _currentSort!);
      emit(SortState(_nameSort!, _currentSort!));
    }else if(value == 'Ngày sửa đổi'){
      _nameSort = value.toString();
      await repoRefs.setSort(_nameSort!, _currentSort!);
      emit(SortState(_nameSort!, _currentSort!));
    }
  }

  Future<void> changeCurrentSort(String value) async{
    if(value == 'ASC'){
      _currentSort = 'ASC';
      await repoRefs.setSort(_nameSort!, _currentSort!);
      emit(SortState(_nameSort!, _currentSort!));
    }else{
      _currentSort = 'DESC';
      await repoRefs.setSort(_nameSort!, _currentSort!);
      emit(SortState(_nameSort!, _currentSort!));
    }
  }
}