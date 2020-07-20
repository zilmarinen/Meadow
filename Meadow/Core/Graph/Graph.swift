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
    
    struct Joint {
        
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
    
    struct Quad {
        
        let e0: Int
        let e1: Int
        let e2: Int
        let e3: Int
    }
    
    enum Constants {
        
        static let slices = 6
    }
    
    var vectors: [Vector] = []
    var edges: [Edge] = []
    var triangles: [Triangle] = []
    var joints: [Joint] = []
    var pairs: [Joint] = []
    var quads: [Quad] = []
    
    public init(origin: Vector, rings: Int, size: Double = 1.0) {
        
        let start = Date()
        
        generate(origin: origin, rings: rings, size: size)
        
        let mid = Date()
        
        quadrangulate()
        
        let end = Date()
        
        let m0 = (mid.timeIntervalSince1970 - start.timeIntervalSince1970)
        let m1 = (end.timeIntervalSince1970 - mid.timeIntervalSince1970)
        let elapsed = (end.timeIntervalSince1970 - start.timeIntervalSince1970)
        
        print("creating [\(rings)] hex rings")
        print("Triangulation: \(m0)")
        print("Quadrangulation: \(m1)")
        print("elapsed: \(elapsed)")
        
        print("-------")
        print("vectors: \(vectors.count)")
        print("edges: \(edges.count)")
        print("triangles: \(triangles.count)")
        print("joints: \(joints.count)")
        print("pairs: \(pairs.count)")
        print("quads: \(quads.count)")
    }
    
    public var geometry: SCNGeometry {
    
        var vertexCache: [Vector : UInt32] = [:]
        var vertices: [SCNVector3] = []
        var meshIndices: [UInt32] = []
        var colors: [SCNVector4] = []
        
        let drawEdges = false
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
        
        if drawJoints {
            
            let joins = joints.filter { $0.i1 != -1 }
            
            print("drawing [\(joins.count)] joints of [\(joints.count)]")
            
            for joint in joins {
                
                let t0 = triangles[joint.i0]
                let t1 = triangles[joint.i1]
                
                let e0 = edges[t0.e0]
                let e1 = edges[t0.e1]
                let e2 = edges[t0.e2]
                let e3 = edges[t1.e0]
                let e4 = edges[t1.e1]
                let e5 = edges[t1.e2]
                
                let v0 = (vectors[e0.v0] + vectors[e1.v0] + vectors[e2.v0]) / 3
                let v1 = (vectors[e3.v0] + vectors[e4.v0] + vectors[e5.v0]) / 3

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
            
            let joins = pairs.filter { $0.i1 != -1 }
            
            print("drawing [\(joins.count)] pairs of [\(pairs.count)]")
            
            for joint in joins {
                
                let q = quad(for: joint)
                
                let t0 = triangles[joint.i0]
                let t1 = triangles[joint.i1]
                
                let e0 = edges[q.e0]
                let e1 = edges[q.e1]
                let e2 = edges[q.e2]
                let e3 = edges[q.e3]
                
                let v0 = vectors[e0.v0]
                let v1 = vectors[e1.v0]
                let v2 = vectors[e2.v0]
                let v3 = vectors[e3.v0]

                for v2 in [v0, v1, v1, v2, v2, v3, v3, v0] {
                    
                    var v2 = v2
                    v2.y = -3

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
                
                let e4 = edges[t0.e0]
                let e5 = edges[t0.e1]
                let e6 = edges[t0.e2]
                
                let e7 = edges[t1.e0]
                let e8 = edges[t1.e1]
                let e9 = edges[t1.e2]
                
                let v4 = (vectors[e4.v0] + vectors[e5.v0] + vectors[e6.v0]) / 3
                let v5 = (vectors[e7.v0] + vectors[e8.v0] + vectors[e9.v0]) / 3

                for v2 in [v4, v5] {
                    
                    var v2 = v2
                    v2.y = -3

                    if let index = vertexCache[v2] {

                        meshIndices.append(index)
                    }
                    else {

                        let index = UInt32(vertexCache.count)

                        vertexCache[v2] = index

                        vertices.append(SCNVector3(vector: v2))
                        colors.append(SCNVector4(x: 1.0, y: 1.0, z: 0.0, w: 1.0))

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
                    
                    var v2 = v2
                    v2.y = 3.0

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
        edges.removeAll()
        triangles.removeAll()
        joints.removeAll()
        
        vectors.append(origin)
        
        let rings = max(rings, 1)
        
        var offset = 0
        var inner = Array(repeating: [0], count: Constants.slices)
        
        for ring in 0..<rings {
            
            //
            //  Create corners for current hexagon ring
            //
            
            let radius = Double(ring + 1) * size
            
            var corners: [Vector] = []
            
            for index in 0..<Constants.slices {
            
                corners.append(Math.plot(delta: Double(index), slices: Constants.slices) * radius)
            }
            
            //
            //  Calculate outer hexagon vertex indices
            //
            
            let i = (ring * Constants.slices)
            let j = ((ring + 1) * Constants.slices)
            
            let outer = Array(((offset + i) + 1)...((offset + i) + j)).wind(steps: (ring + 2), slices: Constants.slices)
            
            offset += (ring * Constants.slices)
            
            //
            //  Create vertices along edge of slice
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
                //  Calculate inner hexagon vertex indices
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
    }
    
    func quadrangulate() {
        
        pairs.removeAll()
        quads.removeAll()
        
        for index in joints.indices {
            
            let joint = joints[index]
            
            let edge = edges[joint.e0]
            
            let v0 = vectors[edge.v0]
            let v1 = vectors[edge.v1]
            let v2 = (v0 + v1) / 2
            
            joints[index].v = vectors.count
            
            vectors.append(v2)
        }
        
        let indices = triangles.indices.shuffled()
    
        for index in indices {
            
            guard find(pair: index) == nil else { continue }
            
            let joins = find(joints: index).shuffled()
            
            var connected = false
            
            for j in 0..<joins.count {
                
                let joint = joins[j]
                
                let adjacentIndex = (joint.i0 != index ? joint.i0 : joint.i1)
                
                if find(pair: adjacentIndex) == nil {
                    
                    pairs.append(Joint(i: pairs.count, e0: joint.e0, e1: joint.e1, i0: joint.i0, i1: joint.i1, v: joint.v))
                    
                    divide(pair: pairs[pairs.count - 1])
                    
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
        
        let e0 = edges[triangle.e0]
        let e1 = edges[triangle.e1]
        let e2 = edges[triangle.e2]
        
        let j0 = joints[e0.j]
        let j1 = joints[e1.j]
        let j2 = joints[e2.j]
        
        let v0 = vectors[e0.v0]
        let v1 = vectors[e1.v0]
        let v2 = vectors[e2.v0]
        
        let v6 = (v0 + v1 + v2) / 3
        
        let index = vectors.count
        
        vectors.append(v6)
        
        create(quad: e0.v0, v1: j0.v, v2: index, v3: j2.v)
        create(quad: e1.v0, v1: j1.v, v2: index, v3: j0.v)
        create(quad: e2.v0, v1: j2.v, v2: index, v3: j1.v)
    }
    
    func divide(pair: Joint) {
        
        let q = quad(for: pair)
        
        let e0 = edges[q.e0]
        let e1 = edges[q.e1]
        let e2 = edges[q.e2]
        let e3 = edges[q.e3]
        
        let j0 = joints[e0.j]
        let j1 = joints[e1.j]
        let j2 = joints[e2.j]
        let j3 = joints[e3.j]
        
        let v0 = vectors[e0.v0]
        let v1 = vectors[e1.v0]
        let v2 = vectors[e2.v0]
        let v3 = vectors[e3.v0]
        
        let v8 = (v0 + v1 + v2 + v3) / 4
        
        let index = vectors.count
        
        vectors.append(v8)
        
        create(quad: e0.v0, v1: j0.v, v2: index, v3: j3.v)
        create(quad: j0.v, v1: e1.v0, v2: j1.v, v3: index)
        create(quad: index, v1: j1.v, v2: e2.v0, v3: j2.v)
        create(quad: j3.v, v1: index, v2: j2.v, v3: e3.v0)
    }
}

extension Graph {
    
    func create(triangle v0: Int, v1: Int, v2: Int) {
        
        let e0 = create(edge: v0, v1: v1)
        let e1 = create(edge: v1, v1: v2)
        let e2 = create(edge: v2, v1: v0)
        
        let index = triangles.count
        
        let triangle = Triangle(e0: e0.i, e1: e1.i, e2: e2.i)
        
        triangles.append(triangle)
        
        for edge in [e0, e1, e2] {
            
            let joint = findOrCreate(joint: edge, neighbour: index)
            
            joints[joint.i].i1 = (joint.i0 != index && joint.i1 == -1 ? index : joint.i1)
            joints[joint.i].e1 = (joint.e0 != edge.i && joint.e1 == -1 ? edge.i : joint.e1)
            
            edges[edge.i].j = joint.i
        }
    }
    
    func create(edge v0: Int, v1: Int) -> Edge {
        
        assert(v0 != -1)
        assert(v1 != -1)
        
       let edge = Edge(i: edges.count, v0: v0, v1: v1)
        
        edges.append(edge)
        
        return edge
    }
    
    func create(quad v0: Int, v1: Int, v2: Int, v3: Int) {
        
        let e0 = create(edge: v0, v1: v1)
        let e1 = create(edge: v1, v1: v2)
        let e2 = create(edge: v2, v1: v3)
        let e3 = create(edge: v3, v1: v0)
        
        let index = quads.count
        
        let quad = Quad(e0: e0.i, e1: e1.i, e2: e2.i, e3: e3.i)
        
        quads.append(quad)
    }
    
    func findOrCreate(joint edge: Edge, neighbour: Int) -> Joint {
        
        if let joint = find(joint: edge) {
            
            return joint
        }
        
        let joint = Joint(i: joints.count, e0: edge.i, i0: neighbour)
        
        joints.append(joint)
        
        return joint
    }
    
    func find(joint edge: Edge) -> Joint? {
        
        return joints.first { edges[$0.e0].spans(v0: edge.v0, v1: edge.v1) }
    }
    
    func find(joints triangle: Int) -> [Joint] {
        
        let t0 = triangles[triangle]
        
        return joints.filter{ $0.i0 == triangle || $0.i1 == triangle}.filter { $0.e0 == t0.e0 || $0.e0 == t0.e1 || $0.e0 == t0.e2 || $0.e1 == t0.e0 || $0.e1 == t0.e1 || $0.e1 == t0.e2}.filter { $0.e1 != -1 && $0.i0 != -1 }
    }
    
    func find(pair triangle: Int) -> Joint? {
        
        return pairs.first { $0.i0 == triangle || $0.i1 == triangle }
    }
    
    func quad(for pair: Joint) -> Quad {
        
        let t0 = triangles[pair.i0]
        let t1 = triangles[pair.i1]
        
        let e0 = edges[t0.e0]
        let e1 = edges[t0.e1]
        let e2 = edges[t0.e2]
        
        let e3 = edges[t1.e0]
        let e4 = edges[t1.e1]
        let e5 = edges[t1.e2]
        
        let diagonal = edges[pair.e0]
        
        let e0d = e0.spans(v0: diagonal.v0, v1: diagonal.v1)
        let e1d = e1.spans(v0: diagonal.v0, v1: diagonal.v1)
        
        let e0s = e0.spans(v0: e5.v0, v1: e5.v1)
        let e1s = e1.spans(v0: e3.v0, v1: e3.v1)
        let e2s = e2.spans(v0: e4.v0, v1: e4.v1)
        
        let x = (e0s || e2s ? e3 : e5)
        let y = (e0s || e1s ? e4 : e3)
        let z = (e1s || e2s ? e5 : e4)
        
        let e6 = (e0d ? e1 : e0)
        let e7 = (e0d ? e2 : (e1d ? y : e1))
        let e8 = (e0d ? x : z)
        let e9 = (e0d ? y : (e1s ? e2 : x))
        
        return Quad(e0: e6.i, e1: e7.i, e2: e8.i, e3: e9.i)
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
