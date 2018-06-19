//
//  PrefabAreaMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 15/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class PrefabAreaMeshProvider
 @abstract Defines the methods required to generate Meshes for AreaNodes.
 */
public class PrefabAreaMeshProvider: AreaMeshProvider {
    
    /*!
     @method corner:node:corner:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param corner The GridCorner around which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func corner(node: AreaNode, corner: GridCorner, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh? {
        
        let inset = MDWFloat(side == .exterior ? PrefabAreaMeshProvider.ExternalCrownInset : PrefabAreaMeshProvider.InternalCrownInset)
        
        let unitXZ = (World.UnitXZ * 2.0)
        
        var polyhedron = node.polyhedron
        
        if side == .exterior {
            
            let extent = GridCorner.Extent(corner: corner)
            
            polyhedron = Polyhedron.Translate(polyhedron: polyhedron, translation: SCNVector3(x: MDWFloat(extent.x), y: 0.0, z: MDWFloat(extent.z)))
        }
        
        GridEdge.Edges(corner: corner).forEach { connectedEdge in
         
            switch side {
                
            case .exterior:
                
                polyhedron = Polyhedron.Inset(polyhedron: polyhedron, edge: connectedEdge, inset: (unitXZ - inset))
                
            case .interior:
                
                let oppositeEdge = GridEdge.Opposite(edge: connectedEdge)
                
                polyhedron = Polyhedron.Inset(polyhedron: polyhedron, edge: oppositeEdge, inset: (unitXZ - inset))
            }
        }
        
        let apexColors = [colorPalette.primary.vector, colorPalette.primary.vector, colorPalette.primary.vector]
        let edgeColors = [colorPalette.tertiary.vector, colorPalette.tertiary.vector, colorPalette.tertiary.vector]
        
        var faces: [MeshFace] = []
        
        let edges = GridEdge.Edges(corner: (side == .exterior ? corner : GridCorner.Opposite(corner: corner)))
        
        edges.forEach { connectedEdge in
        
            let corners = GridCorner.Corners(edge: connectedEdge)
            
            let c0 = corners.first!
            let c1 = corners.last!
            
            let normal = GridEdge.Normal(edge: connectedEdge)
            
            let normals = [normal, normal, normal]
            
            let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
            let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
            let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
            let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
            
            faces.append(MeshFace(vertices: [v0, v1, v2], normals: normals, colors: edgeColors))
            faces.append(MeshFace(vertices: [v0, v2, v3], normals: normals, colors: edgeColors))
        }
        
        let apexNormals = [SCNVector3.Up, SCNVector3.Up, SCNVector3.Up]
        
        faces.append(MeshFace(vertices: [polyhedron.upperPolytope.vertices[0], polyhedron.upperPolytope.vertices[2], polyhedron.upperPolytope.vertices[1]], normals: apexNormals, colors: apexColors))
        faces.append(MeshFace(vertices: [polyhedron.upperPolytope.vertices[0], polyhedron.upperPolytope.vertices[3], polyhedron.upperPolytope.vertices[2]], normals: apexNormals, colors: apexColors))
        
        return Mesh(faces: faces)
    }
    
    /*!
     @method doorway:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func doorway(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        return Mesh(faces: [])
    }
    
    /*!
     @method wall:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func wall(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        let inset = MDWFloat(side == .exterior ? PrefabAreaMeshProvider.ExternalCrownInset : PrefabAreaMeshProvider.InternalCrownInset)
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        var corners = GridCorner.Corners(edge: edge)
        
        var polyhedron = node.polyhedron
        
        if side == .exterior {
            
            let extent = GridEdge.Extent(edge: edge)
            
            polyhedron = Polyhedron.Translate(polyhedron: polyhedron, translation: SCNVector3(x: MDWFloat(extent.x), y: 0.0, z: MDWFloat(extent.z)))
        }
        
        var insetPolyhedron = Polyhedron.Inset(polyhedron: polyhedron, edge: (side == .interior ? edge : oppositeEdge), inset: inset)
        
        switch side {
            
        case .exterior:
            
            corners.forEach { corner in
                
                if let diagonal = node.find(neighbour: corner)?.node as? AreaNode {
                    
                    let connectedEdge = GridEdge.Edges(corner: corner).first { $0 != edge }!
                    
                    let oppositeEdge = GridEdge.Opposite(edge: connectedEdge)
                    
                    if diagonal.get(perimeterEdge: oppositeEdge) != nil {
                    
                        insetPolyhedron = Polyhedron.Inset(polyhedron: insetPolyhedron, edge: oppositeEdge, inset: inset)
                    }
                }
            }
            
            corners = GridCorner.Corners(edge: oppositeEdge)
            
        default:
         
            GridEdge.Edges(edge: edge).forEach { connectedEdge in
                
                if node.get(perimeterEdge: connectedEdge) != nil {
                    
                    insetPolyhedron = Polyhedron.Inset(polyhedron: insetPolyhedron, edge: connectedEdge, inset: inset)
                }
            }
        }
        
        let c0 = corners.first!
        let c1 = corners.last!
        
        let v0 = insetPolyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = insetPolyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = insetPolyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = insetPolyhedron.lowerPolytope.vertices[c0.rawValue]
        
        let v4 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v5 = polyhedron.upperPolytope.vertices[c1.rawValue]
        
        let normal = GridEdge.Normal(edge: (side == .exterior ? edge : oppositeEdge))
        
        let apexNormals = [SCNVector3.Up, SCNVector3.Up, SCNVector3.Up]
        let edgeNormals = [normal, normal, normal]
        
        let apexColors = [colorPalette.primary.vector, colorPalette.primary.vector, colorPalette.primary.vector]
        let edgeColors = [colorPalette.tertiary.vector, colorPalette.tertiary.vector, colorPalette.tertiary.vector]
        
        return Mesh(faces: [MeshFace(vertices: [v5, v4, v0], normals: apexNormals, colors: apexColors),
                            MeshFace(vertices: [v5, v0, v1], normals: apexNormals, colors: apexColors),
                            MeshFace(vertices: [v0, v3, v1], normals: edgeNormals, colors: edgeColors),
                            MeshFace(vertices: [v1, v3, v2], normals: edgeNormals, colors: edgeColors)])
    }
    
    /*!
     @method window:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func window(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        return Mesh(faces: [])
    }
}

extension PrefabAreaMeshProvider {
    
    /*!
     @property externalCrownInset
     @abstract Defines the fixed value by which AreaNode Polytope vertices will be inset.
     */
    static var ExternalCrownInset: MDWFloat = 0.08
    
    /*!
     @property internalCrownInset
     @abstract Defines the fixed value by which AreaNode Polytope vertices will be inset.
     */
    static var InternalCrownInset: MDWFloat = 0.04
}
