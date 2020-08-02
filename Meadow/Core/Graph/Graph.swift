//
//  Graph.swift
//  Meadow
//
//  Created by Zack Brown on 13/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public class Graph: Codable {
    
    enum CodingKeys: CodingKey {
        
        case vectors
        case quads
        case edges
        case joints
    }
    
    public struct Edge: Codable, Hashable {
        
        public let i: Int
        
        var j: Int = -1
        
        let v0: Int
        let v1: Int
        
        init(i: Int, v0: Int, v1: Int, j: Int = -1) {
            
            self.i = i
            self.j = j
            self.v0 = v0
            self.v1 = v1
        }
        
        func spans(v0: Int, v1: Int) -> Bool {
            
            return (self.v0 == v0 && self.v1 == v1) || (self.v0 == v1 && self.v1 == v0)
        }
    }
    
    public struct Joint: Codable {
        
        public
        let i: Int
        
        var v: Int = -1
        
        let e0: Int
        var e1: Int

        let i0: Int
        var i1: Int = -1
        
        init(i: Int, e0: Int, e1: Int = -1, i0: Int, i1: Int = -1, v: Int = -1) {
            
            self.i = i
            self.v = v
            self.e0 = e0
            self.e1 = e1
            self.i0 = i0
            self.i1 = i1
        }
    }
    
    struct Triangle {
        
        let e0: Int
        let e1: Int
        let e2: Int
    }
    
    public struct Quad: Codable {
        
        public let i: Int
        
        let e0: Int
        let e1: Int
        let e2: Int
        let e3: Int
        
        let v: Vector
    }
    
    let vectors: [Vector]
    let edges: [Edge]
    let joints: [Joint]
    let quads: [Quad]
    
    public init(plotter: GraphPlotter, resolver: GraphResolver) {
        
        var cache = plotter.plot()
        
        cache = plotter.quadrangulate(graph: cache)
        
        cache = resolver.resolve(graph: cache)
        
        self.vectors = cache.vectors
        self.edges = cache.quads.edges
        self.joints = cache.quads.joints
        self.quads = cache.quads.quads
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.vectors = try container.decode([Vector].self, forKey: .vectors)
        self.edges = try container.decode([Edge].self, forKey: .edges)
        self.joints = try container.decode([Joint].self, forKey: .joints)
        self.quads = try container.decode([Quad].self, forKey: .quads)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(vectors, forKey: .vectors)
        try container.encode(quads, forKey: .quads)
        try container.encode(edges, forKey: .edges)
        try container.encode(joints, forKey: .joints)
    }
}

extension Graph {
    
    public var totalQuads: Int { return quads.count }
    
    func quad(at index: Int) -> Quad {
        
        return quads[index]
    }
    
    func edges(for quad: Quad) -> [Edge] {
        
        return [quad.e0, quad.e1, quad.e2, quad.e3].map { edges[$0] }
    }
    
    func joints(for quad: Quad) -> [Joint] {
        
        return edges(for: quad).map { joints[$0.j] }
    }
    
    func vectors(for quad: Quad) -> [Vector] {
        
        return edges(for: quad).map { vectors[$0.v0] }
    }
    
    func nearest(quad vector: Vector) -> Quad? {
        
        return quads.first {
            
            let vertices = vectors(for: $0).map { Vertex(position: $0, normal: .up) }
            
            let polygon = Pasture.Polygon(vertices: vertices)
            
            return polygon.contains(vector: vector)
        }
    }
    
    func nearest(joint index: Int, vector: Vector) -> Joint {
        
        let q = quad(at: index)
        
        let j = joints(for: q)
        
        let vector = Vector(x: vector.x, y: q.v.y, z: vector.z)
        
        var nearest = j.first!
        
        for index in 1..<j.count {
            
            let joint = j[index]
            
            let edge = edges[joint.e0]
            
            let v0 = Vertex(position: vectors[edge.v0], normal: .up)
            let v1 = Vertex(position: q.v, normal: .up)
            let v2 = Vertex(position: vectors[edge.v1], normal: .up)
            
            let p = Pasture.Polygon(vertices: [v0, v1, v2])
            
            if p.contains(vector: vector) {
                
                nearest = joint
            }
        }
        
        return nearest
    }
    
