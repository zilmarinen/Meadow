//
//  Graph.swift
//  Meadow
//
//  Created by Zack Brown on 13/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public class Graph {
    
    struct Edge {
        
        let i: Int
        
        let v0: Int
        let v1: Int
        
        func spans(v0: Int, v1: Int) -> Bool {
            
            return (self.v0 == v0 && self.v1 == v1) || (self.v0 == v1 && self.v1 == v0)
        }
    }
    
    struct Joint {
        
        let i: Int
        
        let e: Int

        let t0: Int
        var t1: Int
        
        init(i: Int, e: Int, t0: Int, t1: Int = -1) {
            
            self.i = i
            self.e = e
            self.t0 = t0
            self.t1 = t1
        }
    }
    
    struct Triangle {
        
        let v0: Int
        let v1: Int
        let v2: Int
    }
    
    struct Quad {
        
        let v0: Int
        let v1: Int
        let v2: Int
        let v3: Int
    }
    
    enum Constants {
        
        static let slices = 6
    }
    
    var vectors: [Vector] = []
    
    var edges: [Edge] = []
    var halfEdges: [Edge] = []
    
    var joints: [Joint] = []
    var pairs: [Joint] = []
    
    var triangles: [Triangle] = []
    var quads: [Quad] = []
    
    public init(origin: Vector, rings: Int, size: Double = 1.0) {
        
        let start = Date()
        
        generate(origin: origin, rings: rings, size: size)
        
        let mid = Date()
        
        quadrangulate()
        
        let end = Date()
        
        let m0 = (mid.timeIntervalSince1970 - start.timeIntervalSince1970)
        let m1 = (end.timeIntervalSince1970 - mid.timeIntervalSince1970)
        
        print("Triangulation: \(m0)")
        print("Quadrangulation: \(m1)")
    }
    
    public var geometry: SCNGeometry {
    
        var vertexCache: [Vector : UInt32] = [:]
        var vertices: [SCNVector3] = []
        var meshIndices: [UInt32] = []
        var colors: [SCNVector4] = []
        
        let drawEdges = false
        let drawHalfEdges = true
        let drawJoints = false
        let drawPairs = false
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
        
        if drawHalfEdges {
            
            print("drawing [\(halfEdges.count)] half edges")
        
            for edge in halfEdges {

                let v0 = vectors[edge.v0]
                let v1 = vectors[edge.v1]

                for v2 in [v0, v1] {
                    
                    var v2 = v2
                    v2.y = -1.0

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
            
            let joins = joints.filter { $0.t1 != -1 }
            
            print("drawing [\(joins.count)] joints of [\(joints.count)]")
            
            for joint in joins {
                
                let t0 = triangles[joint.t0]
                let t1 = triangles[joint.t1]
                
                let v0 = (vectors[t0.v0] + vectors[t0.v1] + vectors[t0.v2]) / 3
                let v1 = (vectors[t1.v0] + vectors[t1.v1] + vectors[t1.v2]) / 3

                for v2 in [v0, v1] {

                    if let index = vertexCache[v2] {

                        meshIndices.append(index)
                    }
                    else {

                        let index = UInt32(vertexCache.count)

                        vertexCache[v2] = index

                        vertices.append(SCNVector3(vector: v2))
                        colors.append(SCNVector4(x: 0.0, y: 1.0, z: 0.0, w: 1.0))

                        meshIndices.append(index)
                    }
                }
            }
        }
        
        if drawPairs {
            
            let joins = pairs.filter { $0.t1 != -1 }
            
            print("drawing [\(joins.count)] pairs of [\(pairs.count)]")
            
            for joint in joins {
                
                let t0 = triangles[joint.t0]
                let t1 = triangles[joint.t1]
                
                let e0 = find(edge: t0.v0, v1: t0.v1)
                let e1 = find(edge: t0.v1, v1: t0.v2)
                let e2 = find(edge: t0.v2, v1: t0.v0)
                
                let e3 = find(edge: t1.v0, v1: t1.v1)
                let e4 = find(edge: t1.v1, v1: t1.v2)
                let e5 = find(edge: t1.v2, v1: t1.v0)
                
                let allEdges = [e0, e1, e2, e3, e4, e5].compactMap { $0 != nil ? $0 : nil }
                let edges = allEdges.filter { $0.i != joint.e }
                
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
                            colors.append(SCNVector4(x: 0.0, y: 0.0, z: 1.0, w: 1.0))

                            meshIndices.append(index)
                        }
                    }
                }
            }
        }
        
        if drawQuads {
            
            print("drawing [\(quads.count)] quads")
            
            for quad in quads {
                
                let v0 = vectors[quad.v0]
                let v1 = vectors[quad.v1]
                let v2 = vectors[quad.v2]
                let v3 = vectors[quad.v3]
                
                for v2 in [v0, v1, v1, v2, v2, v3, v3, v0] {
                    
                    var v2 = v2
                    v2.y = 1.0

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

extension Graph {
    
    func generate(origin: Vector, rings: Int, size: Double = 1.0) {
        
        vectors.removeAll()
        
        vectors.append(origin)
        
        let rings = max(rings, 1)
        
        var offset = 0
        var inner = Array(repeating: [0], count: Constants.slices)
        
        for ring in 0..<rings {
            
            //
            //
            //
            
            let radius = Double(ring + 1) * size
            
            var corners: [Vector] = []
            
            for index in 0..<Constants.slices {
            
                corners.append(Math.plot(delta: Double(index), slices: Constants.slices) * radius)
            }
            
            //
            //
            //
            
            let i = (ring * Constants.slices)
            let j = ((ring + 1) * Constants.slices)
            
            let outer = Array(((offset + i) + 1)...((offset + i) + j)).wind(steps: (ring + 2), slices: Constants.slices)
            
            offset += (ring * Constants.slices)
            
            //
            //
            //
            
            for index in 0..<Constants.slices {
                
                let v0 = corners[index]
                let v1 = corners[((index + 1) % Constants.slices)]
                
                vectors.append(v0)
                
                if ring > 0 {
                
                    let step = 1.0 / Double(ring + 1)
                    
                    for division in 1..<(ring + 1) {
                        
                        vectors.append(v0.lerp(vector: v1, interpolater: step * Double(division)))
                    }
                }
                
                //
                //
                //
                
                let inside = inner[index]
                let outside = outer[index]
                
                let lhs: [[Int]] = (ring == 0 ? [] : (ring == 1 ? [inside] : inside.wind(steps: 2, slices: ring)))
                let rhs: [Int] = (ring == 0 ? [] : (ring == 1 ? [outside[1]] : Array(outside[1..<(outside.count - 1)])))
                let adjacent = outside.wind(steps: 2, slices: ring + 1)
                
                for k in 0..<lhs.count {

                    create(triangle: lhs[k][0], v1: lhs[k][1], v2: rhs[k])
                }

                for k in 0..<inside.count {

                    create(triangle: adjacent[k][0], v1: inside[k], v2: adjacent[k][1])
                }
            }
            
            inner = outer
        }
        
        joints.removeAll { $0.t1 == -1 }
    }
    
    func quadrangulate() {
        
        halfEdges.removeAll()
        pairs.removeAll()
        quads.removeAll()
        
        for edge in edges {
            
            let vector = (vectors[edge.v0] + vectors[edge.v1]) / 2
            
            halfEdges.append(Edge(i: halfEdges.count, v0: edge.v0, v1: vectors.count))
            halfEdges.append(Edge(i: halfEdges.count, v0: vectors.count, v1: edge.v1))
            
            vectors.append(vector)
        }
        
        let indices = triangles.indices.shuffled()
    
        for index in indices {
            
            guard find(pair: index) == nil else { continue }
            
            let joins = find(joints: index).shuffled()
            
            var connected = false
            
            for j in 0..<joins.count {
                
                let joint = joins[j]
                
                let adjacentIndex = (joint.t0 != index ? joint.t0 : joint.t1)
                
                if find(pair: adjacentIndex) == nil {
                    
                    create(pair: joint.e, t0: index, t1: adjacentIndex)
                    
                    divide(pair: triangles[index], t1: triangles[adjacentIndex], joint: joint)
                    return
                    connected = true
                    
                    break
                }
            }
            
            if !connected {
            
                divide(triangle: triangles[index])
            }
        }
    }
}

extension Graph {
    
    func divide(triangle: Triangle) {
        return
        guard let e0 = find(edge: triangle.v0, v1: triangle.v1), let e1 = find(edge: triangle.v1, v1: triangle.v2), let e2 = find(edge: triangle.v2, v1: triangle.v0) else { fatalError("Invalid edges") }
        
        let he0 = halfEdges[(e0.i * 2)]
        let he1 = halfEdges[(e1.i * 2)]
        let he2 = halfEdges[(e2.i * 2)]
        
        let v0 = vectors[triangle.v0]
        let v1 = vectors[triangle.v1]
        let v2 = vectors[triangle.v2]
        
        let v6 = (v0 + v1 + v2) / 3
        
        quads.append(Quad(v0: triangle.v0, v1: he0.v1, v2: vectors.count, v3: he2.v1))
        quads.append(Quad(v0: triangle.v1, v1: he1.v1, v2: vectors.count, v3: he0.v1))
        quads.append(Quad(v0: triangle.v2, v1: he2.v1, v2: vectors.count, v3: he1.v1))
        
        vectors.append(v6)
    }
    
    func divide(pair t0: Triangle, t1: Triangle, joint: Joint) {
        
        guard let e0 = find(edge: t0.v0, v1: t0.v1), let e1 = find(edge: t0.v1, v1: t0.v2), let e2 = find(edge: t0.v2, v1: t0.v0), let e3 = find(edge: t1.v0, v1: t1.v1), let e4 = find(edge: t1.v1, v1: t1.v2), let e5 = find(edge: t1.v2, v1: t1.v0) else { fatalError("Invalid edges") }
        
        let e6 = (e0.spans(v0: joint.t0, v1: joint.t1) ? e1 : e0)
        let e7 = (e0.spans(v0: joint.t0, v1: joint.t1) ? e2 : e1)
        let e8 = (e3.spans(v0: joint.t0, v1: joint.t1) ? e4 : e3)
        let e9 = (e3.spans(v0: joint.t0, v1: joint.t1) ? e5 : e4)
        
        let he0 = halfEdges[(e6.i * 2)]
        let he1 = halfEdges[(e7.i * 2)]
        let he2 = halfEdges[(e8.i * 2)]
        let he3 = halfEdges[(e9.i * 2)]
        
        let indices = Array(Set([e6.v0, e6.v1, e7.v0, e7.v1, e8.v0, e8.v1, e9.v0, e9.v1]))
        
        let i0 = indices[0]
        let i1 = indices[1]
        let i2 = indices[2]
        let i3 = indices[3]
        
        let v0 = vectors[i0]
        let v1 = vectors[i1]
        let v2 = vectors[i2]
        let v3 = vectors[i3]
        
        let v4 = (v0 + v1 + v2 + v3) / 4
        
        quads.append(Quad(v0: i0, v1: he0.v1, v2: vectors.count, v3: he3.v1))
        quads.append(Quad(v0: he0.v1, v1: i1, v2: he1.v1, v3: vectors.count))
        quads.append(Quad(v0: vectors.count, v1: he1.v1, v2: i2, v3: he2.v1))
        quads.append(Quad(v0: he3.v1, v1: vectors.count, v2: he2.v1, v3: i3))
        
        vectors.append(v4)
    }
}

extension Graph {
    
    func create(triangle v0: Int, v1: Int, v2: Int) {
        
        let e0 = findOrCreate(edge: v0, v1: v1)
        let e1 = findOrCreate(edge: v1, v1: v2)
        let e2 = findOrCreate(edge: v2, v1: v0)
        
        let index = triangles.count
        
        let triangle = Triangle(v0: v0, v1: v1, v2: v2)
        
        triangles.append(triangle)
        
        for edge in [e0, e1, e2] {
            
            let joint = findOrCreate(joint: edge.i, triangle: index)
            
            joints[joint.i].t1 = (joint.t0 != index ? index : joint.t1)
        }
    }
    
    func create(pair edge: Int, t0: Int, t1: Int) {
        
        let quad = Joint(i: pairs.count, e: edge, t0: t0, t1: t1)
        
        pairs.append(quad)
    }
    
    func findOrCreate(edge v0: Int, v1: Int) -> Edge {
        
        if let edge = find(edge: v0, v1: v1) {
            
            return edge
        }
        
        let edge = Edge(i: edges.count, v0: v0, v1: v1)
        
        edges.append(edge)
        
        return edge
    }
    
    func findOrCreate(joint edge: Int, triangle: Int) -> Joint {
        
        if edge < joints.count {
            
            return joints[edge]
        }
        
        let joint = Joint(i: joints.count, e: edge, t0: triangle)
        
        joints.append(joint)
        
        return joint
    }
    
    func find(edge v0: Int, v1: Int) -> Edge? {
        
        return edges.first { $0.spans(v0: v0, v1: v1) }
    }
    
    func find(joints triangle: Int) -> [Joint] {
        
        return joints.filter { $0.t0 == triangle || $0.t1 == triangle }
    }
    
    func find(pair triangle: Int) -> Joint? {
        
        return pairs.first { $0.t0 == triangle || $0.t1 == triangle }
    }
}

extension Array where Element == Int {
    
    func wind(steps: Int, slices: Int) -> [[Int]] {
        
        var result: [[Int]] = []
        
        let step = (steps - 1)
        
        for index in 0..<slices {
            
            let range = Range((index * step)...((index * step) + step))
            
            result.append(range.map { return self[($0 % count)] })
        }
        
        return result
    }
}
