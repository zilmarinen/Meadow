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
    
    var bridges: [String : Model]
    var buildings: [String : Model]
    var foliage: [String : Model]
    var stairs: [String : Model]
    var walls: [String : Model]
    
    public init() {
        
        bridges = [:]
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
    
    public func prop(bridge tileType: BridgeTileType, material: BridgeMaterial, pattern: WallPattern) -> Model {
        
        let identifier = material.prop(tileType: tileType, pattern: pattern)
        
        if let model = walls[identifier] {
            
            return model
        }
        
        guard let model = load(prop: identifier) else { fatalError("Error loading model for prop: \(identifier)") }
        
        bridges[identifier] = model
        
        return model
    }
    
    public func prop(building buildingType: BuildingType) -> Model {
        
        if let model = buildings[buildingType.id] {
            
            return model
        }
        
        guard let model = load(prop: buildingType.id) else { fatalError("Error loading model for prop: \(buildingType)") }
        
        buildings[buildingType.id] = model
        
        return model
    }
    
    public func prop(foliage foliageType: FoliageType) -> Model {
        
        if let model = foliage[foliageType.id] {
            
            return model
        }
        
        guard let model = load(prop: foliageType.id) else { fatalError("Error loading model for prop: \(foliageType)") }
        
        foliage[foliageType.id] = model
        
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
