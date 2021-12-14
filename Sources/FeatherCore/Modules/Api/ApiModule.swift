//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 24..
//

import Vapor

public extension HookName {

    static let publicApiRoutes: HookName = "public-api-routes"
    static let publicApiMiddlewares: HookName = "public-api-middlewares"

    static let adminApiRoutes: HookName = "admin-api-routes"
    static let adminApiMiddlewares: HookName = "admin-api-middlewares"
}

struct ApiModule: FeatherModule {

    func boot(_ app: Application) throws {
        let router = ApiRouter()
        try router.boot(app)

        app.hooks.register(.routes, use: router.routesHook)
        app.hooks.register(.adminRoutes, use: router.adminRoutesHook)
        app.hooks.register(.adminApiMiddlewares, use: adminApiMiddlewaresHook)
        app.hooks.register(.publicApiMiddlewares, use: publicApiMiddlewaresHook)
    }
    
    func publicApiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            ApiErrorMiddleware(),
        ]
    }
    
    func adminApiMiddlewaresHook(args: HookArguments) -> [Middleware] {
        [
            ApiErrorMiddleware(),
        ]
    }
}