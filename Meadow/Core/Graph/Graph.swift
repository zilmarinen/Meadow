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
    
    struct Result {
        
        var vectors: [Vector] = []
        var quads: [GraphCache.Quad] = []
        var edges: [GraphCache.Edge] = []
        var joints: [GraphCache.Joint] = []
    }
    
    enum Constants {
        
        static let slices = 6
        static let floor = Vector(x: 0.0, y: World.Axis.y(value: World.Constants.floor + 4), z: 0)
    }
    
    var cache = GraphCache()
    var data = Result()
    
    public init(rings: Int, size: Double = 1.0, iterations: Int = 1) {
        
        let start = Date()
        
        generate(rings: rings, size: size)
        
        let tris = Date()
        
        quadrangulate()
        
        let quads = Date()
        
        relax(iterations: iterations)
        
        let smooth = Date()
        
        let m0 = (tris.timeIntervalSince1970 - start.timeIntervalSince1970)
        let m1 = (quads.timeIntervalSince1970 - tris.timeIntervalSince1970)
        let m2 = (smooth.timeIntervalSince1970 - quads.timeIntervalSince1970)
        let elapsed = (smooth.timeIntervalSince1970 - start.timeIntervalSince1970)
        
        print("creating [\(rings)] hex rings")
        print("Triangulation: \(m0)")
        print("Quadrangulation: \(m1)")
        print("Relaxing: \(m2)")
        print("elapsed: \(elapsed)")
        
        print("-------")
        print("vectors: \(data.vectors.count)")
        print("edges: \(data.edges.count)")
        print("triangles: \(cache.triangles.count)")
        print("joints: \(data.joints.count)")
        print("pairs: \(cache.pairs.count)")
        print("quads: \(data.quads.count)")
        
        cache.clear()
    }
}

extension Graph {
    
    public var totalQuads: Int { return data.quads.count }
    
    func quad(at index: Int) -> GraphCache.Quad {
        
        return data.quads[index]
    }
    
    func edges(for quad: GraphCache.Quad) -> [GraphCache.Edge] {
        
        return [quad.e0, quad.e1, quad.e2, quad.e3].map { data.edges[$0] }
    }
    
    func joints(for quad: GraphCache.Quad) -> [GraphCache.Joint] {
        
        return edges(for: quad).map { data.joints[$0.j] }
    }
    
    func vectors(for quad: GraphCache.Quad) -> [Vector] {
        
        return edges(for: quad).map { data.vectors[$0.v0] }
    }
}

extension Graph {
    
    func generate(rings: Int, size: Double = 1.0) {
        
        cache.clear()
        
        cache.vectors.append(Constants.floor)
        
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
                
                cache.vectors.append(Constants.floor + v0)
                
                if ring > 0 {
                
                    let step = 1.0 / Double(ring + 1)
                    
                    for division in 1..<(ring + 1) {
                        
                        cache.vectors.append(Constants.floor + v0.lerp(vector: v1, interpolater: step * Double(division)))
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
                    
                    cache.create(triangle: lhs[k][0], v1: lhs[k][1], v2: rhs[k])
                }

                for k in 0..<inside.count {
                    
                    cache.create(triangle: adjacent[k][0], v1: inside[k], v2: adjacent[k][1])
                }
            }
            
            inner = outer
        }
    }
    
    func quadrangulate() {
        
        for index in cache.joints.indices {
            
            let joint = cache.joints[index]
            
            let edge = cache.edges[joint.e0]
            
            let v0 = cache.vectors[edge.v0]
            let v1 = cache.vectors[edge.v1]
            let v2 = (v0 + v1) / 2
            
            cache.joints[index].v = cache.vectors.count
            
            cache.vectors.append(v2)
        }
        
        data.vectors = Array(cache.vectors)
        
        let indices = cache.triangles.indices.shuffled()
    
        for index in indices {
            
            guard cache.find(pair: index) == nil else { continue }
            
            let joins = cache.find(joints: index).shuffled()
            
            var connected = false
            
            for j in 0..<joins.count {
                
                let joint = joins[j]
                
                let adjacentIndex = (joint.i0 != index ? joint.i0 : joint.i1)
                
                if cache.find(pair: adjacentIndex) == nil {
                    
                    let pair = cache.create(pair: joint)
                    
                    divide(pair: pair)
                    
                    connected = true
                    
                    break
                }
            }
            
            if !connected {
            
                divide(triangle: cache.triangles[index])
            }
        }
        
      //  data.joints.removeAll { $0.i1 == -1 }
    }
    
    func relax(iterations: Int) {
        
        for _ in 0..<iterations {
            
            let indices = data.quads.indices.shuffled()
            
            for index in indices {
                
                let quad = data.quads[index]
                
                let e0 = data.edges[quad.e0]
                let e1 = data.edges[quad.e1]
                let e2 = data.edges[quad.e2]
                let e3 = data.edges[quad.e3]
                
                var maximum = 0.0
                var edges: [GraphCache.Edge : Double] = [:]
                
                for edge in [e0, e1, e2, e3] {

                    edges[edge] = (1.0 + (quad.v - data.vectors[edge.v0]).squaredMagnitude)
                    
                    maximum = max(maximum, edges[edge]!)
                }
                
                let interpolator = (1 / maximum)
                
                for (edge, magnitude) in edges {
                    
                    data.vectors[edge.v0] = quad.v.lerp(vector: data.vectors[edge.v0], interpolater: interpolator * magnitude)
                }
            }
            
            for index in data.vectors.indices {

                let joins: [Int] = data.joints.compactMap {

                    let e0 = data.edges[$0.e0]

                    return (e0.v0 == index ? e0.v1 : (e0.v1 == index ? e0.v0 : nil))
                }

                guard joins.count > 3 else { continue }

                var v0 = Vector.zero

                for i in joins {

                    v0 = v0 + data.vectors[i]
                }

                data.vectors[index] = (v0 / Double(joins.count))
            }
        }
    }
}

