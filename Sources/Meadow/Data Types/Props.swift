//
//  Props.swift
//
//  Created by Zack Brown on 03/05/2021.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

public class Props {
    
    var buildings: [String : Model]
    var foliage: [String : Model]
    var stairs: [String : Model]
    var walls: [String : Model]
    
    public init() {
        
        buildings = [:]
        foliage = [:]
        stairs = [:]
        walls = [:]
    }
    
    func load(prop: String) -> Model? {
        
        guard let asset = NSDataAsset(name: prop, bundle: .module) else { return nil }
    
        let decoder = JSONDecoder()
        
        return try? decoder.decode(Model.self, from: asset.data)
    }
}

extension Props {
    
    public func prop(prop: BuildingType) -> Model {
        
        if let model = buildings[prop.identifier] {
            
            return model
        }
        
        guard let model = load(prop: prop.identifier) else { fatalError("Error loading model for prop: \(prop)") }
        
        buildings[prop.identifier] = model
        
        return model
    }
    
    public func prop(prop: FoliageType) -> Model {
        
        if let model = foliage[prop.identifier] {
            
            return model
        }
        
        guard let model = load(prop: prop.identifier) else { fatalError("Error loading model for prop: \(prop)") }
        
        foliage[prop.identifier] = model
        
        return model
    }
    
    public func prop(stairs tileType: StairType, material: StairMaterial) -> Model {
        
        let identifier = material.id + "_\(tileType.id)"
        
        if let model = stairs[identifier] {
            
            return model
        }
        
        guard let model = load(prop: identifier) else { fatalError("Error loading model for prop: \(identifier)") }
        
        stairs[identifier] = model
        
        return model
    }
    
    public func prop(wall tileType: WallTileType, material: WallTileMaterial, pattern: WallPattern, external: Bool) -> Model {
        
        let identifier = material.prop(tileType: tileType, pattern: pattern, external: external)
        
        if let model = walls[identifier] {
            
            return model
        }
        
        guard let model = load(prop: identifier) else { fatalError("Error loading model for prop: \(identifier)") }
        
        walls[identifier] = model
        
        return model
    }
}
