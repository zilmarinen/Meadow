//
//  BrickAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class BrickAreaNodeMeshProvider: AreaNodeMeshProvider {
    
    func areaNode(corner: AreaNodeCornerData) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(doorway edge: AreaNodeEdgeData, fullWidth: Bool, transom: Bool) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(wall edge: AreaNodeEdgeData) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(window edge: AreaNodeEdgeData, fullWidth: Bool) -> [MeshFace] {
        
        return []
    }
}
