//
//  ConcreteAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class ConcreteAreaNodeMeshProvider: AreaNodeMeshProvider {
    
    func areaNode(corner: AreaNodeCornerData) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let oppositeCorner = GridCorner.opposite(corner: corner.corner)
        
        let (e0, e1) = GridEdge.edges(corner: oppositeCorner)
        
        let (at0, at1) = (corner.architectureTypes.0, corner.architectureTypes.1)
        let (cp0, cp1) = (corner.colorPalettes.0, corner.colorPalettes.1)
        
        let wallInset = (corner.side == .exterior ? AreaNode.externalWallDepth : AreaNode.internalWallDepth)
        
        let (ec0, ec1) = GridCorner.corners(edge: e0)
        let (ec2, ec3) = GridCorner.corners(edge: e1)
        
        let c0 = (ec0 != oppositeCorner ? ec0 : ec1)
        let c1 = (ec2 != oppositeCorner ? ec2 : ec3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        var wallPolytope = corner.polyhedron.lowerPolytope
        
        [e0, e1].forEach { edge in
            
            wallPolytope = Polytope.inset(polytope: wallPolytope, edge: edge, inset: (1 - wallInset))
        }
        
        let surface = SCNVector3(x: 0.0, y: AreaNode.surface, z: 0.0)
        let skirtingPeak0 = SCNVector3(x: 0.0, y: (corner.side == .interior ? at0.meshProvider.skirting.y : 0.0), z: 0.0) + surface
        let skirtingPeak1 = SCNVector3(x: 0.0, y: (corner.side == .interior ? at1.meshProvider.skirting.y : 0.0), z: 0.0) + surface
        
        let w0 = wallPolytope.vertices[corner.corner.rawValue]
        let w1 = wallPolytope.vertices[c0.rawValue]
        let w2 = wallPolytope.vertices[oppositeCorner.rawValue]
        let w3 = wallPolytope.vertices[c1.rawValue]
        
        let v0 = SCNVector3(x: w0.x, y: corner.polyhedron.upperPolytope.vertices[corner.corner.rawValue].y, z: w0.z)
        let v1 = SCNVector3(x: w1.x, y: corner.polyhedron.upperPolytope.vertices[c0.rawValue].y, z: w1.z)
        let v2 = SCNVector3(x: w2.x, y: corner.polyhedron.upperPolytope.vertices[oppositeCorner.rawValue].y, z: w2.z)
        let v3 = SCNVector3(x: w3.x, y: corner.polyhedron.upperPolytope.vertices[c1.rawValue].y, z: w3.z)
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: cp1.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v1, v2: (w1 + skirtingPeak0), projectedNormal: n0, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: (w1 + skirtingPeak0), v2: (w2 + skirtingPeak0), projectedNormal: n0, color: cp0.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v2, v2: (w2 + skirtingPeak1), projectedNormal: n1, color: cp1.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (w2 + skirtingPeak1), v2: (w3 + skirtingPeak1), projectedNormal: n1, color: cp1.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(doorway edge: AreaNodeEdgeData, fullWidth: Bool, transom: Bool) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let skirtingWidth = (edge.architectureType.meshProvider.skirting.x * 2)
        let windowWidth = (edge.architectureType.meshProvider.window.x * (fullWidth ? 2 : 1))
        let frameOffset = ((1 - (windowWidth + skirtingWidth)) / 2)
        let transomLintelHeight = ((Axis.Y(y: AreaNode.areaHeight) - (edge.architectureType.meshProvider.door.y + edge.architectureType.meshProvider.transom.y)) / 2)
        
        let framePeak = SCNVector3(x: 0.0, y: edge.architectureType.meshProvider.door.y, z: 0.0)
        let surface = SCNVector3(x: 0.0, y: AreaNode.surface, z: 0.0)
        let skirtingPeak = SCNVector3(x: 0.0, y: (edge.side == .interior ? edge.architectureType.meshProvider.skirting.y : 0.0), z: 0.0) + surface
        
        let w0 = edge.wall.vertices[c0.rawValue]
        let w1 = edge.wall.vertices[c1.rawValue]
        
        let f0 = SCNVector3.lerp(from: w0, to: w1, factor: frameOffset)
        let f1 = SCNVector3.lerp(from: w1, to: w0, factor: frameOffset)
        
        let v0 = edge.polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = edge.polyhedron.upperPolytope.vertices[c1.rawValue]
        
        let v2 = SCNVector3(x: edge.wall.vertices[c1.rawValue].x, y: v1.y, z: edge.wall.vertices[c1.rawValue].z)
        let v3 = SCNVector3(x: edge.wall.vertices[c0.rawValue].x, y: v0.y, z: edge.wall.vertices[c0.rawValue].z)
        
        let v4 = SCNVector3(x: f0.x, y: v3.y, z: f0.z)
        let v5 = SCNVector3(x: f1.x, y: v2.y, z: f1.z)
        let v6 = f0 + framePeak
        let v7 = f1 + framePeak
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v4, v2: (f0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (f0 + skirtingPeak), v2: (w0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v5, v1: v2, v2: (w1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: (w1 + skirtingPeak), v2: (f1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        if transom {
            
            let transomBase = SCNVector3(x: 0.0, y: ((framePeak.y + transomLintelHeight) - edge.architectureType.meshProvider.skirting.y), z: 0.0)
            let transomPeak = SCNVector3(x: 0.0, y: ((framePeak.y + transomLintelHeight + edge.architectureType.meshProvider.transom.y) + edge.architectureType.meshProvider.skirting.y), z: 0.0)
            
            let v8 = f0 + transomBase
            let v9 = f1 + transomBase
            let v10 = f0 + transomPeak
            let v11 = f1 + transomPeak
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v11, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v11, v2: v10, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            
            meshFaces.append(MeshFace(v0: v8, v1: v9, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v8, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        }
        else {
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        }
        
        return meshFaces
    }
    
    func areaNode(wall edge: AreaNodeEdgeData) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)

        let surface = SCNVector3(x: 0.0, y: AreaNode.surface, z: 0.0)
        let skirtingPeak = SCNVector3(x: 0.0, y: (edge.side == .interior ? edge.architectureType.meshProvider.skirting.y : 0.0), z: 0.0) + surface
        
        let w0 = edge.wall.vertices[c0.rawValue]
        let w1 = edge.wall.vertices[c1.rawValue]
        
        let v0 = edge.polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = edge.polyhedron.upperPolytope.vertices[c1.rawValue]
        
        let v2 = SCNVector3(x: edge.wall.vertices[c1.rawValue].x, y: v1.y, z: edge.wall.vertices[c1.rawValue].z)
        let v3 = SCNVector3(x: edge.wall.vertices[c0.rawValue].x, y: v0.y, z: edge.wall.vertices[c0.rawValue].z)
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v2, v2: (w1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (w1 + skirtingPeak), v2: (w0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(window edge: AreaNodeEdgeData, fullWidth: Bool) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let skirtingWidth = (edge.architectureType.meshProvider.skirting.x * 2)
        let windowWidth = (edge.architectureType.meshProvider.window.x * (fullWidth ? 2 : 1))
        let frameOffset = ((1 - (windowWidth + skirtingWidth)) / 2)
        
        let frameBase = SCNVector3(x: 0.0, y: (edge.architectureType.meshProvider.door.y - edge.architectureType.meshProvider.window.y), z: 0.0)
        let framePeak = SCNVector3(x: 0.0, y: edge.architectureType.meshProvider.door.y, z: 0.0)
        let surface = SCNVector3(x: 0.0, y: AreaNode.surface, z: 0.0)
        let skirtingPeak = SCNVector3(x: 0.0, y: (edge.side == .interior ? edge.architectureType.meshProvider.skirting.y : 0.0), z: 0.0) + surface
        
        let w0 = edge.wall.vertices[c0.rawValue]
        let w1 = edge.wall.vertices[c1.rawValue]
        
        let f0 = SCNVector3.lerp(from: w0, to: w1, factor: frameOffset)
        let f1 = SCNVector3.lerp(from: w1, to: w0, factor: frameOffset)
        
        let v0 = edge.polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = edge.polyhedron.upperPolytope.vertices[c1.rawValue]
        
        let v2 = SCNVector3(x: edge.wall.vertices[c1.rawValue].x, y: v1.y, z: edge.wall.vertices[c1.rawValue].z)
        let v3 = SCNVector3(x: edge.wall.vertices[c0.rawValue].x, y: v0.y, z: edge.wall.vertices[c0.rawValue].z)
        
        let v4 = SCNVector3(x: f0.x, y: v3.y, z: f0.z)
        let v5 = SCNVector3(x: f1.x, y: v2.y, z: f1.z)
        let v6 = f0 + framePeak
        let v7 = f1 + framePeak
        let v8 = f0 + frameBase
        let v9 = f1 + frameBase
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v4, v2: (f0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (f0 + skirtingPeak), v2: (w0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))

        meshFaces.append(MeshFace(v0: v5, v1: v2, v2: (w1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: (w1 + skirtingPeak), v2: (f1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))

        meshFaces.append(MeshFace(v0: v8, v1: v9, v2: (f1 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: (f1 + skirtingPeak), v2: (f0 + skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
}
