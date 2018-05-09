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
            
            vertices.append(SCNVector3(x: CGFloat(node.volume.coordinate.x) + unit.vertices[index].x, y: World.Y(y: corners[index]), z: CGFloat(node.volume.coordinate.z) + unit.vertices[index].z))
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
        
        //
    }
    
    func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
}
