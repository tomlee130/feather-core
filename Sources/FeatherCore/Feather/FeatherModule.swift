//
//  ViperModule.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 22..
//

/// module component
public protocol FeatherModule {
    
    /// name of the module
    static var moduleKey: String { get }
    /// path component based
    static var moduleKeyPathComponent: PathComponent { get }
    /// relative location of the module
    static var assetPath: String { get }

    static var name: String { get }
    
    /// module priority
    var priority: Int { get }
    /// bundle url
    var bundleUrl: URL? { get }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws
    
    static func permission(for action: Permission.Action) -> Permission
    static func hookInstallPermission(for action: Permission.Action) -> PermissionCreateObject
    
    static var adminLink: Link { get }
}

///default module implementation
public extension FeatherModule {

    /// path component based on the module name
    static var moduleKeyPathComponent: PathComponent { .init(stringLiteral: moduleKey) }
    /// path of the module is based on the name by default
    static var assetPath: String { moduleKey + "/" }
    
    static var name: String { moduleKey.capitalized }
    
    /// default module priority 
    var priority: Int { 1000 }
    /// bundle url of the module
    var bundleUrl: URL? { nil }

    /// boots the module as the first step of the configuration flow
    func boot(_ app: Application) throws {}


    static func permission(for action: Permission.Action) -> Permission {
        .init(namespace: moduleKey, context: "module", action: action)
    }

    static func hookInstallPermission(for action: Permission.Action) -> PermissionCreateObject {
        PermissionCreateObject(permission(for: action))
    }
    
    static var adminLink: Link { .init(label: name, url: ("admin" + "/" + moduleKey).safePath()) }
}


internal extension FeatherModule {

    static var moduleBundleUrl: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Bundle").appendingPathComponent("Modules").appendingPathComponent(name.capitalized)
    }
}
