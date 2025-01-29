import 'package:flutter_application_1/Bloc/States/NoteScreenState.dart';

import '../../Models/Repo/Database.dart';

import '../../Models/Data/note.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class noteScreenEvent extends Cubit <NoteScreenState>{

  final noteDatabase _noteDatabase = noteDatabase.instance;
  noteScreenEvent() : super(initialNoteScrenn());

  // create new note
  Future<void> createNote(String content, String title, bool isFavorite,int? localFolder) async{
    try{
      final note inputNote = note(
          id: null,
          content: content,
          date: DateTime.now().toString(),
          date_change: '',
          isFavorite: isFavorite,
          isLock: false,
          isDelete: false,
          localFolder: localFolder,
          password: '',
          title: title
      );
      await _noteDatabase.createNote(inputNote);
    }catch(e){
      throw Exception('create failed');
    }
  }

  //update note
  Future<void> updateNote(String content, String title, bool isFavorite, int? localFolder,note noteData)async{
    try{
      final note noteUpdate = note(
          id: noteData.id,
          content: content,
          date: noteData.date,
          date_change: DateTime.now().toString(),
          isFavorite: isFavorite,
          isLock: noteData.isLock,
          isDelete: noteData.isDelete,
          localFolder: localFolder?? noteData.localFolder,
          password: noteData.password,
          title: title
      );
      final x = await _noteDatabase.updateNote(noteUpdate);
      print(x);
    }catch(e){
      throw Exception('update failed');
    }
  }
}