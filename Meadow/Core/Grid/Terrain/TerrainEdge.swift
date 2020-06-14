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
        
        for layer in layers where !layer.isHidden {
            
            let lc0 = World.Constants.floor + (layer.lower?.corners.left.elevation ?? -1)
            let lc1 = World.Constants.floor + (layer.lower?.corners.centre.elevation ?? -1)
            let lc2 = World.Constants.floor + (layer.lower?.corners.right.elevation ?? -1)
            
            let uc0 = World.Constants.floor + layer.corners.left.elevation
            let uc1 = World.Constants.floor + layer.corners.centre.elevation
            let uc2 = World.Constants.floor + layer.corners.right.elevation
            
            let lv0 = Vector(x: v0.x, y: World.Axis.y(y: lc0), z: v0.z)
            let lv1 = Vector(x: v1.x, y: World.Axis.y(y: lc1), z: v1.z)
            let lv2 = Vector(x: v2.x, y: World.Axis.y(y: lc2), z: v2.z)
            
            let uv0 = Vector(x: v0.x, y: World.Axis.y(y: uc0), z: v0.z)
            let uv1 = Vector(x: v1.x, y: World.Axis.y(y: uc1), z: v1.z)
            let uv2 = Vector(x: v2.x, y: World.Axis.y(y: uc2), z: v2.z)
            
            let cv0 = Vector(x: v0.x, y: World.Axis.y(y: uc0) - Constants.crown, z: v0.z)
            let cv1 = Vector(x: v1.x, y: World.Axis.y(y: uc1) - Constants.crown, z: v1.z)
            let cv2 = Vector(x: v2.x, y: World.Axis.y(y: uc2) - Constants.crown, z: v2.z)
            
            if layer.upper == nil || layer.upper?.isHidden ?? false {
                
                let color = layer.terrainType.primaryColor
                
                let normal = (uv0 - uv2).cross(vector: (uv1 - uv0))
                
                let uv = textureCoordinates.last!
                
                let fv0 = Vertex(position: uv0, normal: normal, color: color, textureCoordinates: uv)
                let fv1 = Vertex(position: uv1, normal: normal, color: color, textureCoordinates: uv)
                let fv2 = Vertex(position: uv2, normal: normal, color: color, textureCoordinates: uv)
                
                polygons.append(Polygon(vertices: [fv0, fv1, fv2], convex: true))
            }
            
            var faces: [[Vector]] = []
            var normals: [Vector] = []
            
            if lc0 != uc0 || lc2 != uc2 {
                
                faces.append([uv0, uv2, cv2, cv0])
                faces.append([cv0, cv2, lv2, lv0])
                
                normals.append(contentsOf: [faceNormals[0], faceNormals[0]])
            }
            
            if lc0 != uc0 || lc1 != uc1 {
                
                faces.append([uv1, uv0, cv0, cv1])
                faces.append([cv1, cv0, lv0, lv1])
                
                normals.append(contentsOf: [faceNormals[1], faceNormals[1]])
            }
            
            if lc1 != uc1 || lc2 != uc2 {
                
                faces.append([uv2, uv1, cv1, cv2])
                faces.append([cv2, cv1, lv1, lv2])
                
                normals.append(contentsOf: [faceNormals[2], faceNormals[2]])
            }
            
            for i in 0..<faces.count {
                
                let color = (i % 2 == 0 ? layer.terrainType.primaryColor : layer.terrainType.secondaryColor)
                
                let v0 = Vertex(position: faces[i][0], normal: normals[i], color: color, textureCoordinates: textureCoordinates[0])
                let v1 = Vertex(position: faces[i][1], normal: normals[i], color: color, textureCoordinates: textureCoordinates[1])
                let v2 = Vertex(position: faces[i][2], normal: normals[i], color: color, textureCoordinates: textureCoordinates[2])
                let v3 = Vertex(position: faces[i][3], normal: normals[i], color: color, textureCoordinates: textureCoordinates[3])
                
                polygons.append(Polygon(vertices: [v0, v1, v2, v3], convex: true))
            }
            
            mesh = Mesh(polygons: polygons).union(mesh: mesh)
        }
        
        return mesh
    }
}
