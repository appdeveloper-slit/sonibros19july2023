import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class Store {
  int totalPrice = 0;
  int getalltotalprice = 0;

  //create the table
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" 
    CREATE TABLE items(
    idd INTEGER unique,
    name TEXT,
    brand TEXT,
    image TEXT,
    price TEXT,
    actualPrice TEXT,
    counter INTEGER,
    createdAT TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  // open databse
  static Future<sql.Database> db() async {
    return sql.openDatabase('cart.db', version: 4,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // id exists
  // static Future<bool> isProductExist(int id) async {
  // db = await Store.db();
  //    bool result = db.query('items',where: "id = ?",whereArgs: [id]) as bool;
  //    print(result);
  //    return result;
  // }

  static Future<bool> isProductExist(int id) async {
    var db = await Store.db();
    var result =
        await db.rawQuery('SELECT EXISTS(SELECT 1 FROM items WHERE idd="$id")');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  //insert data into databse
  static Future<int> createItem(int idd, String name, String brand,
      String image, String price, String actualPrice, int counter) async {
    var db = await Store.db();
    var data = {
      'idd': idd,
      'name': name,
      'brand': brand,
      'image': image,
      'price': price,
      'actualPrice': actualPrice,
      'counter': counter,
    };
    var id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // get the data
  static Future<List<dynamic>> getItems() async {
    var db = await Store.db();
    return db.query('items', orderBy: "idd");
  }

  // get the data
  static Future<List<Map<String, Object?>>> getIds() async {
    var db = await Store.db();
    var result = await db.rawQuery("SELECT idd as data1 FROM items");
    print(result);
    return result;
  }

  // totalprice
  static Future<String> getTotalPrice() async {
    var db = await Store.db();
    var result = await db.rawQuery("SELECT SUM(price) as sum FROM items");
    return result[0]['sum'].toString();
  }

  //get counter id
  static Future<String> getCounterId() async {
    var db = await Store.db();
    var result =
        await db.rawQuery("SELECT * FROM items ORDER BY counter LIMIT 1;");
    print(result);
    return result[0]['sum'].toString();
  }

  // update item

  static Future<int> updateItem(int idd, String name, String brand,
      String image, String price, String actualPrice, int counter) async {
    var db = await Store.db();
    var data = {
      'idd': idd,
      'name': name,
      'brand': brand,
      'image': image,
      'price': price,
      'actualPrice': actualPrice,
      'counter': counter,
    };
    var result =
        await db.update('items', data, where: "idd = ?", whereArgs: [idd]);
    return result;
  }

  // delete items
  static Future<void> deleteItem(int id) async {
    var db = await Store.db();
    await db.delete("items", where: "idd = ?", whereArgs: [id]);
  }

  // delete items
  static Future<void> deleteAll() async {
    var db = await Store.db();
    await db.delete("items");
  }
}
