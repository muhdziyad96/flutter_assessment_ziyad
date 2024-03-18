// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_assessment_ziyad/model/user_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'eazymart.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('''
    CREATE TABLE users(
          userid INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          password TEXT,
          gender TEXT,
          image TEXT
      )
      ''');
  }

  Future<Map<String, dynamic>?> getUserLogin(
      String email, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> add(User User) async {
    Database db = await instance.database;
    return await db.insert(
      'users',
      User.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(User User) async {
    Database db = await instance.database;
    return await db.update('users', User.toMap(),
        where: "userid = ?", whereArgs: [User.userid]);
  }
}
