//
//  TerrainMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public protocol TerrainMeshProvider {
    
    func terrainLayer(apex vertices: [SCNVector3], color: SCNVector4) -> MeshFace
    func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace]
    func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace]
}

extension TerrainMeshProvider {
    
    public func terrainLayer(apex vertices: [SCNVector3], color: SCNVector4) -> MeshFace {
        
        let apexNormal = vertices[0] + SCNVector3.Up
        
        let plane = Plane(v0: vertices[0], v1: vertices[1], v2: vertices[2])
        
        var normal = plane.normal
        
        if plane.side(vector: apexNormal) == .interior {
            
            normal = SCNVector3.negate(vector: plane.normal)
        }
        
        return MeshFace(vertices: vertices, normals: [normal, normal, normal], colors: [color, color, color])
    }
    
    public func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        if let acuteCorner = acuteCorner {
            
            let v0 = vertices[0]
            let v1 = vertices[1]
            let v2 = (acuteCorner == corners.first ? vertices[1] - crown : SCNVector3.lerp(from: vertices[2], to: vertices[3], factor: TerrainLayer.crown))
            let v3 = (acuteCorner == corners.first ? SCNVector3.lerp(from: vertices[3], to: vertices[2], factor: TerrainLayer.crown) : vertices[0] - crown)
            
            return [    MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                        MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)]
        }
        
        return [    MeshFace(vertices: [vertices[0], vertices[1], vertices[1] - crown], normals: normals, colors: colors),
                    MeshFace(vertices: [vertices[0], vertices[1] - crown, vertices[0] - crown], normals: normals, colors: colors)]
    }
    
    public func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        if let acuteCorner = acuteCorner {
            
            let v0 = (acuteCorner == corners.first ? vertices[1] : vertices[0]) - crown
            let v1 = (acuteCorner == corners.first ? vertices[2] : vertices[3])
            let v2 = SCNVector3.lerp(from: vertices[acuteCorner.rawValue], to: v1, factor: TerrainLayer.crown)
            
            let i0 = (acuteCorner == corners.first ? v0 : v1)
            let i1 = (acuteCorner == corners.first ? v1 : v0)
            
            return [MeshFace(vertices: [i0, i1, v2], normals: normals, colors: colors)]
        }
        
        return [    MeshFace(vertices: [vertices[0] - crown, vertices[1] - crown, vertices[2]], normals: normals, colors: colors),
                    MeshFace(vertices: [vertices[0] - crown, vertices[2], vertices[3]], normals: normals, colors: colors)]
    }
}
