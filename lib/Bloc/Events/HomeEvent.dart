import 'package:flutter_application_1/Models/Data/folder.dart';
import 'package:flutter_application_1/Models/Repo/Database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/Data/note.dart';
import '../States/HomeState.dart';

class homeEvent extends Cubit<Home_state>{
  noteDatabase _noteDatabase = noteDatabase.instance;

  List<note>? _listData;
  homeEvent(): super(initialHome());

  List<note>? get listData => _listData;

  Future<void> getAllNoteData(String orderBy, String nameScreen) async{
    try{
      emit(loadingHome());
      final dataAll = await _noteDatabase.readAllNote(orderBy);
      if(dataAll != null){
        _listData = dataAll;
         emit(loadedHome(dataAll));
      }else{
        _listData = [];
        emit(loadedHome(null));
      }
      print('object');
    }catch(e){
      print(e);
    }
  }

  //delete note
  Future<void> deleteNote(int id) async{
    try{
      final x = await _noteDatabase.deleteNote(id);
      if(x != 0){
        emit(deleteSucces());
      }
    }catch(e){
      throw Exception('delete failed');
    }
  }

  Future<void> deleteAll() async{
    try{
      final x = await _noteDatabase.deleteAllNote();
      if(x != 0){
        emit(deleteSucces());
      }
    }catch(e){
      throw Exception('delete failed');
    }
  }
  //update lock
  Future<void> updateLock(note noteData) async{
    try{
      final note noteUpdate = note(
          id: noteData.id,
          content: noteData.content,
          date: noteData.date,
          date_change: noteData.date_change,
          isFavorite: noteData.isFavorite,
          isLock: true,
          isDelete: noteData.isDelete,
          localFolder: noteData.localFolder,
          password:'admin' ,
          title: noteData.title
      );
      final code = await _noteDatabase.updateNote(noteUpdate);
      if(code != 0){
        emit(updateSucees());
      }
    }catch(e){
      throw Exception('update failes');
    }
  }
  
  //update favorite
  Future<void> updateFavorite(note noteData) async{
    try{
      final note noteUpdate = note(
          id: noteData.id,
          content: noteData.content,
          date: noteData.date,
          date_change: noteData.date_change,
          isFavorite: true,
          isLock: noteData.isLock,
          isDelete: noteData.isDelete,
          localFolder: noteData.localFolder,
          password:'admin' ,
          title: noteData.title
      );
      final code = await _noteDatabase.updateNote(noteUpdate);
      if(code != 0){
        emit(updateSucees());
      }
    }catch(e){
      throw Exception('update failes');
    }
  }

  //update delete
  Future<void> updateDelete(note noteData) async{
    try{
      final note noteUpdate = note(
          id: noteData.id,
          content: noteData.content,
          date: noteData.date,
          date_change: noteData.date_change,
          isFavorite: noteData.isFavorite,
          isLock: noteData.isLock,
          isDelete:true,
          localFolder: noteData.localFolder,
          password:'admin' ,
          title: noteData.title
      );
      final code = await _noteDatabase.updateNote(noteUpdate);
      if(code != 0){
        emit(updateSucees());
      }
    }catch(e){
      throw Exception('update failes');
    }
  }

  //update local_folder
  Future<void> updateLocalFolder(note noteData, folder dataFolder)async{
    try{
      final note noteUpdate = note(
          id: noteData.id,
          content: noteData.content,
          date: noteData.date,
          date_change: noteData.date_change,
          isFavorite: noteData.isFavorite,
          isLock: noteData.isLock,
          isDelete:noteData.isDelete,
          localFolder: dataFolder.id,
          password:'admin' ,
          title: noteData.title
      );
      final code = await _noteDatabase.updateNote(noteUpdate);
      if(code != 0){
        emit(updateSucees());
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> closeDB () async{
    await _noteDatabase.closedb();
  }
}