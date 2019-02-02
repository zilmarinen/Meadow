//
//  TerrainNodeEdge.swift
//  Meadow
//
//  Created by Zack Brown on 15/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public class TerrainNodeEdge<EdgeLayer: TerrainEdgeLayer>: SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<EdgeLayer>()
    
    public var observer: SceneGraphObserver?
    
    public var name: String? { return "Edge" }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public let volume: Volume
    
    public let edge: GridEdge
    
    var isDirty: Bool = false
    
    public required init(observer: SceneGraphObserver, volume: Volume, edge: GridEdge) {
        
        self.observer = observer
        
        self.volume = volume
        
        self.edge = edge
    }
}

extension TerrainNodeEdge: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case edge
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.edge, forKey: .edge)
    }
}

extension TerrainNodeEdge: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: TerrainNodeEdge, rhs: TerrainNodeEdge) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension TerrainNodeEdge {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? EdgeLayer else { return nil }
        
        return children.index(of: child)
    }
}

extension TerrainNodeEdge: SceneGraphSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        children.forEach { chunk in
            
            chunk.clean()
        }
        
        isDirty = false
    }
}

extension TerrainNodeEdge: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return (topLayer?.upperPolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z)))
    }
    
    var lowerPolytope: Polytope {
        
        return (bottomLayer?.lowerPolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z)))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainNodeEdge {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension TerrainNodeEdge {
    
    func add(layer terrainType: TerrainType) -> TerrainEdgeLayer? {
        
        if let topLayer = topLayer {
            
            guard topLayer.base < World.ceiling else { return nil }
        }
        
        let layer = EdgeLayer(observer: self, coordinate: self.volume.coordinate, edge: self.edge)
        
        topLayer?.upper = layer
        
        layer.lower = topLayer
        
        let (corner0, corner1) = GridCorner.corners(edge: layer.edge)
        
        layer.set(corner: corner0, height: (layer.lower?.get(corner: corner0) ?? (World.floor + 1)))
        layer.set(corner: corner1, height: (layer.lower?.get(corner: corner1) ?? (World.floor + 1)))
        layer.set(center: (layer.lower?.centre ?? (World.floor + 1)))
        
        children.append(layer)
        
        becomeDirty()
        
        return layer
    }
    
    func remove(layer: EdgeLayer) -> Bool {
        
        if let index = children.index(of: layer) {
            
            let upper = layer.upper
            let lower = layer.lower
            
            upper?.lower = lower
            
            lower?.upper = upper
            
            layer.upper = nil
            layer.lower = nil
            
            children.remove(at: index)
            
            layer.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNodeEdge {
    
    var topLayer: TerrainEdgeLayer? {
        
        return children.last
    }
    
    var bottomLayer: TerrainEdgeLayer? {
        
        return children.first
    }
}
