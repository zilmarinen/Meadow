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
        
        static let lip = 0.07
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    override func render(transform: Transform) -> Mesh {
        
        let (o0, o1) = cardinal.ordinals
        
        let v0 = o0.vector + transform.position
        let v1 = transform.position
        let v2 = o1.vector + transform.position
        
        var polygons: [Pasture.Polygon] = []
        
        for layer in layers where !layer.isHidden {
            
            let c0 = layer.lower?.get(elevation: o0) ?? World.Constants.floor
            let c1 = layer.lower?.centerElevation ?? World.Constants.floor
            let c2 = layer.lower?.get(elevation: o1) ?? World.Constants.floor
            
            let c3 = layer.get(elevation: o0)
            let c4 = layer.centerElevation
            let c5 = layer.get(elevation: o1)
            
            let lv0 = Vector(x: v0.x, y: World.Axis.y(y: c0), z: v0.z)
            let lv1 = Vector(x: v1.x, y: World.Axis.y(y: c1), z: v1.z)
            let lv2 = Vector(x: v2.x, y: World.Axis.y(y: c2), z: v2.z)
            
            let uv0 = Vector(x: v0.x, y: World.Axis.y(y: c3), z: v0.z)
            let uv1 = Vector(x: v1.x, y: World.Axis.y(y: c4), z: v1.z)
            let uv2 = Vector(x: v2.x, y: World.Axis.y(y: c5), z: v2.z)
            
            let n0 = (uv0 - uv1).cross(vector: (uv0 - uv2))
            let n1 = -cardinal.normal
            let n2 = (uv1 - uv0).cross(vector: (uv1 - lv1))
            let n3 = (uv2 - uv1).cross(vector: (uv2 - lv2))
            
            var faces: [[Vector]] = []
            var normals: [Vector] = []
            var materials: [Pasture.Polygon.Material] = []
            /*
            if layer.upper == nil {
                
                let fv0 = Vertex(position: uv0, normal: n0)
                let fv1 = Vertex(position: uv1, normal: n0)
                let fv2 = Vertex(position: uv2, normal: n0)
                
                polygons.append(Polygon(vertices: [fv0, fv1, fv2], convex: true, material: layer.color.primary))
                
                let uv3 = Vector(x: v0.x, y: World.Axis.y(y: c3) - Constants.lip, z: v0.z)
                let uv4 = Vector(x: v1.x, y: World.Axis.y(y: c4) - Constants.lip, z: v1.z)
                let uv5 = Vector(x: v2.x, y: World.Axis.y(y: c5) - Constants.lip, z: v2.z)
                
                faces.append([uv0, uv2, uv5, uv3])
                faces.append([uv3, uv5, lv2, lv0])
                
                faces.append([uv1, uv0, uv3, uv4])
                faces.append([uv4, uv3, lv0, lv1])
                
                faces.append([uv2, uv1, uv4, uv5])
                faces.append([uv5, uv4, lv1, lv2])
                
                normals.append(contentsOf: [n1, n1, n2, n2, n3, n3])
                
                materials.append(contentsOf: [layer.color.primary, layer.color.secondary,
                                              layer.color.primary, layer.color.secondary,
                                              layer.color.primary, layer.color.secondary])
            }
            else {
                
                faces.append([uv0, uv2, lv2, lv0])
                faces.append([uv1, uv0, lv0, lv1])
                faces.append([uv2, uv1, lv1, lv2])
                
                normals.append(contentsOf: [n1, n2, n3])
                
                materials.append(contentsOf: [layer.color.secondary, layer.color.secondary, layer.color.secondary])
            }
            */
            for i in 0..<faces.count {
                
                let vectors = faces[i]
                let normal = normals[i]
                let material = materials[i]
                
                let vertices = vectors.map { Vertex(position: $0, normal: normal) }
                
                polygons.append(Polygon(vertices: vertices, convex: true, material: material))
            }
        }
        
        return Mesh(polygons: polygons)
    }
}
