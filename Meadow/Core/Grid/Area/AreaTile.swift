//
//  AreaTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class AreaTile: LayeredTile<AreaEdge, AreaLayer> {
    
    enum Constants {
        
        static let height = 4
    }
    
    public override var category: SceneGraphNodeCategory { return .area }
    
    override func polytope(forApex edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }
        
        let (v0, centre, v1) = vertices(for: edge)

        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation + Constants.height, vector: v0)
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation + Constants.height, vector: centre)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation + Constants.height, vector: v1)

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
    override func polytope(forThrone edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let layer = find(edge: edge)?.find(layer: index) else { return nil }
        
        let (v0, centre, v1) = vertices(for: edge)

        let p0 = GridMesh.Elevation(elevation: layer.corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: layer.corners.centre.elevation, vector: centre)
        let p2 = GridMesh.Elevation(elevation: layer.corners.right.elevation, vector: v1)

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }
    
//    override func apex(for edge: Int, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon? {
//
//        guard shouldRender(apex: edge, atIndex: index), let edgeIndex = joints.firstIndex(of: edge) else { return nil }
//
//        let normal = polyhedron.lower.normal
//
//        let color = colorPalette(apex: edge, atIndex: index)
//
//        let v0 = Vertex(position: polyhedron.lower.p0.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[edgeIndex])
//        let v1 = Vertex(position: polyhedron.lower.p1.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs.last!)
//        let v2 = Vertex(position: polyhedron.lower.p2.vector, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[((edgeIndex + 1) % joints.count)])
//
//        return Pasture.Polygon(vertices: [v0, v1, v2])
//    }
}