extension Graph {
    
    func divide(triangle: GraphCache.Triangle) {
        
        let e0 = cache.edges[triangle.e0]
        let e1 = cache.edges[triangle.e1]
        let e2 = cache.edges[triangle.e2]
        
        let j0 = cache.joints[e0.j]
        let j1 = cache.joints[e1.j]
        let j2 = cache.joints[e2.j]
        
        let v0 = cache.vectors[e0.v0]
        let v1 = cache.vectors[e1.v0]
        let v2 = cache.vectors[e2.v0]
        
        let v6 = (v0 + v1 + v2) / 3
        
        let index = data.vectors.count
        
        data.vectors.append(v6)
        
        create(quad: e0.v0, v1: j0.v, v2: index, v3: j2.v)
        create(quad: e1.v0, v1: j1.v, v2: index, v3: j0.v)
        create(quad: e2.v0, v1: j2.v, v2: index, v3: j1.v)
    }
    
    func divide(pair: GraphCache.Joint) {
        
        let q = cache.quad(for: pair)
        
        let e0 = cache.edges[q.e0]
        let e1 = cache.edges[q.e1]
        let e2 = cache.edges[q.e2]
        let e3 = cache.edges[q.e3]
        
        let j0 = cache.joints[e0.j]
        let j1 = cache.joints[e1.j]
        let j2 = cache.joints[e2.j]
        let j3 = cache.joints[e3.j]
        
        let v0 = cache.vectors[e0.v0]
        let v1 = cache.vectors[e1.v0]
        let v2 = cache.vectors[e2.v0]
        let v3 = cache.vectors[e3.v0]
        
        let v8 = (v0 + v1 + v2 + v3) / 4
        
        let index = data.vectors.count
        
        data.vectors.append(v8)
        
        create(quad: e0.v0, v1: j0.v, v2: index, v3: j3.v)
        create(quad: j0.v, v1: e1.v0, v2: j1.v, v3: index)
        create(quad: index, v1: j1.v, v2: e2.v0, v3: j2.v)
        create(quad: j3.v, v1: index, v2: j2.v, v3: e3.v0)
    }
}

extension Graph {
    
    func create(edge v0: Int, v1: Int) -> GraphCache.Edge {
    
        let edge = GraphCache.Edge(i: data.edges.count, v0: v0, v1: v1)
        
        data.edges.append(edge)
        
        return edge
    }
    
