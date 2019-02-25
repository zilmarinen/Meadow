//
//  AreaNodeEdge.swift
//  Meadow
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNodeEdge: SceneGraphChild {
    
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
    
    public required init(observer: SceneGraphObserver, volume: Volume, edge: GridEdge) {
        
        self.observer = observer
        
        self.volume = volume
        
        self.edge = edge
    }
}

extension AreaNodeEdge: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case edge
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge, forKey: .edge)
    }
}

extension AreaNodeEdge: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: AreaNodeEdge, rhs: AreaNodeEdge) -> Bool {
        
        return lhs.volume == rhs.volume && lhs.edge == rhs.edge
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
    
    public static let areaHeight: Int = 5
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
