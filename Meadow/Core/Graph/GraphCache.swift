//
//  Graphswift
//  Meadow
//
//  Created by Zack Brown on 20/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class GraphCache {
    
    public struct Edge: Codable, Hashable {
        
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
    
    struct Joint: Codable {
        
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
    
    struct Quad: Codable {
        
        let i: Int
        
        let e0: Int
        let e1: Int
        let e2: Int
        let e3: Int
        
        let v: Vector
    }

    var vectors: [Vector] = []
    var edges: [Edge] = []
    var triangles: [Triangle] = []
    var joints: [Joint] = []
    var pairs: [Joint] = []
}

extension GraphCache {
    
    func clear() {
        
        vectors.removeAll()
        edges.removeAll()
        triangles.removeAll()
        joints.removeAll()
        pairs.removeAll()
    }
    
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
    
        let edge = Edge(i: edges.count, v0: v0, v1: v1)
        
        edges.append(edge)
        
        return edge
    }
    
    func create(pair joint: Joint) -> Joint {
        
        let pair = Joint(i: pairs.count, e0: joint.e0, e1: joint.e1, i0: joint.i0, i1: joint.i1, v: joint.v)
        
        pairs.append(pair)
        
        return pair
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
        
        return joints.filter { $0.e0 == t0.e0 || $0.e0 == t0.e1 || $0.e0 == t0.e2 || $0.e1 == t0.e0 || $0.e1 == t0.e1 || $0.e1 == t0.e2}.filter { $0.e1 != -1 && $0.i0 != -1 }
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
        
        let v = (vectors[e6.v0] + vectors[e7.v0] + vectors[e8.v0] + vectors[e9.v0]) / 4
        
        return Quad(i: -1, e0: e6.i, e1: e7.i, e2: e8.i, e3: e9.i, v: v)
    }
}
