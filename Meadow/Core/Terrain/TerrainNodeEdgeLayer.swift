//
//  TerrainNodeEdgeLayer.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainNodeEdgeLayer: SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
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
    
    var isDirty: Bool = false
    
    public let coordinate: Coordinate
    
    public let edge: GridEdge
    
    public var upper: TerrainNodeEdgeLayer? {
        
        didSet {
            
            if upper != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var lower: TerrainNodeEdgeLayer? {
        
        didSet {
            
            if lower != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var c0 = TerrainNodeEdgeLayerCorner(corner: .c0, height: World.floor)
    var c1 = TerrainNodeEdgeLayerCorner(corner: .c1, height: World.floor)
    var c2 = TerrainNodeEdgeLayerCorner(corner: .c2, height: World.floor)
    
    public var terrainType: TerrainType {
        
        didSet {
            
            if terrainType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public required init(observer: SceneGraphObserver, coordinate: Coordinate, edge: GridEdge, terrainType: TerrainType) {
        
        self.observer = observer
        self.coordinate = coordinate
        self.edge = edge
        self.terrainType = terrainType
    }
}

extension TerrainNodeEdgeLayer: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case coordinate
        case edge
        case terrainType
        case c0
        case c1
        case c2
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.coordinate, forKey: .coordinate)
        try container.encode(self.edge, forKey: .edge)
        try container.encode(self.terrainType, forKey: .terrainType)
        try container.encode(self.c0, forKey: .c0)
        try container.encode(self.c1, forKey: .c1)
        try container.encode(self.c2, forKey: .c2)
    }
}

extension TerrainNodeEdgeLayer: Hashable {
    
    public static func == (lhs: TerrainNodeEdgeLayer, rhs: TerrainNodeEdgeLayer) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.edge == rhs.edge && lhs.c0 == rhs.c0 && lhs.c1 == rhs.c1 && lhs.c2 == rhs.c2 && lhs.terrainType == rhs.terrainType
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(volume)
    }
}

extension TerrainNodeEdgeLayer: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        isDirty = false
        
        return true
    }
}

extension TerrainNodeEdgeLayer: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        switch edge {
            
        case .north:
            
            let polytope = Polytope(x: MDWFloat(coordinate.x), y0: c0.height, y1: c1.height, y2: c2.height, y3: c2.height, z: MDWFloat(coordinate.z))
            
            let v0 = SCNVector3.lerp(from: polytope.vertices[0], to: polytope.vertices[1], factor: 0.5)
            
            let v1 = SCNVector3(x: polytope.center.x, y: Axis.Y(y: centre), z: polytope.center.z)
            
            let v2 = ((v1 - v0) * 2)
            
            return Polytope(v0: polytope.vertices[0], v1: polytope.vertices[1], v2: (polytope.vertices[1] + v2), v3: (polytope.vertices[0] + v2))
            
        case .east:
            
            let polytope = Polytope(x: MDWFloat(coordinate.x), y0: c2.height, y1: c0.height, y2: c1.height, y3: c2.height, z: MDWFloat(coordinate.z))
            
            let v0 = SCNVector3.lerp(from: polytope.vertices[1], to: polytope.vertices[2], factor: 0.5)
            
            let v1 = SCNVector3(x: polytope.center.x, y: Axis.Y(y: centre), z: polytope.center.z)
            
            let v2 = ((v1 - v0) * 2)
            
            return Polytope(v0: (polytope.vertices[1] + v2), v1: polytope.vertices[1], v2: polytope.vertices[2], v3: (polytope.vertices[2] + v2))
            
        case .south:
            
            let polytope = Polytope(x: MDWFloat(coordinate.x), y0: c2.height, y1: c2.height, y2: c0.height, y3: c1.height, z: MDWFloat(coordinate.z))
            
            let v0 = SCNVector3.lerp(from: polytope.vertices[2], to: polytope.vertices[3], factor: 0.5)
            
            let v1 = SCNVector3(x: polytope.center.x, y: Axis.Y(y: centre), z: polytope.center.z)
            
            let v2 = ((v1 - v0) * 2)
            
