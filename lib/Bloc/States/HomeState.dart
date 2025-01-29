
import '../../Models/Data/note.dart';

abstract class Home_state{}

class initialHome extends Home_state{}

class loadingHome extends Home_state{}

class loadedHome extends Home_state{
  List<note>? noteData;
  loadedHome(this.noteData);
}

class loadFailHome extends Home_state{}

class updateSucees extends Home_state{}

class deleteSucces extends Home_state{}