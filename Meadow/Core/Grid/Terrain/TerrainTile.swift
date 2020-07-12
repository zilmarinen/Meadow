//
//  TerrainTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class TerrainTile: LayeredTile<TerrainEdge, TerrainLayer> {
    
    enum Constants {
        
        static let crown = Vector(x: 0.0, y: World.Constants.yStep / 2.0, z: 0.0)
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    override func colorPalette(apex cardinal: Cardinal, atIndex index: Int) -> ColorPalette {
        
        guard let layer = find(edge: cardinal)?.find(layer: index) else { return .default }
        
        return ColorPalette(primary: layer.terrainType.primaryColor, secondary: layer.terrainType.secondaryColor)
    }
    
    override func colorPalette(face cardinal: Cardinal, atIndex index: Int) -> ColorPalette {
        
        guard let layer = find(edge: cardinal)?.find(layer: index) else { return .default }
        
        return ColorPalette(primary: layer.terrainType.primaryColor, secondary: layer.terrainType.secondaryColor)
    }
    
    override func edge(for cardinal: Cardinal, face: GridMesh.Face, intersection: GridMesh.EdgeSegment?, atIndex index: Int) -> [Pasture.Polygon]? {
        
        guard shouldRender(face: cardinal, atIndex: index) else { return nil }
        
        guard let face = (intersection != nil ? face.clip(intersection: intersection!) : face) else { return nil }
        
        guard face.upper.p0 != face.lower.p0 || face.upper.p1 != face.lower.p1 else { return nil }
        
        let intersection = intersection ?? face.lower
        
        let lower = GridMesh.EdgeSegment(e0: face.lower.p0.elevation - 1, v0: face.lower.p0.vector, e1: face.lower.p1.elevation - 1, v1: face.lower.p1.vector)
        
        let color = colorPalette(face: cardinal, atIndex: index)
        
        let throne = min(face.lower.p0, face.lower.p1)
        let apex = max(face.upper.p0, face.upper.p1)
        
        let difference = (apex.elevation - throne.elevation)
        
        let uvs = [CGPoint(x: 0, y: (Double(abs(difference - face.upper.p0.elevation)) * World.Constants.yStep)),
                   CGPoint(x: 1, y: (Double(abs(difference - face.upper.p1.elevation)) * World.Constants.yStep)),
                   CGPoint(x: 1, y: (Double(abs(difference - face.lower.p1.elevation)) * World.Constants.yStep)),
                   CGPoint(x: 0, y: (Double(abs(difference - face.lower.p0.elevation)) * World.Constants.yStep))]
        
        let c0 = face.upper.p0.vector - Constants.crown
        let c1 = face.upper.p1.vector - Constants.crown
        
        let uv0 = CGPoint(x: uvs[0].x, y: uvs[0].y - CGFloat(Constants.crown.y))
        let uv1 = CGPoint(x: uvs[1].x, y: uvs[1].y - CGFloat(Constants.crown.y))
        
        let v0 = Vertex(position: face.upper.p0.vector, normal: face.normal, color: color.primary, textureCoordinates: uvs[0])
        let v1 = Vertex(position: face.upper.p1.vector, normal: face.normal, color: color.primary, textureCoordinates: uvs[1])
        let v2 = Vertex(position: c1, normal: face.normal, color: color.primary, textureCoordinates: uv1)
        let v3 = Vertex(position: c0, normal: face.normal, color: color.primary, textureCoordinates: uv0)
        
        let v4 = Vertex(position: c0, normal: face.normal, color: color.secondary, textureCoordinates: uv0)
        let v5 = Vertex(position: c1, normal: face.normal, color: color.secondary, textureCoordinates: uv1)
        let v6 = Vertex(position: lower.p1.vector, normal: face.normal, color: color.secondary, textureCoordinates: uvs[2])
        let v7 = Vertex(position: lower.p0.vector, normal: face.normal, color: color.secondary, textureCoordinates: uvs[3])
        
        let p0 = Pasture.Polygon(vertices: [v0, v1, v2, v3])
        let p1 = Pasture.Polygon(vertices: [v4, v5, v6, v7])
        
        let plane = Plane(vectors: [intersection.p0.vector, intersection.p1.vector, intersection.p1.vector + face.normal])
        
        return p0.split(along: plane).front + p1.split(along: plane).front
    }
}
