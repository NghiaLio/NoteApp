import 'package:flutter_application_1/Models/Data/folder.dart';

abstract class manageFolderState{}

class initialManage extends manageFolderState{}

class loadingManage extends manageFolderState{}

class loadedManage extends manageFolderState{
  List<folder>? listFolder;
  loadedManage(this.listFolder);
}

class errorLoad extends manageFolderState{}