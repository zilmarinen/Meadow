//
//  Graphswift
//  Meadow
//
//  Created by Zack Brown on 20/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class GraphCache {
    
    struct Triangles {
        
        var edges: [Graph.Edge] = []
        var joints: [Graph.Joint] = []
        var triangles: [Graph.Triangle] = []
        var pairs: [Graph.Joint] = []
        
        mutating func create(edge v0: Int, v1: Int) -> Graph.Edge {
        
            let edge = Graph.Edge(i: edges.count, v0: v0, v1: v1)
            
            edges.append(edge)
            
            return edge
        }
        
        mutating func create(pair joint: Graph.Joint) -> Graph.Joint {
            
            let pair = Graph.Joint(i: pairs.count, e0: joint.e0, e1: joint.e1, i0: joint.i0, i1: joint.i1, v: joint.v)
            
            pairs.append(pair)
            
            return pair
        }
        
        mutating func create(triangle v0: Int, v1: Int, v2: Int) {
            
            let e0 = create(edge: v0, v1: v1)
            let e1 = create(edge: v1, v1: v2)
            let e2 = create(edge: v2, v1: v0)
            
            let index = triangles.count
            
            let triangle = Graph.Triangle(e0: e0.i, e1: e1.i, e2: e2.i)
            
            triangles.append(triangle)
            
            for edge in [e0, e1, e2] {
                
                let joint = findOrCreate(joint: edge, neighbour: index)
                
                joints[joint.i].i1 = (joint.i0 != index && joint.i1 == -1 ? index : joint.i1)
                joints[joint.i].e1 = (joint.e0 != edge.i && joint.e1 == -1 ? edge.i : joint.e1)
                
                edges[edge.i].j = joint.i
            }
        }
        
        mutating func findOrCreate(joint edge: Graph.Edge, neighbour: Int) -> Graph.Joint {
            
            if let joint = find(joint: edge) {
                
                return joint
            }
            
            let joint = Graph.Joint(i: joints.count, e0: edge.i, i0: neighbour)
            
            joints.append(joint)
            
            return joint
        }
        
        func find(joint edge: Graph.Edge) -> Graph.Joint? {
            
            return joints.first { edges[$0.e0].spans(v0: edge.v0, v1: edge.v1) }
        }
        
        func find(joints triangle: Int) -> [Graph.Joint] {
            
            let t0 = triangles[triangle]
            
            return joints.filter { $0.e0 == t0.e0 || $0.e0 == t0.e1 || $0.e0 == t0.e2 || $0.e1 == t0.e0 || $0.e1 == t0.e1 || $0.e1 == t0.e2}.filter { $0.e1 != -1 && $0.i0 != -1 }
        }
        
        func find(pair triangle: Int) -> Graph.Joint? {
            
            return pairs.first { $0.i0 == triangle || $0.i1 == triangle }
        }
    }
    
    struct Quads {
        
        var edges: [Graph.Edge] = []
        var joints: [Graph.Joint] = []
        var quads: [Graph.Quad] = []
        
        mutating func create(edge v0: Int, v1: Int) -> Graph.Edge {
        
            let edge = Graph.Edge(i: edges.count, v0: v0, v1: v1)
            
            edges.append(edge)
            
            return edge
        }
        
        mutating func create(quad v0: Int, v1: Int, v2: Int, v3: Int, centre: Vector) {
            
            let e0 = create(edge: v0, v1: v1)
            let e1 = create(edge: v1, v1: v2)
            let e2 = create(edge: v2, v1: v3)
            let e3 = create(edge: v3, v1: v0)
            
            let index = quads.count
            
            let quad = Graph.Quad(i: index, e0: e0.i, e1: e1.i, e2: e2.i, e3: e3.i, v: centre)
            
            quads.append(quad)
            
            for edge in [e0, e1, e2, e3] {
                
                let joint = findOrCreate(joint: edge, neighbour: index)
                
                joints[joint.i].i1 = (joint.i0 != index && joint.i1 == -1 ? index : joint.i1)
                joints[joint.i].e1 = (joint.e0 != edge.i && joint.e1 == -1 ? edge.i : joint.e1)
                
                edges[edge.i].j = joint.i
            }
        }
        
        func find(edges vector: Int) -> [Graph.Edge] {
            
            return edges.filter { $0.v0 == vector || $0.v1 == vector }
        }
        
        mutating func findOrCreate(joint edge: Graph.Edge, neighbour: Int) -> Graph.Joint {
            
            if let joint = find(joint: edge) {
                
                return joint
            }
            
            let joint = Graph.Joint(i: joints.count, e0: edge.i, i0: neighbour)
            
            joints.append(joint)
            
            return joint
        }
        
        func find(joint edge: Graph.Edge) -> Graph.Joint? {
            
            return joints.first { edges[$0.e0].spans(v0: edge.v0, v1: edge.v1) }
        }
        
        func find(vectors vector: Int) -> [Int] {
            
            return Array(Set(find(edges: vector).map { ($0.v0 == vector ? $0.v1 : $0.v0) }))
        }
    }
    
    var vectors: [Vector] = []
    var triangles = Triangles()
    var quads = Quads()
}

extension GraphCache {
    
    func create(quad v0: Int, v1: Int, v2: Int, v3: Int) {
     
        let center = (vectors[v0] + vectors[v1] + vectors[v2] + vectors[v3]) / 4
        
        quads.create(quad: v0, v1: v1, v2: v2, v3: v3, centre: center)
    }
    
    func divide(triangle: Graph.Triangle) {
        
        let e0 = triangles.edges[triangle.e0]
        let e1 = triangles.edges[triangle.e1]
        let e2 = triangles.edges[triangle.e2]
        
        let j0 = triangles.joints[e0.j]
        let j1 = triangles.joints[e1.j]
        let j2 = triangles.joints[e2.j]
        
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
    
    func divide(pair: Graph.Joint) {
        
        let t0 = triangles.triangles[pair.i0]
        let t1 = triangles.triangles[pair.i1]
        
        let e0 = triangles.edges[t0.e0]
        let e1 = triangles.edges[t0.e1]
        let e2 = triangles.edges[t0.e2]
        
        let e3 = triangles.edges[t1.e0]
        let e4 = triangles.edges[t1.e1]
        let e5 = triangles.edges[t1.e2]
        
        let diagonal = triangles.edges[pair.e0]
        
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
        
        let j0 = triangles.joints[e6.j]
        let j1 = triangles.joints[e7.j]
        let j2 = triangles.joints[e8.j]
        let j3 = triangles.joints[e9.j]
        let j4 = triangles.joints[diagonal.j]
        
        create(quad: e6.v0, v1: j0.v, v2: j4.v, v3: j3.v)
        create(quad: j0.v, v1: e7.v0, v2: j1.v, v3: j4.v)
        create(quad: j4.v, v1: j1.v, v2: e8.v0, v3: j2.v)
        create(quad: j3.v, v1: j4.v, v2: j2.v, v3: e9.v0)
    }
}
