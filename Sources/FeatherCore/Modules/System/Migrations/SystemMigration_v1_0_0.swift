//
//  SystemMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

struct SystemMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(SystemVariableModel.schema)
            .id()
            .field(SystemVariableModel.FieldKeys.key, .string, .required)
            .field(SystemVariableModel.FieldKeys.value, .data)
            .field(SystemVariableModel.FieldKeys.hidden, .bool, .required)
            .field(SystemVariableModel.FieldKeys.notes, .data)
            .unique(on: SystemVariableModel.FieldKeys.key)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(SystemVariableModel.schema).delete()
    }
}