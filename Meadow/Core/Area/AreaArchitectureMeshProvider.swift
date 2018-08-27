//
//  AreaArchitectureMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

struct AreaArchitectureInsets {
    
    let wall: MDWFloat
    let skirting: MDWFloat
    let frame: MDWFloat
    let cutaway: MDWFloat
}

struct AreaArchitectureOffsets {
    
    let wallPeak: SCNVector3
    let transomFramePeak: SCNVector3
    let transomPeak: SCNVector3
    let transomBase: SCNVector3
    let transomFrameBase: SCNVector3
    let lintelFramePeak: SCNVector3
    let lintelPeak: SCNVector3
    let windowBase: SCNVector3
    let windowFrameBase: SCNVector3
    let skirtingPeak: SCNVector3
    let surface: SCNVector3
}

protocol AreaArchitectureMeshProvider {
    
    var door: SCNVector3 { get }
    var frame: SCNVector3 { get }
    var skirting: SCNVector3 { get }
    var transom: SCNVector3 { get }
    var window: SCNVector3 { get }
    
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
    
    func areaNode(skirting edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
    
    func areaNode(transom edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
}
