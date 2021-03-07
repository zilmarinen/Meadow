//
//  Polygon.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public class Polygon: Hashable {
    
    let vertices: [Vertex]
    
    lazy var bounds: Bounds = {
    
        return Bounds(vectors: vertices.map { $0.position })
    }()
    
    lazy var plane: Plane = {
        
        return Plane(vectors: vertices.map { $0.position })
    }()
    
    public init(vertices: [Vertex]) {
        
        self.vertices = vertices
    }
}

extension Polygon {
    
    public static func == (lhs: Polygon, rhs: Polygon) -> Bool {
        
        return lhs === rhs || (lhs.vertices == rhs.vertices && lhs.bounds == rhs.bounds && lhs.plane == rhs.plane)
    }

    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(vertices)
        hasher.combine(bounds)
        hasher.combine(plane)
    }
}

extension Polygon {
    
    func inverted() -> Polygon {
        
        return Polygon(vertices: vertices.reversed().map { $0.inverted() })
    }
    
    func contains(vector: Vector) -> Bool {
        
        guard plane.contains(vector: vector), bounds.contains(vector: vector) else { return false }
        
        var result = false
        
        let vectors = vertices.map { $0.position }
        
        let plane = Plane.Flattening(bounds: Bounds(vectors: vectors))
        
        let vertices = vectors.map { plane.flatten(vector: $0 ) }
        
        let flattened = plane.flatten(vector: vector)
        
        for i in 0..<vertices.count {
        
            let p0 = vertices[i]
            let p1 = vertices[(i + 1) % vertices.count]
            
            if (p0.y > flattened.y) != (p1.y > flattened.y), flattened.x < (p1.x - p0.x) * (flattened.y - p0.y) / (p1.y - p0.y) + p0.x {
                
                result = !result
            }
        }
        
        return result
    }
}

extension Polygon {
    
    func triangulate() -> [Polygon] {
        
        guard vertices.count > 3 else { return [self] }
        
        var triangles: [Polygon] = []
        
        if vertices.map({ $0.position }).convex() {
            
            let v0 = vertices[0]
            var v1 = vertices[1]
            
            for i in 2..<vertices.count {
                
                let v2 = vertices[i]
                
                triangles.append(Polygon(vertices: [v0, v1, v2]))
                
                v1 = v2
            }
            
            return triangles
        }
        
        var remainder = vertices
        
        var i = 0
        
        while remainder.count > 3 {
            
            let v0 = remainder[(i - 1 + remainder.count) % remainder.count]
            let v1 = remainder[i]
            let v2 = remainder[(i + 1) % remainder.count]
            
            let v0v1 = v0.position - v1.position
            let v2v1 = v2.position - v1.position
            
            if v0v1.cross(vector: v2v1).magnitude < Math.epsilon {
                
                if v0v1.dot(vector: v2v1) > 0 {
                    
                    remainder.remove(at: i)
                    
                    i = (i == remainder.count ? 0 : i)
                }
                else {
                    
                    i += 1
                }
                
                continue
            }
            
            let triangle = Polygon(vertices: [v0, v1, v2])
            
            if triangle.plane.normal.dot(vector: plane.normal) <= 0 || remainder.contains(where: {
                
                triangle.vertices.contains($0) && triangle.contains(vector: $0.position)
            }) {
                
                i = (i < remainder.count ? 0 : i + 1)
            }
            else {
                
                triangles.append(Polygon(vertices: triangle.vertices))
                
                remainder.remove(at: i)
                
                i = (i == remainder.count ? 0 : i)
            }
        }
        
        triangles.append(Polygon(vertices: remainder))
        
        return triangles
    }
}
    
extension Polygon {
    
    var edges: [Plane] {
        
        var planes: [Plane] = []
        
        var v0 = vertices.last!
        
        for v1 in vertices {
            
            let ab = v1.position - v0.position
            
            let normal = ab.cross(vector: plane.normal).normalised()
            
            let plane = Plane(normal: normal, distance: normal.dot(vector: v0.position))
            
            planes.append(plane)
            
            v0 = v1
        }
        
        return planes
    }
}

extension Polygon: Transformable {
    
    public func translated(by translation: Vector) -> Polygon {
        
        return Polygon(vertices: vertices.translated(by: translation))
    }
    
    public func rotated(by rotation: Rotation) -> Polygon {
        
        return Polygon(vertices: vertices.rotated(by: rotation))
    }
    
    public func scaled(by scale: Vector) -> Polygon {
        
        let threshold = 0.001
        
        var clamped = Vector.zero
        
        clamped.x = scale.x < 0 ? min(-threshold, scale.x) : max(threshold, scale.x)
        clamped.y = scale.y < 0 ? min(-threshold, scale.y) : max(threshold, scale.y)
        clamped.z = scale.z < 0 ? min(-threshold, scale.z) : max(threshold, scale.z)
        
        return Polygon(vertices: vertices.scaled(by: clamped))
    }
    
    public func transformed(by transform: Transform) -> Polygon {
        
        return scaled(by: transform.scale).rotated(by: transform.rotation).translated(by: transform.position)
    }
}

public extension Array where Element == Polygon {
    
    func translated(by translation: Vector) -> Self {
        
        return map { $0.translated(by: translation) }
    }
    
    func rotated(by rotation: Rotation) -> Self {
        
        return map { $0.rotated(by: rotation) }
    }
    
    func scaled(by scale: Vector) -> Self {
        
        return map { $0.scaled(by: scale) }
    }
    
    func transformed(by transform: Transform) -> Self {
        
        return map { $0.transformed(by: transform) }
    }
}
