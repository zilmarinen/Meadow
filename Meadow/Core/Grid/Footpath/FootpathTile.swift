//
//  FootpathTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class FootpathTile: LayeredTile<FootpathEdge, FootpathLayer> {
    
    enum Constants {
        
        static let height = 4
        static let inset = 0.1
        static let insetSquared = 0.1414213562
        static let surface = Vector(x: 0.0, y: 0.001, z: 0.0)
    }
    
    public override var category: SceneGraphNodeCategory { return .footpath }
    
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
    
    override func shouldRender(face edge: Int, atIndex index: Int) -> Bool {
        
        return false
    }
    
    override func colorPalette(apex edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.footpathType.primaryColor, secondary: layer.footpathType.secondaryColor)
    }

    override func colorPalette(face edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.footpathType.primaryColor, secondary: layer.footpathType.secondaryColor)
    }
    
    override func apex(for edge: Int, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon? {

        guard shouldRender(apex: edge, atIndex: index), let edgeIndex = joints.firstIndex(of: edge) else { return nil }

        let normal = polyhedron.upper.normal

        let color = colorPalette(apex: edge, atIndex: index)
        
        let p0 = polyhedron.lower.p0.vector + Constants.surface
        let p1 = polyhedron.lower.p1.vector + Constants.surface
        let p2 = polyhedron.lower.p2.vector + Constants.surface
        
        let i0 = p0.lerp(vector: p1, interpolater: Constants.insetSquared)
        let i2 = p2.lerp(vector: p1, interpolater: Constants.insetSquared)

        let v0 = Vertex(position: i0, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[edgeIndex])
        let v1 = Vertex(position: p1, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs.last!)
        let v2 = Vertex(position: i2, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[((edgeIndex + 1) % joints.count)])
        
        guard let neighbour = find(neighbour: edge), neighbour.find(edge: edge) != nil else { return Pasture.Polygon(vertices: [v0, v1, v2]) }
        
        let (n0, n2) = neighbour.neighbourIndices(for: edge)
        let e0 = neighbour.find(neighbour: n0)
        let e2 = neighbour.find(neighbour: n2)
        
        let j0 = (e0 == nil ? p0.lerp(vector: p2, interpolater: Constants.inset) : p0)
        let j2 = (e2 == nil ? p2.lerp(vector: p0, interpolater: Constants.inset) : p2)
        
        let v3 = Vertex(position: j0, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[edgeIndex])
        let v4 = Vertex(position: j2, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[((edgeIndex + 1) % joints.count)])

        return Pasture.Polygon(vertices: [v0, v1, v2, v4, v3])
    }
}