    func create(quad v0: Int, v1: Int, v2: Int, v3: Int) {
        
        let e0 = create(edge: v0, v1: v1)
        let e1 = create(edge: v1, v1: v2)
        let e2 = create(edge: v2, v1: v3)
        let e3 = create(edge: v3, v1: v0)
        
        let v = (data.vectors[e0.v0] + data.vectors[e1.v0] + data.vectors[e2.v0] + data.vectors[e3.v0]) / 4
        
        let index = data.quads.count
        
        let quad = GraphCache.Quad(i: index, e0: e0.i, e1: e1.i, e2: e2.i, e3: e3.i, v: v)
        
        data.quads.append(quad)
        
        for edge in [e0, e1, e2, e3] {
            
            let joint = findOrCreate(joint: edge, neighbour: index)
            
            data.joints[joint.i].i1 = (joint.i0 != index && joint.i1 == -1 ? index : joint.i1)
            data.joints[joint.i].e1 = (joint.e0 != edge.i && joint.e1 == -1 ? edge.i : joint.e1)
            
            data.edges[edge.i].j = joint.i
        }
    }
    
    func findOrCreate(joint edge: GraphCache.Edge, neighbour: Int) -> GraphCache.Joint {
        
        if let joint = find(joint: edge) {
            
            return joint
        }
        
        let joint = GraphCache.Joint(i: data.joints.count, e0: edge.i, i0: neighbour)
        
        data.joints.append(joint)
        
        return joint
    }
    
    func find(joint edge: GraphCache.Edge) -> GraphCache.Joint? {
        
        return data.joints.first { data.edges[$0.e0].spans(v0: edge.v0, v1: edge.v1) }
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
        let drawPairs = false
        let drawQuads = true
        
        if drawEdges {
            
            print("drawing [\(data.edges.count)] edges")
        
            for edge in data.edges {

                let v0 = data.vectors[edge.v0]
                let v1 = data.vectors[edge.v1]

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
            
            let joins = data.joints.filter { $0.i1 != -1 }
            
            print("drawing [\(joins.count)] joints of [\(data.joints.count)]")
            
            for joint in joins {
                
                let t0 = data.quads[joint.i0]
                let t1 = data.quads[joint.i1]
                
                let e0 = data.edges[t0.e0]
                let e1 = data.edges[t0.e1]
                let e2 = data.edges[t0.e2]
                let e3 = data.edges[t0.e3]
                
                let e4 = data.edges[t1.e0]
                let e5 = data.edges[t1.e1]
                let e6 = data.edges[t1.e2]
                let e7 = data.edges[t1.e3]
                
                let v0 = (data.vectors[e0.v0] + data.vectors[e1.v0] + data.vectors[e2.v0] + data.vectors[e3.v0]) / 4
                let v1 = (data.vectors[e4.v0] + data.vectors[e5.v0] + data.vectors[e6.v0] + data.vectors[e7.v0]) / 4

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
        
        if drawPairs {
            
            let joins = cache.pairs.filter { $0.i1 != -1 }
            
            print("drawing [\(joins.count)] pairs of [\(cache.pairs.count)]")
            
            for joint in joins {
                
                let q = cache.quad(for: joint)
                
                let t0 = cache.triangles[joint.i0]
                let t1 = cache.triangles[joint.i1]
                
                let e0 = cache.edges[q.e0]
                let e1 = cache.edges[q.e1]
                let e2 = cache.edges[q.e2]
                let e3 = cache.edges[q.e3]
                
                let v0 = cache.vectors[e0.v0]
                let v1 = cache.vectors[e1.v0]
                let v2 = cache.vectors[e2.v0]
                let v3 = cache.vectors[e3.v0]

                for v2 in [v0, v1, v1, v2, v2, v3, v3, v0] {

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
                
                let e4 = cache.edges[t0.e0]
                let e5 = cache.edges[t0.e1]
                let e6 = cache.edges[t0.e2]
                
                let e7 = cache.edges[t1.e0]
                let e8 = cache.edges[t1.e1]
                let e9 = cache.edges[t1.e2]
                
                let v4 = (cache.vectors[e4.v0] + cache.vectors[e5.v0] + cache.vectors[e6.v0]) / 3
                let v5 = (cache.vectors[e7.v0] + cache.vectors[e8.v0] + cache.vectors[e9.v0]) / 3

                for v2 in [v4, v5] {

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
            
            print("drawing [\(data.quads.count)] quads")
            
            for quad in data.quads {
                
                let e0 = data.edges[quad.e0]
                let e1 = data.edges[quad.e1]
                let e2 = data.edges[quad.e2]
                let e3 = data.edges[quad.e3]
                
                let v0 = data.vectors[e0.v0]
                let v1 = data.vectors[e1.v0]
                let v2 = data.vectors[e2.v0]
                let v3 = data.vectors[e3.v0]
                
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
