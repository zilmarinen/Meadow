//
//  AreaArchitectureMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

protocol AreaArchitectureMeshProvider {
    
    var door: SCNVector3 { get }
    var skirting: SCNVector3 { get }
    var transom: SCNVector3 { get }
    var window: SCNVector3 { get }
    
    func areaNode(doorway edge: AreaNodeEdgeData, polyhedron: Polyhedron, fullWidth: Bool) -> [MeshFace]
    
    func areaNode(skirting edge: AreaNodeEdgeData, polyhedron: Polyhedron) -> [MeshFace]
    
    func areaNode(transom edge: AreaNodeEdgeData, polyhedron: Polyhedron) -> [MeshFace]
    
    func areaNode(window edge: AreaNodeEdgeData, polyhedron: Polyhedron, fullWidth: Bool) -> [MeshFace]
}
