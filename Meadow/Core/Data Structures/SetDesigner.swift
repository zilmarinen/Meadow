//
//  SetDesigner.swift
//  Meadow
//
//  Created by Zack Brown on 17/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public class SetDesigner {
    
    public static let sharedInstance = SetDesigner()
    
    public func area(corner: GridCorner, edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState) -> [MeshFace] {
        
        //
        
        return []
    }
    
    public func area(edge: AreaNodeEdge.Graph, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, edgeFace: AreaNodeEdgeFace, renderState: AreaNodeEdge.RenderState, size: Size<MDWFloat>) -> [MeshFace] {
        
        let apexPolytope = (renderState == .raised ? polyhedron.upperPolytope : Polytope.translate(polytope: polyhedron.lowerPolytope, translation: SCNVector3(x: 0.0, y: size.height, z: 0.0)))
        
        let edgePolyhedron = Polyhedron(upperPolytope: apexPolytope, lowerPolytope: polyhedron.lowerPolytope)
        
        let edgePolytopes = polytopes(graph: edge, polyhedron: edgePolyhedron, edgeType: edgeType, renderState: renderState, size: size)
        
        switch edgeType {
            
        case .door:
            
            return edgeFace.material.meshBuilder.area(door: edge, edgeType: edgeType, edgeFace: edgeFace, renderState: renderState, polytopes: edgePolytopes)
            
        case .wall:
            
            return edgeFace.material.meshBuilder.area(wall: edge, edgeType: edgeType, edgeFace: edgeFace, renderState: renderState, polytopes: edgePolytopes)
            
        case .window:
            
            return edgeFace.material.meshBuilder.area(window: edge, edgeType: edgeType, edgeFace: edgeFace, renderState: renderState, polytopes: edgePolytopes)
        }
    }
}

extension SetDesigner {
    
    func polytopes(graph: AreaNodeEdge.Graph, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, renderState: AreaNodeEdge.RenderState, size: Size<MDWFloat>) -> AreaNodeEdge.Polytopes {
        
        var wallPolyhedron = Polyhedron.inset(polyhedron: polyhedron, edge: graph.edge, inset: size.depth)
        
        if let intersector = graph.intersector.e0 {
            
            wallPolyhedron = Polyhedron.inset(polyhedron: wallPolyhedron, edge: intersector.edge, inset: size.depth)
        }
        
        if let intersector = graph.intersector.e1 {
            
            wallPolyhedron = Polyhedron.inset(polyhedron: wallPolyhedron, edge: intersector.edge, inset: size.depth)
        }
        
        let edges = GridEdge.edges(edge: graph.edge)
        
        var edgeCutawayPolyhedron = polyhedron
        
        switch edgeType {
            
        case .door(let door):
            
            let cutawayWidth = (Axis.unitXZ - (door.doorType.meshBuilder.size.width)) / 2
            
            edgeCutawayPolyhedron = Polyhedron.inset(polyhedron: edgeCutawayPolyhedron, edge: edges.e0, inset: cutawayWidth)
            edgeCutawayPolyhedron = Polyhedron.inset(polyhedron: edgeCutawayPolyhedron, edge: edges.e1, inset: cutawayWidth)
            
            if renderState == .raised {
                
                edgeCutawayPolyhedron = Polyhedron(upperPolytope: Polytope.translate(polytope: edgeCutawayPolyhedron.lowerPolytope, translation: SCNVector3(x: 0.0, y: door.doorType.meshBuilder.size.height, z: 0.0)), lowerPolytope: edgeCutawayPolyhedron.lowerPolytope)
            }
            
        case .window(let window):
            
            if renderState == .raised {
                
                let cutawayWidth = (Axis.unitXZ - (window.windowType.meshBuilder.size.width)) / 2
                
                edgeCutawayPolyhedron = Polyhedron.inset(polyhedron: edgeCutawayPolyhedron, edge: edges.e0, inset: cutawayWidth)
                edgeCutawayPolyhedron = Polyhedron.inset(polyhedron: edgeCutawayPolyhedron, edge: edges.e1, inset: cutawayWidth)
            }
            
        default: break
        }
        
        let wallCutawayPolyhedron = Polyhedron.inset(polyhedron: edgeCutawayPolyhedron, edge: graph.edge, inset: size.depth)
        
        return AreaNodeEdge.Polytopes(edge: Polyhedron.edge(polyhedron: polyhedron, edge: graph.edge),
                                      wall: Polyhedron.edge(polyhedron: wallPolyhedron, edge: graph.edge),
                                      edgeCutaway: Polyhedron.edge(polyhedron: edgeCutawayPolyhedron, edge: graph.edge),
                                      wallCutaway: Polyhedron.edge(polyhedron: wallCutawayPolyhedron, edge: graph.edge))
    }
}
