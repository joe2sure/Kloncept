import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Item {
  // ignore: non_constant_identifier_names
  final String? course_name;
  final String? lesson;
  final String? link;
  // ignore: non_constant_identifier_names
  final String? save_dir;
  // ignore: non_constant_identifier_names
  final String? file_name;
  // ignore: non_constant_identifier_names
  final String? task_id;

  Item(
      // ignore: non_constant_identifier_names
      {this.course_name,
      this.lesson,
      this.link,
      // ignore: non_constant_identifier_names
      this.save_dir,
      // ignore: non_constant_identifier_names
      this.file_name,
      // ignore: non_constant_identifier_names
      this.task_id});

  // Convert a Item into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'course_name': course_name,
      'lesson': lesson,
      'link': link,
      'save_dir': save_dir,
      'file_name': file_name,
      'task_id': task_id,
    };
  }

  // Implement toString to make it easier to see information about
  // each item when using the print statement.
  @override
  String toString() {
    return 'Item{course_name: $course_name, lesson: $lesson, link: $link, save_dir: $save_dir, file_name: $file_name, task_id: $task_id}';
  }
}

class DbHandler {
  var database;

  Future<void> openDB() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'offline_data.db'),
      // When the database is first created, create a table to store items.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE items(course_name TEXT, lesson TEXT, link TEXT, save_dir TEXT, file_name TEXT, task_id TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts items into the database
  Future<void> insert(Item item) async {
    if (database == null) {
      await openDB();
      Future.delayed(Duration(seconds: 2));
    }

    List<Item> items_ = await items();

    bool mayAdd = true;

    items_.forEach((element) {
      if (element.link == item.link) mayAdd = false;
    });

    if (mayAdd) {
      // Get a reference to the database.
      final db = await database;

      // Insert the Item into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same item is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // A method that retrieves all the Items from the items table.
  Future<List<Item>> items() async {
    if (database == null) {
      await openDB();
      Future.delayed(Duration(seconds: 2));
    }

    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Items.
    final List<Map<String, dynamic>> maps = await db.query('items');

    // Convert the List<Map<String, dynamic> into a List<Item>.
    return List.generate(maps.length, (i) {
      return Item(
        course_name: maps[i]['course_name'],
        lesson: maps[i]['lesson'],
        link: maps[i]['link'],
        save_dir: maps[i]['save_dir'],
        file_name: maps[i]['file_name'],
        task_id: maps[i]['task_id'],
      );
    });
  }

  Future<void> update(Item item) async {
    if (database == null) {
      await openDB();
      Future.delayed(Duration(seconds: 2));
    }

    // Get a reference to the database.
    final db = await database;

    // Update the given Item.
    await db.update(
      'items',
      item.toMap(),
      // Ensure that the Item has a matching id.
      where: 'link = ?',
      // Pass the Item's link as a whereArg to prevent SQL injection.
      whereArgs: [item.link],
    );
  }

  Future<void> delete(String link) async {
    if (database == null) {
      await openDB();
      Future.delayed(Duration(seconds: 2));
    }

    // Get a reference to the database.
    final db = await database;

    // Remove the Item from the database.
    await db.delete(
      'items',
      // Use a `where` clause to delete a specific item.
      where: 'link = ?',
      // Pass the Item's link as a whereArg to prevent SQL injection.
      whereArgs: [link],
    );
  }

  Future<void> deleteAll() async {
    if (database == null) {
      await openDB();
      Future.delayed(Duration(seconds: 2));
    }

    // Get a reference to the database.
    final db = await database;

    // Remove the Items from the database.
    await db.delete(
      'items',
    );
  }
}
