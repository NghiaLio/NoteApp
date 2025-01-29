import '../../Models/Data/note.dart';

abstract class noteOfFolderState{}

class initial extends noteOfFolderState{}

class loading extends noteOfFolderState{}

class loaded extends noteOfFolderState{
  List<note>? listNoteOfFolder;
  loaded(this.listNoteOfFolder);
}

class updateSuccess extends noteOfFolderState{}

class fail extends noteOfFolderState{}