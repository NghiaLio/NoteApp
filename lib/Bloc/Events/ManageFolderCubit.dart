import 'package:flutter_application_1/Models/Data/folder.dart';
import 'package:flutter_application_1/Models/Repo/Database.dart';

import '../States/ManageFolderState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class manageFolderCubit extends Cubit<manageFolderState>{
  manageFolderCubit() : super(initialManage());

  final noteDatabase _noteDatabase = noteDatabase.instance;
  List<folder>? _listFolder;

  List<folder>? get listFolder => _listFolder;

  //get listFolder
  Future<void> getAllFolder() async{
    try{
      final data = await _noteDatabase.readAllFolder();
      if(data != null){
        _listFolder = data;
        emit(loadedManage(data));
      }else{
        _listFolder = [];
        emit(loadedManage(null));
      }
    }catch(e){
      emit(errorLoad());
    }
  }

  //create folder
  Future<void> createFolder(String name, String color) async{
    try{
      final folder dataFolder = folder(
          id: null,
          name: name,
          color: color
      );
      await _noteDatabase.createFolder(dataFolder);
    }catch (e){
      throw Exception(e);
    }
  }
  //update folder
  Future<void> updateFolder(folder dataFolder) async{
    final folder folderUpdate = folder(id: dataFolder.id, name: dataFolder.name, color: dataFolder.color);
    final res = await _noteDatabase.updateFolder(folderUpdate);
    if(res != 0){
      print('update success');
    }else{
      print('fail');
    }
  }
  //deleteFolder
  Future<void> deleteFolder(int id) async{
    try{
      final res = await _noteDatabase.deleteFolder(id);
      if(res != 0){
        print('delete succees');
      }
    }catch(e){
      throw(Exception(e));
    }
  }

  Future<void> deleteAllFolder() async{
    try{
      final res = await _noteDatabase.deleteAllFolder();
      if(res != 0){
        print('delete succees');
      }
    }catch(e){
      throw(Exception(e));
    }
  }
}