import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zeno_health/model/inventory.dart';
import 'package:zeno_health/model/user.dart';
import 'package:zeno_health/utils/helper.dart';

import '../model/user_inventory.dart';

class DataBase {
  Future<Database> initializedDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'zeno_health.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE inventory("
          "id INTEGER PRIMARY KEY , "
          "item_name TEXT NOT NULL,"
          "path TEXT NOT NULL,"
          "qty INTEGER NOT NULL,"
          "UNIQUE (id) ON CONFLICT IGNORE)",
        );

        await db.execute(
          "CREATE TABLE user_inventory("
          "id INTEGER PRIMARY KEY , "
          "item_id INTEGER NOT NULL,"
          "user_id INTEGER NOT NULL,"
          "item_name TEXT NOT NULL,"
          "path TEXT NOT NULL,"
          "qty INTEGER NOT NULL)",
        );

        await db.execute(
          "CREATE TABLE user("
          "id INTEGER PRIMARY KEY , "
          "user_name TEXT NOT NULL,"
          "password TEXT NOT NULL,"
          "age INTEGER NOT NULL)",
        );
      },
    );
  }

// insert data to inventory table
  Future<int> insertInventory(List<Inventory> inventory) async {
    int result = 0;
    final Database db = await initializedDB();
    for (var inventory_ in inventory) {
      result = await db.insert('inventory', inventory_.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  // insert data to user table
  Future<int> insertUser(List<User> user) async {
    int result = 0;
    final Database db = await initializedDB();
    for (var user_ in user) {
      result = await db.insert('user', user_.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

  // insert data to user inventory table
  Future<int> insertUserInventory(List<UserInventory> inventory) async {
    int result = 0;
    final Database db = await initializedDB();
    for (var inventory_ in inventory) {
      result = await db.insert('user_inventory', inventory_.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }

// retrieve all data from inventory table
  Future<List<Inventory>> retrieveInventory() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('inventory');
    return queryResult.map((e) => Inventory.fromMap(e)).toList();
  }

  // retrieve data getAllUsers
  Future<List<User>> getAllUsers() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('user');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  // retrieve data getInventoryAsPerUser
  Future<List<UserInventory>> getInventoryAsPerUser() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'user_inventory',
      where: 'user_id = ?',
      whereArgs: [AppString().user_id],
    );

    // raw query
    //final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM user_inventory WHERE user_id=?', [100]);

    return queryResult.map((e) => UserInventory.fromMap(e)).toList();
  }

// delete inventory as per id
  Future<void> removeUserInventoryAsPerId(int id) async {
    final db = await initializedDB();
    await db.delete(
      'user_inventory',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
