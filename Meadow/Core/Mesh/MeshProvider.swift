//
//  MeshProvider.swift
//  Meadow
//
//  Created by Zack Brown on 14/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct MeshProvider {
    
    public static func surface(corners: (GridCorner, GridCorner), polytope: Polytope, color: SCNVector4) -> MeshFace {
        
        let (c0, c1) = (corners.0, corners.1)
        
        let v0 = polytope.vertices[c0.rawValue]
        let v1 = polytope.center
        let v2 = polytope.vertices[c1.rawValue]
        
        return MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: color)
    }
    
    public static func edge(corners: (GridCorner, GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.0, corners.1)
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        let acuteCorner = (c0equal ? c0 : (c1equal ? c1 : nil))
        
        if let acuteCorner = acuteCorner {
            
            let v4 = (acuteCorner == c0 ? v2: v3)
            
            return [MeshFace(v0: v0, v1: v1, v2: v4, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: normal, color: color)]
    }
}
