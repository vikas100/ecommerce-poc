//
//  StorageModule.swift
//  ecommerce-poc
//
//  Created by Rugmangathan on 06/07/18.
//  Copyright © 2018 Rugmangathan. All rights reserved.
//

import Foundation
import RxGRDB
import GRDB

struct StorageModule {
  static func openDatabase(atPath path: String) throws -> DatabaseQueue {
    dbQueue = try DatabaseQueue(path: path)
    try migrator.migrate(dbQueue)

    return dbQueue
  }

  static var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    migrator.registerMigration("v1.0") { db in
      try db.create(table: LocalCategory.databaseTableName) { t in
        typealias Column = LocalCategory.Column
        t.column(Column.id, .integer).primaryKey()
        t.column(Column.name, .text).notNull()
        t.column(Column.parent, .integer)
      }
      
      try db.create(table: Product.databaseTableName) { t in
        typealias Column = Product.Column
        t.column(Column.id, .integer).primaryKey()
        t.column(Column.name, .text).notNull()
        t.column(Column.taxName, .text).notNull()
        t.column(Column.taxValue, .integer).notNull()
        t.column(Column.categoryId, .integer).notNull()
      }
      
      try db.create(table: Variant.databaseTableName) { t in
        typealias Column = Variant.Column
        t.column(Column.id, .integer).primaryKey()
        t.column(Column.color, .text).notNull()
        t.column(Column.size, .integer).notNull()
        t.column(Column.price, .integer).notNull()
        t.column(Column.productId, .integer).notNull()
      }
    }
    return migrator
  }
}
