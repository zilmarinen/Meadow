//
//  MeshFace.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct MeshFace {

    let vertices: [SCNVector3]

    let normals: [SCNVector3]

    let colors: [SCNVector4]
    
    init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3, projectedNormal: SCNVector3, color: SCNVector4) {
        
        let plane = Plane(v0: v0, v1: v1, v2: v2)
        
        var normal = plane.normal
        
        var face = [v0, v1, v2]
        
        if plane.side(vector: projectedNormal) == .interior {
        
            normal = SCNVector3.negate(vector: plane.normal)
            
            face = [v0, v2, v1]
        }
        
        self.vertices = face
        
        self.normals = [normal, normal, normal]
        
        self.colors = [color, color, color]
    }
    
    init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3, normal: SCNVector3, color: SCNVector4) {
        
        self.vertices = [v0, v1, v2]
        
        self.normals = [normal, normal, normal]
        
        self.colors = [color, color, color]
    }
}

extension MeshFace {
    
    public static func apex(corners: (c0: GridCorner, c1: GridCorner), polytope: Polytope, color: SCNVector4) -> MeshFace {
        
        let v0 = polytope.vertices[corners.c0.rawValue]
        let v1 = polytope.center
        let v2 = polytope.vertices[corners.c1.rawValue]
        
        return MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: color)
    }
    
    public static func edge(corners: (c0: GridCorner, c1: GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polyhedron.upperPolytope.vertices[corners.c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[corners.c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[corners.c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[corners.c0.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        let acuteCorner = (c0equal ? corners.c0 : (c1equal ? corners.c1 : nil))
        
        if let acuteCorner = acuteCorner {
            
            let v4 = (acuteCorner == corners.c0 ? v2: v3)
            
            return [MeshFace(v0: v0, v1: v1, v2: v4, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: normal, color: color)]
    }
    
    public static func edge(crown corners: (c0: GridCorner, c1: GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainEdgeLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[corners.c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[corners.c1.rawValue]
        let v2 = v1 - crown
        let v3 = v0 - crown
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            let v4 = polyhedron.lowerPolytope.vertices[corners.c0.rawValue]
            let v5 = polyhedron.lowerPolytope.vertices[corners.c1.rawValue]
            
            let v6 = (c0equal ? v2 : SCNVector3.lerp(from: v5, to: v4, factor: TerrainEdgeLayer.crown))
            let v7 = (c1equal ? v3 : SCNVector3.lerp(from: v4, to: v5, factor: TerrainEdgeLayer.crown))
            
            return [    MeshFace(v0: v0, v1: v1, v2: v6, normal: normal, color: color),
                        MeshFace(v0: v0, v1: v6, v2: v7, normal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
    
    public static func edge(throne corners: (c0: GridCorner, c1: GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.0, corners.1)
        
        let crown = SCNVector3(x: 0.0, y: TerrainEdgeLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue] - crown
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue] - crown
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            if c0equal {
                
                let v4 = SCNVector3.lerp(from: v3, to: v2, factor: TerrainEdgeLayer.crown)
                
                return [MeshFace(v0: v4, v1: v1, v2: v2, normal: normal, color: color)]
                
            }
                
            let v4 = SCNVector3.lerp(from: v2, to: v3, factor: TerrainEdgeLayer.crown)
                
            return [MeshFace(v0: v0, v1: v4, v2: v3, normal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
    
    public static func diagonal(corner: GridCorner, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polyhedron.upperPolytope.vertices[corner.rawValue]
        let v1 = polyhedron.upperPolytope.center
        let v2 = polyhedron.lowerPolytope.center
        let v3 = polyhedron.lowerPolytope.vertices[corner.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            let v4 = (c0equal ? v2: v3)
            
            return [MeshFace(v0: v0, v1: v1, v2: v4, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: normal, color: color)]
    }
    
    public static func diagonal(crown corner: GridCorner, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainEdgeLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[corner.rawValue]
        let v1 = polyhedron.upperPolytope.center
        let v2 = v1 - crown
        let v3 = v0 - crown
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            let v4 = polyhedron.lowerPolytope.vertices[corner.rawValue]
            let v5 = polyhedron.lowerPolytope.center
            
            let v6 = (c0equal ? v2 : SCNVector3.lerp(from: v5, to: v4, factor: TerrainEdgeLayer.crown))
            let v7 = (c1equal ? v3 : SCNVector3.lerp(from: v4, to: v5, factor: TerrainEdgeLayer.crown))
            
            return [    MeshFace(v0: v0, v1: v1, v2: v6, normal: normal, color: color),
                        MeshFace(v0: v0, v1: v6, v2: v7, normal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
    
    public static func diagonal(throne corner: GridCorner, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainEdgeLayer.crown, z: 0.0)
        
        let v0 = polyhedron.upperPolytope.vertices[corner.rawValue] - crown
        let v1 = polyhedron.upperPolytope.center - crown
        let v2 = polyhedron.lowerPolytope.center
        let v3 = polyhedron.lowerPolytope.vertices[corner.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal && !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            if c0equal {
                
                let v4 = SCNVector3.lerp(from: v3, to: v2, factor: TerrainEdgeLayer.crown)
                
                return [MeshFace(v0: v4, v1: v1, v2: v2, normal: normal, color: color)]
                
            }
                
            let v4 = SCNVector3.lerp(from: v2, to: v3, factor: TerrainEdgeLayer.crown)
                
            return [MeshFace(v0: v0, v1: v4, v2: v3, normal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, normal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, normal: normal, color: color)]
    }
}
