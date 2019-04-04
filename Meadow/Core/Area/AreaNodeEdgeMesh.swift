//
//  AreaNodeEdgeMesh.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public protocol AreaNodeEdgeMesh {
    
    func area(door graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace]
    func area(wall graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace]
    func area(window graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace]
}

extension AreaNodeEdgeMesh {
    
    public func area(door graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace] {
        
        return []
    }
    
    public func area(wall graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace] {
        
        let edgeNormal = GridEdge.normal(edge: GridEdge.opposite(edge: graph.edge))
        
        let v0 = polytopes.edge.vertices[0]
        let v1 = polytopes.edge.vertices[1]
        let v2 = polytopes.wall.vertices[1]
        let v3 = polytopes.wall.vertices[0]
        
        var faces: [MeshFace] = []
        
        faces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edgeFace.colorPalette.primary.vector))
        faces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edgeFace.colorPalette.quaternary.vector))
        faces.append(contentsOf: MeshFace.quad(vertices: polytopes.wall.vertices, projectedNormal: edgeNormal, color: edgeFace.colorPalette.secondary.vector))
        
        return faces
    }
    
    public func area(window graph: AreaNodeEdge.Graph, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, polytopes: AreaNodeEdge.Polytopes) -> [MeshFace] {
        
        return []
    }
}
