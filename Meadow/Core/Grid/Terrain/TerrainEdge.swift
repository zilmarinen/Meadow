//
//  TerrainEdge.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class TerrainEdge: Edge<TerrainLayer> {
    
    enum Constants {
        
        static let crown = 0.1
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    override func render(transform: Transform) -> Mesh {
        
        var mesh = Mesh(polygons: [])
        
        let (o0, o1) = cardinal.ordinals
        
        let v0 = o0.vector + transform.position
        let v1 = transform.position
        let v2 = o1.vector + transform.position
        
        let faceNormals = [cardinal.normal,
                           (v0 - v1).cross(vector: (v1 - (v1 + .up))),
                           (v1 - v2).cross(vector: (v2 - (v2 + .up)))]
        
        let textureCoordinates = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint(x: 0.5, y: 0.5)]
        
        var polygons: [Pasture.Polygon] = []
        
        let lowerCorners = LayerCorners()
        let layerCorners = LayerCorners()
        let upperCorners = LayerCorners()
        
        for layer in layers where !layer.isHidden {
            
            lowerCorners.left.elevation = World.Constants.floor + (layer.lower?.corners.left.elevation ?? 0)
            lowerCorners.centre.elevation = World.Constants.floor + (layer.lower?.corners.centre.elevation ?? 0)
            lowerCorners.right.elevation = World.Constants.floor + (layer.lower?.corners.right.elevation ?? 0)
            
            layerCorners.left.elevation = World.Constants.floor + layer.corners.left.elevation
            layerCorners.centre.elevation = World.Constants.floor + layer.corners.centre.elevation
            layerCorners.right.elevation = World.Constants.floor + layer.corners.right.elevation
            
            upperCorners.left.elevation = World.Constants.floor + (layer.upper?.corners.left.elevation ?? 0)
            upperCorners.centre.elevation = World.Constants.floor + (layer.upper?.corners.centre.elevation ?? 0)
            upperCorners.right.elevation = World.Constants.floor + (layer.upper?.corners.right.elevation ?? 0)
            
            
            
            
            
            
            
            
            let lc0 = World.Constants.floor + (layer.lower?.corners.left.elevation ?? 0) - 1
            let lc1 = World.Constants.floor + (layer.lower?.corners.centre.elevation ?? 0) - 1
            let lc2 = World.Constants.floor + (layer.lower?.corners.right.elevation ?? 0) - 1
            
            let uc0 = World.Constants.floor + layer.corners.left.elevation
            let uc1 = World.Constants.floor + layer.corners.centre.elevation
            let uc2 = World.Constants.floor + layer.corners.right.elevation
            
            let lv0 = Vector(x: v0.x, y: World.Axis.y(value: lc0), z: v0.z)
            let lv1 = Vector(x: v1.x, y: World.Axis.y(value: lc1), z: v1.z)
            let lv2 = Vector(x: v2.x, y: World.Axis.y(value: lc2), z: v2.z)
            
            let uv0 = Vector(x: v0.x, y: World.Axis.y(value: uc0), z: v0.z)
            let uv1 = Vector(x: v1.x, y: World.Axis.y(value: uc1), z: v1.z)
            let uv2 = Vector(x: v2.x, y: World.Axis.y(value: uc2), z: v2.z)
            
            let cv0 = Vector(x: v0.x, y: World.Axis.y(value: uc0) - Constants.crown, z: v0.z)
            let cv1 = Vector(x: v1.x, y: World.Axis.y(value: uc1) - Constants.crown, z: v1.z)
            let cv2 = Vector(x: v2.x, y: World.Axis.y(value: uc2) - Constants.crown, z: v2.z)
            
            let faces = [[uv0, uv2, cv2, cv0],
                         [cv0, cv2, lv2, lv0],
                         [uv1, uv0, cv0, cv1],
                         [cv1, cv0, lv0, lv1],
                         [uv2, uv1, cv1, cv2],
                         [cv2, cv1, lv1, lv2]]
            
            let normals = [faceNormals[0], faceNormals[0],
                           faceNormals[1], faceNormals[1],
                           faceNormals[2], faceNormals[2]]
            
            for i in 0..<faces.count {
                
                let color = (i % 2 == 0 ? layer.terrainType.primaryColor : layer.terrainType.secondaryColor)
                
                let v0 = Vertex(position: faces[i][0], normal: normals[i], color: color, textureCoordinates: textureCoordinates[0])
                let v1 = Vertex(position: faces[i][1], normal: normals[i], color: color, textureCoordinates: textureCoordinates[1])
                let v2 = Vertex(position: faces[i][2], normal: normals[i], color: color, textureCoordinates: textureCoordinates[2])
                let v3 = Vertex(position: faces[i][3], normal: normals[i], color: color, textureCoordinates: textureCoordinates[3])
                
                polygons.append(Polygon(vertices: [v0, v1, v2, v3], convex: true))
            }
            
            mesh = mesh.union(mesh: Mesh(polygons: polygons))
        }
        
        return mesh
    }
}
