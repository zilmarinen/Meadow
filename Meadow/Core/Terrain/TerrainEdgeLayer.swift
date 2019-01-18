//
//  TerrainEdgeLayer.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class TerrainEdgeLayer: SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return apex.edge.description }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume {
        
        return polyhedron.volume
    }
    
    var isDirty: Bool = false
    
    public let coordinate: Coordinate
    
    let apex: TerrainEdgeLayerApex
    
    var upper: TerrainEdgeLayer? {
        
        didSet {
            
            if upper != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var lower: TerrainEdgeLayer? {
        
        didSet {
            
            if lower != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public required init(observer: SceneGraphObserver, coordinate: Coordinate, edge: GridEdge) {
        
        self.observer = observer
        
        self.coordinate = coordinate
        
        self.apex = TerrainEdgeLayerApex(edge: edge)
    }
}

extension TerrainEdgeLayer: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: TerrainEdgeLayer, rhs: TerrainEdgeLayer) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension TerrainEdgeLayer: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        //
        
        isDirty = false
    }
}

extension TerrainEdgeLayer: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return Polytope(x: 0, y0: 0, y1: 0, y2: 0, y3: 0, z: 0)
    }
    
    var lowerPolytope: Polytope {
        
        return Polytope(x: 0, y0: 0, y1: 0, y2: 0, y3: 0, z: 0)
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainEdgeLayer: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case coordinate
        case apex
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.coordinate, forKey: .coordinate)
        try container.encode(self.apex, forKey: .apex)
    }
}
