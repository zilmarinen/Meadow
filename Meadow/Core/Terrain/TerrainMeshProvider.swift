//
//  TerrainMeshProvider.swift
//  Meadow
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct TerrainMeshProvider {
    
    public static func terrainLayer(crown corners: (GridCorner, GridCorner), acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.0, corners.1)
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = v1 - crown
        let v3 = v0 - crown
        
        if let acuteCorner = acuteCorner {
            
            let v4 = polyhedron.lowerPolytope.vertices[c0.rawValue]
            let v5 = polyhedron.lowerPolytope.vertices[c1.rawValue]
            
            let v6 = (acuteCorner == c0 ? v2 : SCNVector3.lerp(from: v5, to: v4, factor: TerrainLayer.crown))
            let v7 = (acuteCorner == c1 ? v3 : SCNVector3.lerp(from: v4, to: v5, factor: TerrainLayer.crown))
            
            return [    MeshFace(v0: v0, v1: v1, v2: v6, normal: normal, color: color),
                        MeshFace(v0: v0, v1: v6, v2: v7, normal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
    
    public static func terrainLayer(throne corners: (GridCorner, GridCorner), acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.0, corners.1)
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue] - crown
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue] - crown
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        if let acuteCorner = acuteCorner {
            
            switch acuteCorner {
                
            case c0:
                
                let v4 = SCNVector3.lerp(from: v3, to: v2, factor: TerrainLayer.crown)
                
                return [MeshFace(v0: v4, v1: v1, v2: v2, normal: normal, color: color)]
                
            default:
            
                let v4 = SCNVector3.lerp(from: v2, to: v3, factor: TerrainLayer.crown)
            
                return [MeshFace(v0: v0, v1: v4, v2: v3, normal: normal, color: color)]
            }
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
}
