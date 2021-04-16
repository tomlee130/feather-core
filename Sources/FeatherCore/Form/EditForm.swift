//
//  EditForm.swift
//  ViewKit
//
//  Created by Tibor Bodecs on 2020. 11. 19..
//

/// a form used to edit a model (EditModelForm?)
public protocol EditForm: Form {
    
    associatedtype Model: FeatherModel

    func read(from: Model)
    func write(to: Model)

    func willSave(req: Request, model: Model) -> EventLoopFuture<Void>
    func didSave(req: Request, model: Model) -> EventLoopFuture<Void>
}

/// can be used to build forms with associated models
public extension EditForm {

    var templateData: TemplateData {
        .dictionary([
            "fields": fieldsTemplateData,
            "notification": .string(notification)
        ])
    }
    
    func willSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }

    func didSave(req: Request, model: Model) -> EventLoopFuture<Void> {
        req.eventLoop.future()
    }
}