//
//  WoodAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class WoodAreaNodeMeshProvider: AreaNodeMeshProvider {
    
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets, transom: Bool) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        return meshFaces
    }
    
    func areaNode(wall corner: AreaNodeCornerData, insets: (AreaArchitectureInsets, AreaArchitectureInsets), offsets: (AreaArchitectureOffsets, AreaArchitectureOffsets)) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        return meshFaces
    }
    
    func areaNode(wall edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        return meshFaces
    }
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        return meshFaces
    }
}
