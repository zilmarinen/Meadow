//
//  AreaNodeEdge.swift
//  Meadow
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNodeEdge: SceneGraphChild {
    
    public typealias Pair = (e0: AreaNodeEdge?, e1: AreaNodeEdge?)
    
    public typealias Graph = (edge: GridEdge, adjacent: Pair, intersector: Pair, perpendicular: Pair)
    
    public enum RenderState {
        
        case cutaway
        case raised
    }
    
    public struct Polytopes {
        
        let edge: Polytope
        let wall: Polytope
        
        var edgeCutaway: Polytope?
        var wallCutaway: Polytope?
    }
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return "Edge \(edge.description)" }
    
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
    
    public var edgeType: AreaNodeEdgeType
    
    public var internalEdgeFace: AreaNodeEdgeFace {
        
        didSet {
            
            if internalEdgeFace != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var externalEdgeFace: AreaNodeEdgeFace {
        
        didSet {
            
            if externalEdgeFace != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var renderState: RenderState = .raised {
        
        didSet {
            
            if renderState != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public required init(observer: SceneGraphObserver, volume: Volume, edge: GridEdge, edgeType: AreaNodeEdgeType, internalEdgeFace: AreaNodeEdgeFace, externalEdgeFace: AreaNodeEdgeFace) {
        
        self.observer = observer
        
        self.volume = volume
        
        self.edge = edge
        
        self.edgeType = edgeType
        
        self.internalEdgeFace = internalEdgeFace
        self.externalEdgeFace = externalEdgeFace
    }
}

extension AreaNodeEdge: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case edge
        case edgeType
        case internalEdgeFace
        case externalEdgeFace
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge, forKey: .edge)
        try container.encode(self.edgeType, forKey: .edgeType)
        try container.encode(self.internalEdgeFace, forKey: .internalEdgeFace)
        try container.encode(self.externalEdgeFace, forKey: .externalEdgeFace)
    }
}

extension AreaNodeEdge: Hashable {
    
    public static func == (lhs: AreaNodeEdge, rhs: AreaNodeEdge) -> Bool {
        
        return lhs.volume == rhs.volume && lhs.edge == rhs.edge
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(volume)
    }
}

extension AreaNodeEdge: SceneGraphSoilable {
    
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

extension AreaNodeEdge: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let y = volume.coordinate.y + volume.size.height
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: y, y1: y, y2: y, y3: y, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: volume.coordinate.y, y1: volume.coordinate.y, y2: volume.coordinate.y, y3: volume.coordinate.y, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension AreaNodeEdge {
    
    public static let surface: MDWFloat = 0.01
    
    public static let internalWallDepth: MDWFloat = 0.05
    public static let externalWallDepth: MDWFloat = 0.1
    
    public static let foundationHeight: Int = 1
    public static let edgeHeight: Int = 8
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: edgeHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
