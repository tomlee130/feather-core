//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 29..
//

import Vapor
import Fluent

public protocol UpdateController: ModelController {
 
    associatedtype UpdateModelEditor: FeatherModelEditor
    associatedtype UpdateModelApi: UpdateApi & DetailApi
    
    func updateAccess(_ req: Request) async -> Bool
    func update(_ req: Request) async throws -> Response
    func updateView(_ req: Request) async throws -> Response
    func updateTemplate(_ req: Request, _ editor: UpdateModelEditor, _ form: FeatherForm) -> TemplateRepresentable
    func updateApi(_ req: Request) async throws -> UpdateModelApi.DetailObject
}

public extension UpdateController {

    func updateAccess(_ req: Request) async -> Bool {
        await req.checkAccess(for: Model.permission(.update))
    }
    
    private func render(_ req: Request, editor: UpdateModelEditor, form: FeatherForm) -> Response {
        return req.html.render(updateTemplate(req, editor, form))
    }
    
    func updateView(_ req: Request) async throws -> Response {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }

        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model)
        let form = FeatherForm(fields: editor.formFields)
        await form.load(req: req)
        await form.read(req: req)
        return render(req, editor: editor, form: form)
    }

    func update(_ req: Request) async throws -> Response {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let model = try await findBy(identifier(req), on: req.db)
        let editor = UpdateModelEditor(model: model as! UpdateModelEditor.Model)
        let form = FeatherForm(fields: editor.formFields)
        await form.load(req: req)
        await form.process(req: req)
        let isValid = await form.validate(req: req)
        guard isValid else {
            return render(req, editor: editor, form: form)
        }
        await form.write(req: req)
        try await editor.model.update(on: req.db)
        await form.save(req: req)
        return req.redirect(to: req.url.path)
    }

    func updateApi(_ req: Request) async throws -> UpdateModelApi.DetailObject {
        let hasAccess = await updateAccess(req)
        guard hasAccess else {
            throw Abort(.forbidden)
        }
        let api = UpdateModelApi()
        try await RequestValidator(api.updateValidators()).validate(req)
        let model = try await findBy(identifier(req), on: req.db) as! UpdateModelApi.Model
        let input = try req.content.decode(UpdateModelApi.UpdateObject.self)
        await api.mapUpdate(req, model: model, input: input)
        try await model.update(on: req.db)
        return api.mapDetail(model: model)
    }
        
}