    func nearest(corner index: Int, vector: Vector) -> Vector {
    
        let q = quad(at: index)
        
        let v = vectors(for: q)
        
        let vector = Vector(x: vector.x, y: q.v.y, z: vector.z)
        
        var nearest = v.first!
        
        var distance = Double.infinity
        
        for index in 0..<v.count {
            
            let v0 = v[index]
            
            let d = (vector - v0).magnitude
            
            if d < distance {
                
                distance = d
                
                nearest = v0
            }
        }
        
        return nearest
    }
}

extension Graph {
    
    public var geometry: SCNGeometry {
    
        var vertexCache: [Vector : UInt32] = [:]
        var vertices: [SCNVector3] = []
        var meshIndices: [UInt32] = []
        var colors: [SCNVector4] = []
        
        let drawEdges = false
        let drawJoints = true
        let drawQuads = true
        
        if drawEdges {
            
            print("drawing [\(edges.count)] edges")
        
            for edge in edges {

                let v0 = vectors[edge.v0]
                let v1 = vectors[edge.v1]

                for v2 in [v0, v1] {

                    if let index = vertexCache[v2] {

                        meshIndices.append(index)
                    }
                    else {

                        let index = UInt32(vertexCache.count)

                        vertexCache[v2] = index

                        vertices.append(SCNVector3(vector: v2))
                        colors.append(SCNVector4(x: 1.0, y: 0.0, z: 0.0, w: 1.0))

                        meshIndices.append(index)
                    }
                }
            }
        }
        
        if drawJoints {
            
            let joins = joints.filter { $0.i1 != -1 }
            
            print("drawing [\(joins.count)] joints of [\(joints.count)]")
            
            for joint in joins {
                
                let t0 = quads[joint.i0]
                let t1 = quads[joint.i1]
                
                let e0 = edges[t0.e0]
                let e1 = edges[t0.e1]
                let e2 = edges[t0.e2]
                let e3 = edges[t0.e3]
                
                let e4 = edges[t1.e0]
                let e5 = edges[t1.e1]
                let e6 = edges[t1.e2]
                let e7 = edges[t1.e3]
                
                let v0 = (vectors[e0.v0] + vectors[e1.v0] + vectors[e2.v0] + vectors[e3.v0]) / 4
                let v1 = (vectors[e4.v0] + vectors[e5.v0] + vectors[e6.v0] + vectors[e7.v0]) / 4

                for v2 in [v0, v1] {

                    if let index = vertexCache[v2] {

                        meshIndices.append(index)
                    }
                    else {

                        let index = UInt32(vertexCache.count)

                        vertexCache[v2] = index

                        vertices.append(SCNVector3(vector: v2))
                        colors.append(SCNVector4(x: 1.0, y: 0.0, z: 1.0, w: 1.0))

                        meshIndices.append(index)
                    }
                }
            }
        }
        
        if drawQuads {
            
            print("drawing [\(quads.count)] quads")
            
            for quad in quads {
                
                let e0 = edges[quad.e0]
                let e1 = edges[quad.e1]
                let e2 = edges[quad.e2]
                let e3 = edges[quad.e3]
                
                let v0 = vectors[e0.v0]
                let v1 = vectors[e1.v0]
                let v2 = vectors[e2.v0]
                let v3 = vectors[e3.v0]
                
                for v2 in [v0, v1, v1, v2, v2, v3, v3, v0] {

                    if let index = vertexCache[v2] {

                        meshIndices.append(index)
                    }
                    else {

                        let index = UInt32(vertexCache.count)

                        vertexCache[v2] = index

                        vertices.append(SCNVector3(vector: v2))
                        colors.append(SCNVector4(x: 1.0, y: 1.0, z: 1.0, w: 1.0))

                        meshIndices.append(index)
                    }
                }
            }
        }

        let data = Data(bytes: colors, count: MemoryLayout<SCNVector4>.size * colors.count)
        
        let colorSource = SCNGeometrySource(data: data, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 4, bytesPerComponent: MemoryLayout<SKFloat>.size, dataOffset: 0, dataStride: 0)
        
        let sources = [SCNGeometrySource(vertices: vertices),
                       colorSource]
        
        let elements = [SCNGeometryElement(indices: meshIndices, primitiveType: .line)]
        
        return SCNGeometry(sources: sources, elements: elements)
    }
}
