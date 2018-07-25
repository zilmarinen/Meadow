//
//  TerrainMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public protocol TerrainMeshProvider {
    
    func terrainLayer(apex polyhedron: Polyhedron, corners: [GridCorner], color: SCNVector4) -> MeshFace
    func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace]
    func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace]
}

extension TerrainMeshProvider {
    
    public func terrainLayer(apex polyhedron: Polyhedron, corners: [GridCorner], color: SCNVector4) -> MeshFace {
        
        return MeshFace(vertices: [], normals: [], colors: [])
    }
    
    public func terrainLayer(crown corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        return []
    }
    
    public func terrainLayer(throne corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        return []
    }
}
