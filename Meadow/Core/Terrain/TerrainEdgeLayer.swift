//
//  TerrainEdgeLayer.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class TerrainEdgeLayer: GridChild {
    
    public var observer: GridObserver?
    
    public var name: String? { return edge.description }
    
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
    
    public let coordinate: Coordinate
    
    public let edge: GridEdge
    
    var isDirty: Bool = false
    
    var upperLayer: TerrainEdgeLayer?
    var lowerLayer: TerrainEdgeLayer?
    
    public required init(observer: GridObserver, coordinate: Coordinate, edge: GridEdge) {
        
        self.observer = observer
        
        self.coordinate = coordinate
        
        self.edge = edge
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
        case edge
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.coordinate, forKey: .coordinate)
        try container.encode(self.edge, forKey: .edge)
    }
}
