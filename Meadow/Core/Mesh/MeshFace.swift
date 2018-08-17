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
