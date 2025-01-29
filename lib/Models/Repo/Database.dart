import 'dart:convert';

import '../Data/folder.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/note.dart';

class noteDatabase{
  static final noteDatabase instance = noteDatabase._internal();

  static Database? _database;

  noteDatabase._internal();

  static const databaseName = 'note.db';

  static const folderTable = '''
    CREATE TABLE IF NOT EXISTS folder(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color TEXT NOT NULL
    )
  ''';

  static const tableNote = '''
    CREATE TABLE IF NOT EXISTS note(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL,
      title TEXT NOT NULL,
      date TEXT NOT NULL,
      dateChange TEXT NOT NULL,
      isLock INTEGER NOT NULL,
      isDelete INTEGER NOT NULL,
      isFavorite INTEGER NOT NULL,
      password TEXT NOT NULL,
      localFolder INTEGER ,
      FOREIGN KEY (localFolder) REFERENCES folder (id)
    )
  ''';

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase()async{
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$databaseName';
    return await openDatabase(
      path,
      version: 1,
      onCreate:  _createDatabase
    );
  }

  Future<void> _createDatabase(Database db, int version) async{
    // tạo bảng folder
    await db.execute(folderTable);
    //tạo bảng note
    await db.execute(tableNote);
  }


  //create note
  Future createNote(note notedata) async{
    final db = await instance.database;
    final id = await db.insert('note', notedata.toJson());
    return id;
  }

  //create folder
  Future createFolder(folder folderData) async{
    final db = await instance.database;
    final id = await db.insert('folder', folderData.toJson());
    return id;
  }

  // read note
  Future read_a_note(int id) async{
    final db = await instance.database;
    final data_a_note = await db.query(
      'note', where: "id = ?", whereArgs: [id]
    );
    return data_a_note.isNotEmpty ? data_a_note : null;
  }

  Future<List<note>?> readAllNote(String orderBy) async{
    final db = await instance.database;
    final dataAll = await db.query(
        'note',
      orderBy: orderBy
    );
    if(dataAll.isNotEmpty){
      return dataAll.map((json) => note.fromJson(json)).toList();
    }else{
      return null;
    }
  }

  //read folder
  Future<List<folder>?> readAllFolder() async{
    final db = await instance.database;
    final folderAll = await db.query('folder');

    if(folderAll.isNotEmpty){
      return folderAll.map((json)=> folder.fromJson(json)).toList();
    }else {
      return null;
    }
  }
  //update note
  Future<int> updateNote(note noteUpdate) async{
    final db = await instance.database;
    final res = await db.update(
        'note',
        noteUpdate.toJson(),
        where: 'id = ?',
        whereArgs: [noteUpdate.id]
    );
    return res;
  }

  //update folder
  Future<int> updateFolder(folder folderUpdate) async{
    final db = await instance.database;
    final res = db.update('folder',
      folderUpdate.toJson(), where: 'id = ?',
      whereArgs: [folderUpdate.id]
    );
    return res;
  }

  //deleteNote
  Future<int> deleteNote(int id) async{
    final db= await instance.database;
    final res = await db.delete(
      'note',
      where: 'id = ?',
      whereArgs: [id]
    );
    return res;
  }

  Future<int> deleteAllNote() async{
    final db = await instance.database;
    final res = await db.delete('note');
    return res;
  }

  //deleteFolder
  Future<int> deleteFolder(int id) async{
    final db =await instance.database;
    final res = await db.delete(
      'folder',
      where: 'id = ?',
      whereArgs: [id]
    );
    return res;
  }

  Future<int> deleteAllFolder() async{
    final db = await instance.database;
    final res = await db.delete('folder');
    return res;
  }

  //check database
  Future databaseExists() async{
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$databaseName';
    return await databaseFactory.databaseExists(path);
  }
  //close database
  Future<void> closedb() async{
      final db = await instance.database;
      await db.close();
  }
}