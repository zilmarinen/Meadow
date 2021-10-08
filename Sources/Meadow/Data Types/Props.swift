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

public enum Prop: Hashable {
    
    case bridge(tileType: BridgeTileType, material: BridgeMaterial, pattern: Cardinal)
    case building(architecture: BuildingArchitecture, polyomino: Polyomino)
    case foliage(foliageType: FoliageType)
    case stairs(stairType: StairType, material: StairMaterial)
    case wall(tileType: WallType, material: WallMaterial, pattern: Cardinal, external: Bool)
    
    public var identifier: String {
        
        switch self {
            
        case .bridge(let tileType, let material, let pattern): return material.propIdentifier(tileType: tileType, pattern: pattern)
        case .building(let architecture, let polyomino): return architecture.id + "_" + polyomino.id
        case .foliage(let foliageType): return foliageType.propIdentifier
        case .stairs(let stairType, let material): return material.id + "_" + stairType.id
        case .wall(let tileType, let material, let pattern, let external): return material.propIdentifier(tileType: tileType, pattern: pattern, external: external)
        }
    }
    
    public func load() throws -> Model {
        
        let asset = try NSDataAsset.asset(named: identifier, in: .module)
    
        let decoder = JSONDecoder()
        
        let model = try decoder.decode(Model.self, from: asset.data)
        
        return model
    }
}

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
    
    public func model(prop: Prop) -> Model? {
     
        switch prop {
            
        case .bridge: return bridges[prop.identifier]
        case .building: return buildings[prop.identifier]
        case .foliage: return foliage[prop.identifier]
        case .stairs: return stairs[prop.identifier]
        case .wall: return walls[prop.identifier]
        }
    }
    
    func cache(prop: Prop, model: Model) {
        
        switch prop {
            
        case .bridge: bridges[prop.identifier] = model
        case .building: buildings[prop.identifier] = model
        case .foliage: foliage[prop.identifier] = model
        case .stairs: stairs[prop.identifier] = model
        case .wall: walls[prop.identifier] = model
        }
    }
}
