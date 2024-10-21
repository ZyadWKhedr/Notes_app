import 'dart:core';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqll/model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableNotes (
      ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,  
      ${NoteFields.isImportant} BOOLEAN NOT NULL,
      ${NoteFields.number} INTEGER NOT NULL,
      ${NoteFields.title} TEXT NOT NULL,
      ${NoteFields.description} TEXT NOT NULL,
      ${NoteFields.createdTime} TEXT NOT NULL
    )
    ''');
  }

  // Create Note
  Future<Note> createNote(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toMap());
    return note.copyWith(id: id);
  }

  // Read Note
  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: [
        NoteFields.id,
        NoteFields.isImportant,
        NoteFields.number,
        NoteFields.title,
        NoteFields.description,
        NoteFields.createdTime,
      ],
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Update Note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      tableNotes,
      note.toMap(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  // Read All Notes
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // Delete Specific Note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Delete All Notes
  Future<int> deleteAllNotes() async {
    final db = await instance.database;
    return await db.delete(tableNotes);
  }

  // Close Database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
