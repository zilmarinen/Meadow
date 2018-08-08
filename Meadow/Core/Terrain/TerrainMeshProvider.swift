//
//  TerrainMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public protocol TerrainMeshProvider {
    
    func terrainLayer(apex corners: [GridCorner], polytope: Polytope, color: SCNVector4) -> MeshFace
    
    func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace]
    
    func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace]
    
    func terrainLayer(edge corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace]
}

extension TerrainMeshProvider {
    
    public func terrainLayer(apex corners: [GridCorner], polytope: Polytope, color: SCNVector4) -> MeshFace {
        
        let (c0, c1) = (corners.first!, corners.last!)
        
        let v0 = polytope.vertices[c0.rawValue]
        let v1 = polytope.center
        let v2 = polytope.vertices[c1.rawValue]
        
        let apexNormal = v0 + SCNVector3.Up
        
        let plane = Plane(v0: v0, v1: v1, v2: v2)
        
        var normal = plane.normal
        
        if plane.side(vector: apexNormal) == .interior {
            
            normal = SCNVector3.negate(vector: plane.normal)
        }
        
        return MeshFace(vertices: [v0, v1, v2], normals: [normal, normal, normal], colors: [color, color, color])
    }
    
    public func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.first!, corners.last!)
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = v1 - crown
        let v3 = v0 - crown
        
        if let acuteCorner = acuteCorner {
            
            let v4 = polyhedron.lowerPolytope.vertices[c0.rawValue]
            let v5 = polyhedron.lowerPolytope.vertices[c1.rawValue]
            
            let v6 = (acuteCorner == c0 ? v2 : SCNVector3.lerp(from: v5, to: v4, factor: TerrainLayer.crown))
            let v7 = (acuteCorner == c1 ? v3 : SCNVector3.lerp(from: v4, to: v5, factor: TerrainLayer.crown))
            
            return [    MeshFace(vertices: [v0, v1, v6], normals: normals, colors: colors),
                        MeshFace(vertices: [v0, v6, v7], normals: normals, colors: colors)]
        }
        
        return [MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)]
    }
    
    public func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.first!, corners.last!)
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue] - crown
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue] - crown
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        if let acuteCorner = acuteCorner {
            
            switch acuteCorner {
                
            case c0:
                
                let v4 = SCNVector3.lerp(from: v3, to: v2, factor: TerrainLayer.crown)
                
                return [MeshFace(vertices: [v4, v1, v2], normals: normals, colors: colors)]
                
            default:
            
                let v4 = SCNVector3.lerp(from: v2, to: v3, factor: TerrainLayer.crown)
            
                return [MeshFace(vertices: [v0, v4, v3], normals: normals, colors: colors)]
            }
        }
        
        return [MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)]
    }
    
    public func terrainLayer(edge corners: [GridCorner], acuteCorner: GridCorner?, polyhedron: Polyhedron, normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let (c0, c1) = (corners.first!, corners.last!)
        
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        if let acuteCorner = acuteCorner {
            
            let v0 = (acuteCorner == c0 ? v1 : v0)
            let v1 = (acuteCorner == c1 ? v2 : v3)
            let v2 = SCNVector3.lerp(from: polyhedron.upperPolytope.vertices[acuteCorner.rawValue], to: v1, factor: TerrainLayer.crown)
            
            let i0 = (acuteCorner == corners.first ? v0 : v1)
            let i1 = (acuteCorner == corners.first ? v1 : v0)
            
            return [MeshFace(vertices: [i0, i1, v2], normals: normals, colors: colors)]
        }
        
        return [MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)]
    }
}
