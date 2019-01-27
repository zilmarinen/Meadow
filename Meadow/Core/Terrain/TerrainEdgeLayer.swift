//
//  TerrainEdgeLayer.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class TerrainEdgeLayer: SceneGraphChild {
    
    enum LayerCorner {
        
        case c0
        case c1
        case c2
    }
    
    struct LayerCornerHeight: Equatable {
        
        let corner: LayerCorner
        let height: Int
    }
    
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
    
    var c0 = LayerCornerHeight(corner: .c0, height: World.floor)
    var c1 = LayerCornerHeight(corner: .c1, height: World.floor)
    var c2 = LayerCornerHeight(corner: .c2, height: World.floor)
    
    public required init(observer: SceneGraphObserver, coordinate: Coordinate, edge: GridEdge) {
        
        self.observer = observer
        
        self.coordinate = coordinate
        
        self.edge = edge
    }
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

extension TerrainEdgeLayer: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: TerrainEdgeLayer, rhs: TerrainEdgeLayer) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.edge == rhs.edge && lhs.c0 == rhs.c0 && lhs.c1 == rhs.c1 && lhs.c2 == rhs.c2
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
        
        let height = peak
        
        return Polytope(x: MDWFloat(coordinate.x), y0: height, y1: height, y2: height, y3: height, z: MDWFloat(coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        if let lower = lower {
            
            return lower.upperPolytope
        }
        
        return Polytope(x: MDWFloat(coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainEdgeLayer {
    
    var base: Int {
    
        return min(c0.height, c1.height, c2.height)
    }
    
    var peak: Int {
        
        return max(c0.height, c1.height, c2.height)
    }
    
    var centre: Int {
        
        return c2.height
    }
    
    func get(corner: GridCorner) -> Int? {
     
        let (corner0, corner1) = GridCorner.corners(edge: edge)
        
        switch corner {
            
        case corner0: return c0.height
        case corner1: return c1.height
        default: return nil
        }
    }
    
    @discardableResult
    func set(corner: GridCorner, height: Int) -> Bool {
        
        let (corner0, corner1) = GridCorner.corners(edge: edge)
        
        switch corner {
            
        case corner0: return adjust(corner: c0, height: height)
        case corner1: return adjust(corner: c1, height: height)
        default: return false
        }
    }
    
    @discardableResult
    func set(center height: Int) -> Bool {
        
        return adjust(corner: c2, height: height)
    }
    
    @discardableResult
    func adjust(corner: LayerCornerHeight, height: Int) -> Bool {
        
        func clamp(corner: LayerCornerHeight, height: Int) -> Int {
            
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
        
        func resolve(connected: LayerCornerHeight, height: Int) {
            
            let delta = (connected.height - height)
            
            guard abs(delta) > 1 else { return }
            
            switch sign(delta) {
                
            case .negative:
                
                print("resolving \(connected.corner) to height \(height - 1)")
                
                adjust(corner: connected, height: (height - 1))
                
            case .positive:
                
                print("resolving \(connected.corner) to height \(height + 1)")
                
                adjust(corner: connected, height: (height + 1))
                
            default: print("\(connected.height) - \(height) equals zero")
            }
        }
        
        let clamped = clamp(corner: corner, height: height)
        
        guard corner.height != clamped else { return false }
        
        print("-------")
        print("adjusting \(corner.corner) to height \(clamped)")
        
        switch corner.corner {
            
        case .c0:
            
            c0 = LayerCornerHeight(corner: corner.corner, height: clamped)
            
            resolve(connected: c1, height: clamped)
            resolve(connected: c2, height: clamped)
            
            c0 = LayerCornerHeight(corner: corner.corner, height: clamped)
            
        case .c1:
            
            c1 = LayerCornerHeight(corner: corner.corner, height: clamped)
            
            resolve(connected: c0, height: clamped)
            resolve(connected: c2, height: clamped)
            
            c1 = LayerCornerHeight(corner: corner.corner, height: clamped)
            
        case .c2:
            
            c2 = LayerCornerHeight(corner: corner.corner, height: clamped)
            
            resolve(connected: c0, height: clamped)
            resolve(connected: c1, height: clamped)
            
            c2 = LayerCornerHeight(corner: corner.corner, height: clamped)
        }
        
        becomeDirty()
        
        return true
    }
}
