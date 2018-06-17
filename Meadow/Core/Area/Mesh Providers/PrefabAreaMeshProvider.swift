//
//  PrefabAreaMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 15/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class PrefabAreaMeshProvider
 @abstract Defines the methods required to generate Meshes for AreaNodes.
 */
public class PrefabAreaMeshProvider: AreaMeshProvider {
    
    /*!
     @method corner:polyhedron:corner:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param corner The GridCorner around which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func corner(polyhedron: Polyhedron, corner: GridCorner, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        return Mesh(faces: [])
    }
    
    /*!
     @method doorway:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func doorway(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        return Mesh(faces: [])
    }
    
    /*!
     @method wall:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func wall(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        let corners = GridCorner.Corners(edge: edge)
        
        let normal = GridEdge.Normal(edge: edge)
        
        let normals = [normal, normal, normal]
        
        let colors = [colorPalette.primary.vector, colorPalette.primary.vector, colorPalette.primary.vector]
        
        let c0 = corners.first!
        let c1 = corners.last!
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = polyhedron.lowerPolytope.vertices[c1.rawValue]
        let v3 = polyhedron.lowerPolytope.vertices[c0.rawValue]
        
        return Mesh(faces: [MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                            MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)])
    }
    
    /*!
     @method window:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    public func window(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh {
        
        return Mesh(faces: [])
    }
}
