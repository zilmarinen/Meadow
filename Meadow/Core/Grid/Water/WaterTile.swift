//
//  WaterTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class WaterTile: LayeredTile<WaterEdge, WaterLayer> {
    
    enum Constants {
        
        static let meniscus = Vector(x: 0.0, y: World.Constants.yStep / 3.0, z: 0.0)
    }
    
    public override var category: SceneGraphNodeCategory { return .water }

    override func polytope(forThrone edge: Int, atIndex index: Int) -> GridMesh.Polytope? {

        guard let tileEdge = find(edge: edge), let edgeIndex = joints.firstIndex(of: edge) else { return nil }

        let c0 = vectors[edgeIndex]
        let c1 = vectors[(edgeIndex + 1) % vectors.count]

        let v0 = c0
        let v1 = centre
        let v2 = c1

        let corners = tileEdge.terrainCorners ?? LayerCorners(left: -1, right: -1, center: -1)

        let p0 = GridMesh.Elevation(elevation: corners.left.elevation, vector: v0)
        let p1 = GridMesh.Elevation(elevation: corners.centre.elevation, vector: v1)
        let p2 = GridMesh.Elevation(elevation: corners.right.elevation, vector: v2)

        return GridMesh.Polytope(p0: p0, p1: p1, p2: p2)
    }

    override func colorPalette(apex edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.waterType.primaryColor, secondary: layer.waterType.secondaryColor)
    }

    override func colorPalette(face edge: Int, atIndex index: Int) -> ColorPalette {

        guard let layer = find(edge: edge)?.topLayer else { return .default }

        return ColorPalette(primary: layer.waterType.primaryColor, secondary: layer.waterType.secondaryColor)
    }

    override func apex(for edge: Int, polyhedron: GridMesh.Polyhedron, atIndex index: Int) -> Pasture.Polygon? {

        guard shouldRender(apex: edge, atIndex: index) else { return nil }

        let normal = polyhedron.upper.normal

        let color = colorPalette(apex: edge, atIndex: index)

        let v0 = Vertex(position: polyhedron.upper.p0.vector - Constants.meniscus, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[0])
        let v1 = Vertex(position: polyhedron.upper.p1.vector - Constants.meniscus, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs.last!)
        let v2 = Vertex(position: polyhedron.upper.p2.vector - Constants.meniscus, normal: normal, color: color.primary, textureCoordinates: CGPoint.uvs[1])

        return Pasture.Polygon(vertices: [v0, v1, v2])
    }

    override func side(for edge: Int, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]? {

        guard shouldRender(face: edge, atIndex: index) else { return nil }

        guard let face = (intersection != nil ? face.clip(intersection: intersection!) : face), let terrainCorners = find(edge: edge)?.terrainCorners else { return nil }

        let color = colorPalette(face: edge, atIndex: index)

        let p0Equal = face.upper.p0.elevation == face.lower.p0.elevation
        let p1Equal = face.upper.p1.elevation == face.lower.p1.elevation

        let t0 = World.Axis.y(value: World.Constants.floor + terrainCorners.left.elevation)
        let t1 = World.Axis.y(value: World.Constants.floor + terrainCorners.right.elevation)

        var p0 = face.upper.p0.vector - Constants.meniscus
        var p1 = face.upper.p1.vector - Constants.meniscus
        var p2 = face.lower.p1.vector - Constants.meniscus
        var p3 = face.lower.p0.vector - Constants.meniscus

        p0 = Vector(x: p0.x, y: max(p0.y, t0), z: p0.z)
        p1 = Vector(x: p1.x, y: max(p1.y, t1), z: p1.z)
        p2 = Vector(x: p2.x, y: max(p2.y, t1), z: p2.z)
        p3 = Vector(x: p3.x, y: max(p3.y, t0), z: p3.z)

        if p0Equal || p1Equal {

            let p4 = (p0Equal ? p2 : p3)

            let v0 = Vertex(position: p0, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[0])
            let v1 = Vertex(position: p1, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[1])
            let v2 = Vertex(position: p4, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs.last!)

            return [Pasture.Polygon(vertices: [v0, v1, v2])]
        }

        let v0 = Vertex(position: p0, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[0])
        let v1 = Vertex(position: p1, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[1])
        let v2 = Vertex(position: p2, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[2])
        let v3 = Vertex(position: p3, normal: face.normal, color: color.secondary, textureCoordinates: CGPoint.uvs[3])

        return [Pasture.Polygon(vertices: [v0, v1, v2, v3])]
    }
}
