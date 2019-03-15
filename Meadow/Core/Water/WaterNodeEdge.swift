//
//  WaterNodeEdge.swift
//  Meadow
//
//  Created by Zack Brown on 14/02/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class WaterNodeEdge: SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return "Edge (\(edge.description))" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume
    
    public let edge: GridEdge
    
    var isDirty: Bool = false
    
    public var waterType: WaterType {
        
        didSet {
            
            if waterType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var waterLevel: Int = World.floor {
        
        didSet {
            
            if waterLevel != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var terrainPolytope: Polytope? {
        
        didSet {
            
            if terrainPolytope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public required init(observer: SceneGraphObserver, volume: Volume, edge: GridEdge, waterType: WaterType) {
        
        self.observer = observer
        
        self.volume = volume
        
        self.edge = edge
        
        self.waterType = waterType
    }
}

extension WaterNodeEdge: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case edge
        case waterType
        case waterLevel
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge, forKey: .edge)
        try container.encode(self.waterType, forKey: .waterType)
        try container.encode(self.waterLevel, forKey: .waterLevel)
    }
}

extension WaterNodeEdge: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: WaterNodeEdge, rhs: WaterNodeEdge) -> Bool {
        
        return lhs.volume == rhs.volume && lhs.edge == rhs.edge
    }
}

extension WaterNodeEdge: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension WaterNodeEdge: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return Polytope.translate(polytope: Polytope(x: MDWFloat(volume.coordinate.x), y0: waterLevel, y1: waterLevel, y2: waterLevel, y3: waterLevel, z: MDWFloat(volume.coordinate.z)), translation: SCNVector3(x: 0.0, y: -WaterNodeEdge.meniscus, z: 0.0))
    }
    
    var lowerPolytope: Polytope {
        
        return (terrainPolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z)))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension WaterNodeEdge {
    
    static let meniscus: MDWFloat = 0.05
    static let tension: MDWFloat = 0.01
}
