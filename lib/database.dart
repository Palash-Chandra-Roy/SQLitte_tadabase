
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sq_lite/notes_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db =await initDatabase();
    return _db;
  }
  initDatabase () async {
    io.Directory docusentDirectory =await getApplicationDocumentsDirectory();
    String path= join(docusentDirectory.path,'notes.db');
    var db = await openDatabase(path,version:1,onCreate: _onCreate);
    return db ;
  }
  _onCreate (Database db, int version) async{
    await db.execute(
      "CRATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT NOT NULL, gmail TEXT )",
    );
  }
  Future<NotesModel>insert(NotesModel notesModel)async{
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }
  Future<List<NotesModel>> getNotesList()async{
    var dbClient =await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
    
  }
  Future<int> delete(int id)async{
  var dbClient=await db;
  return await dbClient!.delete(
    'notes',
    where: 'id =?',
    whereArgs: [id]
  );
  }
  Future<int>update(NotesModel notesModel)async{
    var dbClient =await db;
    return await dbClient!.update(
      'notes',
      notesModel.toMap(),
      where: 'id=?',
      whereArgs: [notesModel.id]
    );
  }

}