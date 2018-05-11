//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainLayer {
    
    public struct TerrainLayerHierarchy {
        
        var upper: TerrainLayer?
        var lower: TerrainLayer?
    }
    
    private var isDirty: Bool = true
    
    private var corners: [Int]
    
    private var cachedPolyhedron: Polyhedron?
    
    unowned let node: TerrainNode
    
    let type: TerrainType
    
    var hierarchy: TerrainLayerHierarchy
    
    var polyhedron: Polyhedron {
        
        if !isDirty {
            
            return cachedPolyhedron!
        }
        
        let unit = Polytope.Unit
        
        var vertices: [SCNVector3] = []
        
        for index in 0..<corners.count {
            
            vertices.append(SCNVector3(x: CGFloat(node.volume.coordinate.x) + CGFloat(unit.vertices[index].x), y: World.Y(y: corners[index]), z: CGFloat(node.volume.coordinate.z) + unit.vertices[index].z))
        }
        
        let upperPolytope = Polytope(vertices: vertices)
        
        var lowerPolytope: Polytope
        
        if hierarchy.lower != nil {
            
            lowerPolytope = hierarchy.lower!.polyhedron.upperPolytope
        }
        else {
            
            lowerPolytope = Polytope(x: CGFloat(node.volume.coordinate.x), y: World.Y(y: node.volume.coordinate.y), z: CGFloat(node.volume.coordinate.z))
        }
        
        cachedPolyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
        
        return cachedPolyhedron!
    }
    
    init(node: TerrainNode, terrainType: TerrainType) {
        
        self.node = node
        
        self.type = terrainType
        
        self.corners = [0, 0, 0, 0]
        
        self.hierarchy = TerrainLayerHierarchy(upper: nil, lower: nil)
    }
}

extension TerrainLayer: Equatable {
    
    public static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.type == rhs.type && lhs.polyhedron == rhs.polyhedron
    }
}

extension TerrainLayer {
    
    func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        node.becomeDirty()
    }
}

extension TerrainLayer {
    
    func set(height: Int, corner: GridCorner, smooth: Bool = false) {
        
        var value = min(max(height, World.Floor), World.Ceiling)
        
        if let upper = hierarchy.upper {
            
            value = min(value, upper.get(height: corner))
        }
        
        if let lower = hierarchy.lower {
            
            value = max(value, lower.get(height: corner))
        }
        
        if get(height: corner) != value {
         
            corners[corner.rawValue] = value
            
            node.becomeDirty()
        }
        
        let connectedCorners = GridCorner.Corners(corner: corner)
        let oppositeCorner = GridCorner.Opposite(corner: corner)
        
        resolve(height: value, corner: connectedCorners[0], clamp: 1)
        resolve(height: value, corner: connectedCorners[1], clamp: 1)
        resolve(height: value, corner: oppositeCorner, clamp: 2)
        
        if smooth {
            
            let connectedEdges = GridEdge.Edges(corner: corner)
            
            let ce0 = connectedEdges[0]
            let ce1 = connectedEdges[1]
            
            let ac0 = GridCorner.Adjacent(corner: corner, edge: ce0)
            let ac1 = GridCorner.Adjacent(corner: corner, edge: ce1)
            
            let n0 = node.find(neighbour: ce0)?.node as? TerrainNode
            let n1 = node.find(neighbour: ce1)?.node as? TerrainNode
            
            let n2 = (n0 != nil ? n0!.find(neighbour: ce1) : (n1 != nil ? n1!.find(neighbour: ce0) : nil))?.node as? TerrainNode
            
            if let n0 = n0, let topLayer = n0.topLayer { topLayer.propagate(height: value, corner: ac0, smooth: smooth) }
            if let n1 = n1, let topLayer = n1.topLayer { topLayer.propagate(height: value, corner: ac1, smooth: smooth) }
            if let n2 = n2, let topLayer = n2.topLayer { topLayer.propagate(height: value, corner: oppositeCorner, smooth: smooth) }
        }
    }
    
    func propagate(height: Int, corner: GridCorner, smooth: Bool) {
        
        if get(height: corner) != height {
            
            set(height: height, corner: corner, smooth: smooth)
        }
    }
    
    func resolve(height: Int, corner: GridCorner, clamp: Int) {
     
        let delta = get(height: corner) - height
        
        if abs(delta) > clamp {
            
            corners[corner.rawValue] = height + (delta <= -clamp ? -clamp : (delta >= clamp ? clamp : delta))
        }
    }
    
    func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
}
