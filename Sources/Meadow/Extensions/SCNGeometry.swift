//
//  SCNGeometry.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

extension SCNGeometry {
    
    func set(uniforms: [Uniform]) {
        
        for uniform in uniforms {
            
            setValue(uniform.value, forKey: uniform.key)
        }
    }
    
    func set(textures: [Texture]) {
        
        for texture in textures {
            
            setValue(texture.value, forKey: texture.key)
        }
    }
}

public extension SCNGeometry {
    
    convenience init(mesh: Mesh) {
        
        var vertexCache: [Vertex : UInt32] = [:]
        var vertices: [SCNVector3] = []
        var normals: [SCNVector3] = []
        var colors: [SCNVector4] = []
        var textureCoordinates: [CGPoint] = []
        var meshIndices: [UInt32] = []
        
        for polygon in mesh.polygons {
            
            var indices: [UInt32] = []
            
            for triangle in polygon.triangulate() {
                
                for vertex in triangle.vertices {
                
                    if let index = vertexCache[vertex] {
                        
                        indices.append(index)
                        
                        continue
                    }
                    
                    let index = UInt32(vertexCache.count)
                    
                    vertexCache[vertex] = index
                    
                    indices.append(index)
                    
                    vertices.append(SCNVector3(vector: vertex.position))
                    normals.append(SCNVector3(vector: vertex.normal))
                    colors.append(SCNVector4(color: vertex.color))
                    textureCoordinates.append(CGPoint(x: vertex.textureCoordinates.x, y: vertex.textureCoordinates.y))
                }
            }
            
            meshIndices.append(contentsOf: indices)
        }
        
        let data = Data(bytes: colors, count: MemoryLayout<SCNVector4>.size * colors.count)
        
        let colorSource = SCNGeometrySource(data: data, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 4, bytesPerComponent: MemoryLayout<MDWFloat>.size, dataOffset: 0, dataStride: 0)
        
        let sources = [SCNGeometrySource(vertices: vertices),
                       SCNGeometrySource(normals: normals),
                       colorSource,
                       SCNGeometrySource(textureCoordinates: textureCoordinates)]
        
        let elements = [SCNGeometryElement(indices: meshIndices, primitiveType: .triangles)]
        
        self.init(sources: sources, elements: elements)
    }
    
    convenience init(wireframe mesh: Mesh) {
        
        var vertexCache: [Vertex : UInt32] = [:]
        var vertices: [SCNVector3] = []
        var meshIndices: [UInt32] = []
        
        for polygon in mesh.polygons {
            
            var v0 = polygon.vertices.last!
            
            for v1 in polygon.vertices {
                
                for v2 in [v0, v1] {
                    
                    if let index = vertexCache[v2] {
                        
                        meshIndices.append(index)
                    }
                    else {
                        
                        let index = UInt32(vertexCache.count)
                        
                        vertexCache[v2] = index
                        
                        vertices.append(SCNVector3(vector: v2.position))
                        
                        meshIndices.append(index)
                    }
                }
                
                v0 = v1
            }
        }
        
        let sources = [SCNGeometrySource(vertices: vertices)]
        
        let elements = [SCNGeometryElement(indices: meshIndices, primitiveType: .line)]
        
        self.init(sources: sources, elements: elements)
    }
    
    convenience init(normals mesh: Mesh, color: Color = .red) {
        
        var vertices: [SCNVector3] = []
        var colors: [SCNVector4] = []
        var meshIndices: [UInt32] = []
        
        for polygon in mesh.polygons {
            
            for vertex in polygon.vertices {
                
                let v0 = SCNVector3(vector: vertex.position)
                let v1 = SCNVector3(vector: vertex.position + (vertex.normal / 2.0))
                
                let index = UInt32(meshIndices.count)
                
                vertices.append(v0)
                vertices.append(v1)
                
                meshIndices.append(index)
                meshIndices.append(index + 1)
                
                colors.append(SCNVector4(color: color))
                colors.append(SCNVector4(color: color))
            }
        }
        
        let data = Data(bytes: colors, count: MemoryLayout<SCNVector4>.size * colors.count)
        
        let colorSource = SCNGeometrySource(data: data, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 4, bytesPerComponent: MemoryLayout<MDWFloat>.size, dataOffset: 0, dataStride: 0)
        
        let sources = [SCNGeometrySource(vertices: vertices), colorSource]
        
        let elements = [SCNGeometryElement(indices: meshIndices, primitiveType: .line)]
        
        self.init(sources: sources, elements: elements)
    }
}
