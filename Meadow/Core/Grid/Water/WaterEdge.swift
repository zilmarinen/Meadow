//
//  WaterEdge.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class WaterEdge: Edge<WaterLayer> {
    
    enum Constants {
        
        static let miniscus = 0.1
    }
    
    public override var category: SceneGraphNodeCategory { return .water }
    
    public var terrainCorners: LayerCorners? {
        
        didSet {
            
            guard oldValue != terrainCorners else { return }
            
            becomeDirty()
        }
    }
    
    override func render(transform: Transform) -> Mesh {
        
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
            
            let lc0 = World.Constants.floor + (terrainCorners?.left.elevation ?? -1)
            let lc1 = World.Constants.floor + (terrainCorners?.centre.elevation ?? -1)
            let lc2 = World.Constants.floor + (terrainCorners?.right.elevation ?? -1)
            
            let uc0 = World.Constants.floor + layer.corners.left.elevation
            let uc1 = World.Constants.floor + layer.corners.centre.elevation
            let uc2 = World.Constants.floor + layer.corners.right.elevation
            
            let lv0 = Vector(x: v0.x, y: World.Axis.y(value: lc0), z: v0.z)
            let lv1 = Vector(x: v1.x, y: World.Axis.y(value: lc1), z: v1.z)
            let lv2 = Vector(x: v2.x, y: World.Axis.y(value: lc2), z: v2.z)
            
            let uv0 = Vector(x: v0.x, y: World.Axis.y(value: uc0), z: v0.z)
            let uv1 = Vector(x: v1.x, y: World.Axis.y(value: uc1), z: v1.z)
            let uv2 = Vector(x: v2.x, y: World.Axis.y(value: uc2), z: v2.z)
            
            let normal = (uv0 - uv2).cross(vector: (uv1 - uv0))
            
            let uv = textureCoordinates.last!
            
            let fv0 = Vertex(position: uv0, normal: normal, color: layer.waterType.primaryColor, textureCoordinates: uv)
            let fv1 = Vertex(position: uv1, normal: normal, color: layer.waterType.primaryColor, textureCoordinates: uv)
            let fv2 = Vertex(position: uv2, normal: normal, color: layer.waterType.primaryColor, textureCoordinates: uv)
            
            polygons.append(Polygon(vertices: [fv0, fv1, fv2], convex: true))
            
            var faces: [[Vector]] = []
            var normals: [Vector] = []
            
            if lc0 != uc0 && lc2 != uc2 {
                
                faces.append([uv0, uv2, lv2, lv0])
                
                normals.append(faceNormals[0])
            }
            
            if lc0 != uc0 && lc1 != uc1 {
                
                faces.append([uv1, uv0, lv0, lv1])
                
                normals.append(faceNormals[1])
            }
            
            if lc1 != uc1 && lc2 != uc2 {
                
                faces.append([uv2, uv1, lv1, lv2])
                
                normals.append(faceNormals[2])
            }
            
            for i in 0..<faces.count {
                
                let v0 = Vertex(position: faces[i][0], normal: normals[i], color: layer.waterType.secondaryColor, textureCoordinates: textureCoordinates[0])
                let v1 = Vertex(position: faces[i][1], normal: normals[i], color: layer.waterType.secondaryColor, textureCoordinates: textureCoordinates[1])
                let v2 = Vertex(position: faces[i][2], normal: normals[i], color: layer.waterType.secondaryColor, textureCoordinates: textureCoordinates[2])
                let v3 = Vertex(position: faces[i][3], normal: normals[i], color: layer.waterType.secondaryColor, textureCoordinates: textureCoordinates[3])
                
                polygons.append(Polygon(vertices: [v0, v1, v2, v3], convex: true))
            }
            
            mesh = Mesh(polygons: polygons).union(mesh: mesh)
        }
        
        return Mesh(polygons: polygons)
    }
}
