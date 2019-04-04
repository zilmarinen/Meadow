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
    
    public static func quad(vertices: [SCNVector3], projectedNormal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        guard vertices.count >= 4 else { return [] }
        
        let v0 = vertices[0]
        let v1 = vertices[1]
        let v2 = vertices[2]
        let v3 = vertices[3]
        
        return [ MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: projectedNormal, color: color),
                 MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: projectedNormal, color: color)]
    }
    
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
        
        guard !c0equal || !c1equal else { return [] }
        
        let acuteCorner = (c0equal ? corners.c0 : (c1equal ? corners.c1 : nil))
        
        if let acuteCorner = acuteCorner {
            
            let v4 = (acuteCorner == corners.c0 ? v2: v3)
            
            return [MeshFace(v0: v0, v1: v1, v2: v4, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: normal, color: color)]
    }
    
    public static func edge(crown corners: (c0: GridCorner, c1: GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polyhedron.upperPolytope.vertices[corners.c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[corners.c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[corners.c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[corners.c0.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal || !c1equal else { return [] }
        
        let crown = SCNVector3(x: 0.0, y: TerrainNodeEdgeLayer.crown, z: 0.0)
        
        let v4 = v0 - crown
        let v5 = v1 - crown
        
        if c0equal || c1equal {
            
            let v6 = (c0equal ? v5 : SCNVector3.lerp(from: v2, to: v3, factor: TerrainNodeEdgeLayer.crown))
            let v7 = (c1equal ? v4 : SCNVector3.lerp(from: v3, to: v2, factor: TerrainNodeEdgeLayer.crown))
            
            return [    MeshFace(v0: v0, v1: v1, v2: v6, projectedNormal: normal, color: color),
                        MeshFace(v0: v0, v1: v6, v2: v7, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v5, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v4, v2: v5, projectedNormal: normal, color: color)]
    }
    
    public static func edge(throne corners: (c0: GridCorner, c1: GridCorner), polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polyhedron.upperPolytope.vertices[corners.c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[corners.c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[corners.c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[corners.c0.rawValue]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal || !c1equal else { return [] }
        
        let crown = SCNVector3(x: 0.0, y: TerrainNodeEdgeLayer.crown, z: 0.0)
        
        let v4 = v0 - crown
        let v5 = v1 - crown
    
        if c0equal || c1equal {
            
            let v6 = (c0equal ? v5 : SCNVector3.lerp(from: v2, to: v3, factor: TerrainNodeEdgeLayer.crown))
            let v7 = (c1equal ? v4 : SCNVector3.lerp(from: v3, to: v2, factor: TerrainNodeEdgeLayer.crown))
            let v8 = (c0equal ? v2 : v3)
            
            return [MeshFace(v0: v6, v1: v7, v2: v8, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v2, v1: v4, v2: v5, projectedNormal: normal, color: color),
                MeshFace(v0: v2, v1: v4, v2: v3, projectedNormal: normal, color: color)]
    }
    
    public static func diagonal(polytope: Polytope, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal || !c1equal else { return [] }
        
        if c0equal || c1equal {
            
            let v4 = (c0equal ? v2: v3)
            
            return [MeshFace(v0: v0, v1: v1, v2: v4, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: normal, color: color)]
    }
    
    public static func diagonal(crown polytope: Polytope, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal || !c1equal else { return [] }
        
        let crown = SCNVector3(x: 0.0, y: TerrainNodeEdgeLayer.crown, z: 0.0)
        
        let v4 = v0 - crown
        let v5 = v1 - crown
        
        if c0equal || c1equal {
            
            let v6 = (c0equal ? v5 : SCNVector3.lerp(from: v2, to: v3, factor: TerrainNodeEdgeLayer.crown))
            let v7 = (c1equal ? v4 : SCNVector3.lerp(from: v3, to: v2, factor: TerrainNodeEdgeLayer.crown))
            
            return [    MeshFace(v0: v0, v1: v1, v2: v6, projectedNormal: normal, color: color),
                        MeshFace(v0: v0, v1: v6, v2: v7, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v0, v1: v1, v2: v5, projectedNormal: normal, color: color),
                MeshFace(v0: v0, v1: v4, v2: v5, projectedNormal: normal, color: color)]
    }
    
    public static func diagonal(throne polytope: Polytope, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        let c0equal = Axis.Y(y: v0.y) == Axis.Y(y: v3.y)
        let c1equal = Axis.Y(y: v1.y) == Axis.Y(y: v2.y)
        
        guard !c0equal || !c1equal else { return [] }
        
        let crown = SCNVector3(x: 0.0, y: TerrainNodeEdgeLayer.crown, z: 0.0)
        
        let v4 = v0 - crown
        let v5 = v1 - crown
        
        if c0equal || c1equal {
            
            let v6 = (c0equal ? v5 : SCNVector3.lerp(from: v2, to: v3, factor: TerrainNodeEdgeLayer.crown))
            let v7 = (c1equal ? v4 : SCNVector3.lerp(from: v3, to: v2, factor: TerrainNodeEdgeLayer.crown))
            let v8 = (c0equal ? v2 : v3)
            
            return [MeshFace(v0: v6, v1: v7, v2: v8, projectedNormal: normal, color: color)]
        }
        
        return [MeshFace(v0: v2, v1: v4, v2: v5, projectedNormal: normal, color: color),
                MeshFace(v0: v2, v1: v3, v2: v4, projectedNormal: normal, color: color)]
    }
}
