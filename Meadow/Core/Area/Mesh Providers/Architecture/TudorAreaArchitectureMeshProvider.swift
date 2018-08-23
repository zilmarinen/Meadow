//
//  TudorAreaArchitectureMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class TudorAreaArchitectureMeshProvider: AreaArchitectureMeshProvider {
    
    var door: SCNVector3 { return SCNVector3(x: 0.4, y: 0.8, z: 0.0) }

    var skirting: SCNVector3 { return SCNVector3(x: 0.05, y: 0.05, z: 0.01) }
    
    var transom: SCNVector3 { return SCNVector3(x: 0.4, y: 0.2, z: 0.0) }
    
    var window: SCNVector3 { return SCNVector3(x: 0.4, y: 0.45, z: 0.0) }
}

extension TudorAreaArchitectureMeshProvider {
    
    func areaNode(doorway edge: AreaNodeEdgeData, polyhedron: Polyhedron, fullWidth: Bool) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(skirting edge: AreaNodeEdgeData, polyhedron: Polyhedron) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(transom edge: AreaNodeEdgeData, polyhedron: Polyhedron) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(window edge: AreaNodeEdgeData, polyhedron: Polyhedron, fullWidth: Bool) -> [MeshFace] {
        
        return []
    }
}
