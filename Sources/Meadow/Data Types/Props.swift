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
    
    case building(architecture: BuildingArchitecture, polyomino: Polyomino)
    case foliage(foliageType: FoliageType)
    case portal(portalType: PortalType)
    case stairs(stairType: StairType, material: StairMaterial)
    
    public var identifier: String {
        
        switch self {
            
        case .building(let architecture, let polyomino): return architecture.id + "_" + polyomino.id
        case .foliage(let foliageType): return foliageType.propIdentifier
        case .portal(let portalType): return portalType.id
        case .stairs(let stairType, let material): return material.id + "_" + stairType.id
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
    
    var buildings: [String : Model]
    var foliage: [String : Model]
    var portals: [String : Model]
    var stairs: [String : Model]
    
    public init() {
        
        buildings = [:]
        foliage = [:]
        portals = [:]
        stairs = [:]
    }
    
    public func model(prop: Prop) -> Model? {
     
        switch prop {
            
        case .building: return buildings[prop.identifier]
        case .foliage: return foliage[prop.identifier]
        case .portal: return portals[prop.identifier]
        case .stairs: return stairs[prop.identifier]
        }
    }
    
    func cache(prop: Prop, model: Model) {
        
        switch prop {
            
        case .building: buildings[prop.identifier] = model
        case .foliage: foliage[prop.identifier] = model
        case .portal: portals[prop.identifier] = model
        case .stairs: stairs[prop.identifier] = model
        }
    }
    
    func merge(cache: Props) {
        
        buildings.merge(cache.buildings, uniquingKeysWith: { (lhs, _) in lhs })
        foliage.merge(cache.foliage, uniquingKeysWith: { (lhs, _) in lhs })
        portals.merge(cache.portals, uniquingKeysWith: { (lhs, _) in lhs })
        stairs.merge(cache.stairs, uniquingKeysWith: { (lhs, _) in lhs })
    }
}
