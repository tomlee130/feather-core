//
//  InlineSvg.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public struct InlineSvg: LeafNonMutatingMethod, Invariant, StringReturn {

    let iconset: String

    public static var callSignature: [LeafCallParameter] {
        [
            .string,
            .string(labeled: "class", optional: true, defaultValue: "")
        ]
    }
    
    public init(iconset: String) {
        self.iconset = iconset
    }

    public func evaluate(_ params: LeafCallValues) -> LeafData {
        let name = params[0].string!
        let path = Application.Paths.public + Application.Locations.images + iconset + "/" + name + ".svg"
        do {
            var svg = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
            let cls = params[1].string!
            if !cls.isEmpty {
                svg = svg.replacingOccurrences(of: "<svg", with: "<svg class=\"\(cls)\" ")
            }
            return .string(svg)
        }
        catch {
            return .string("!\(name)!")
        }
    }
}