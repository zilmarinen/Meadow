//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNode<Layer: TerrainLayer>: GridNode, GridParent {
    
    public typealias ChildType = Layer
    
    public var children: [Layer] = []
    
    public var intersections: [Polyhedron] = []
    
    enum CodingKeys: CodingKey {
        
        case layers
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children, forKey: .layers)
    }
    
    public override func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
        }
    }
    
    public override func clean() {
        
        if !isDirty { return }
        
        children.forEach { layer in
            
            layer.clean()
        }
        
        isDirty = false
    }
    
    public override var mesh: Mesh {
        
        let visibleTiles = children.filter { !$0.isHidden }
        
        let meshes = visibleTiles.map { _ in Mesh(faces: []) }
        
        return Mesh(meshes: meshes)
    }
}

extension TerrainNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? ChildType else { return nil }
        
        return children.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        let _ = becomeDirty()
        
        observer?.child(didBecomeDirty: child)
    }
}

extension TerrainNode {
    
    public var topLayer: Layer? {
        
        return children.first { layer -> Bool in
            
            return layer.hierarchy.upper == nil
        }
    }
    
    public func add(layer terrainType: TerrainType) -> TerrainLayer? {
        
        if let topLayer = topLayer, Axis.Y(y: topLayer.polyhedron.upperPolytope.base) == World.ceiling {
            
            return nil
        }
        
        let height = (World.floor + 1)
        
        let corners = topLayer?.polyhedron.upperPolytope.vertices.map { Axis.Y(y: $0.y) + 1 } ?? [height, height, height, height]
        
        guard let layer = Layer(observer: self, coordinate: volume.coordinate, corners: corners, terrainType: terrainType) else { return nil }
        
        layer.hierarchy.lower = topLayer
    
        topLayer?.hierarchy.upper = layer
    
        children.append(layer)
    
        becomeDirty()
    
        return layer
    }
    
    public func remove(layer: TerrainLayer) -> Bool {
        
        if let index = index(of: layer) {
            
            let upper = layer.hierarchy.upper
            let lower = layer.hierarchy.lower
            
            upper?.hierarchy.lower = lower
            
            lower?.hierarchy.upper = upper
            
            layer.hierarchy.upper = nil
            layer.hierarchy.lower = nil
        
            children.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension TerrainNode: TerrainNodeIntersectionProvider {
    
    public func add(intersection polyhedron: Polyhedron) -> Bool {
        
        let intersection = intersections.first {
            
            let elevation = $0.elevation(referencing: polyhedron)
            
            return elevation == .equal || elevation == .intersecting
        }
        
        if intersection == nil {
            
            intersections.append(polyhedron)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
    
    public func remove(intersection polyhedron: Polyhedron) -> Bool {
        
        if let index = intersections.index(of: polyhedron) {
            
            intersections.remove(at: index)
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}