            return Polytope(v0: (polytope.vertices[3] + v2), v1: (polytope.vertices[2] + v2), v2: polytope.vertices[2], v3: polytope.vertices[3])
            
        case .west:
            
            let polytope = Polytope(x: MDWFloat(coordinate.x), y0: c1.height, y1: c2.height, y2: c2.height, y3: c0.height, z: MDWFloat(coordinate.z))
            
            let v0 = SCNVector3.lerp(from: polytope.vertices[0], to: polytope.vertices[3], factor: 0.5)
            
            let v1 = SCNVector3(x: polytope.center.x, y: Axis.Y(y: centre), z: polytope.center.z)
            
            let v2 = ((v1 - v0) * 2)
            
            return Polytope(v0: polytope.vertices[0], v1: (polytope.vertices[0] + v2), v2: (polytope.vertices[3] + v2), v3: polytope.vertices[3])
        }
    }
    
    var lowerPolytope: Polytope {
        
        return (lower?.upperPolytope ?? Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z)))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainNodeEdgeLayer {
    
    public var base: Int {
    
        return min(c0.height, c1.height, c2.height)
    }
    
    public var peak: Int {
        
        return max(c0.height, c1.height, c2.height)
    }
    
    public var centre: Int {
        
        return c2.height
    }
    
    public func get(corner: GridCorner) -> Int? {
     
        let (corner0, corner1) = GridCorner.corners(edge: edge)
        
        switch corner {
            
        case corner0: return c0.height
        case corner1: return c1.height
        default: return nil
        }
    }
    
    @discardableResult public func set(corner: GridCorner, height: Int) -> Bool {
        
        let (corner0, corner1) = GridCorner.corners(edge: edge)
        
        switch corner {
            
        case corner0: return adjust(corner: c0, height: height)
        case corner1: return adjust(corner: c1, height: height)
        default: return false
        }
    }
    
    @discardableResult public func set(center height: Int) -> Bool {
        
        return adjust(corner: c2, height: height)
    }
    
    @discardableResult func adjust(corner: TerrainNodeEdgeLayerCorner, height: Int) -> Bool {
        
        func clamp(corner: TerrainNodeEdgeLayerCorner, height: Int) -> Int {
            
            var upperHeight: Int = World.ceiling
            var lowerHeight: Int = World.floor
            
            switch corner.corner {
                
            case .c0:
                
                upperHeight = (upper?.c0.height ?? upperHeight)
                lowerHeight = (lower?.c0.height ?? lowerHeight)
                
            case .c1:
                
                upperHeight = (upper?.c1.height ?? upperHeight)
                lowerHeight = (lower?.c1.height ?? lowerHeight)
                
            case .c2:
                
                upperHeight = (upper?.c2.height ?? upperHeight)
                lowerHeight = (lower?.c2.height ?? lowerHeight)
            }
            
            return min(upperHeight, max(lowerHeight + 1, height))
        }
        
        func resolve(connected: TerrainNodeEdgeLayerCorner, height: Int) {
            
            let delta = (connected.height - height)
            
            let threshold = 2
            
            guard abs(delta) > threshold else { return }
            
            switch sign(delta) {
                
            case .negative:
                
                adjust(corner: connected, height: (height - threshold))
                
            case .positive:
                
                adjust(corner: connected, height: (height + threshold))
                
            default: break
            }
        }
        
        let clamped = clamp(corner: corner, height: height)
        
        guard corner.height != clamped else { return false }
        
        switch corner.corner {
            
        case .c0:
            
            c0 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
            
            resolve(connected: c1, height: clamped)
            resolve(connected: c2, height: clamped)
            
            c0 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
            
        case .c1:
            
            c1 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
            
            resolve(connected: c0, height: clamped)
            resolve(connected: c2, height: clamped)
            
            c1 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
            
        case .c2:
            
            c2 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
            
            resolve(connected: c0, height: clamped)
            resolve(connected: c1, height: clamped)
            
            c2 = TerrainNodeEdgeLayerCorner(corner: corner.corner, height: clamped)
        }
        
        becomeDirty()
        
        return true
    }
}

extension TerrainNodeEdgeLayer {
    
    public static let crown: MDWFloat = (Axis.unitY / 2.0)
}
