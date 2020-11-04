//
//  Bounds.swift
//
//  Created by Zack Brown on 03/11/2020.
//

struct Bounds: Hashable {
    
    let minimum: Vector
    let maximum: Vector
    
    init(minimum: Vector, maximum: Vector) {
        
        self.minimum = minimum
        self.maximum = maximum
    }
    
    init(vectors: [Vector]) {
        
        var minimum = Vector.infinity
        var maximum = -Vector.infinity
        
        for vector in vectors {
            
            minimum = Vector.minimum(lhs: minimum, rhs: vector)
            maximum = Vector.maximum(lhs: maximum, rhs: vector)
        }
        
        self.minimum = minimum
        self.maximum = maximum
    }
}

extension Bounds {
    
    static var empty = Bounds(minimum: .zero, maximum: .zero)
    static var infinite = Bounds(minimum: .infinity, maximum: -.infinity)
}

extension Bounds {
    
    func isEqual(to bounds: Bounds) -> Bool {
        
        return minimum.isEqual(to: bounds.minimum) && maximum.isEqual(to: bounds.maximum)
    }
}

extension Bounds {
    
    var isEmpty: Bool {
        
        return maximum.x < minimum.x || maximum.y < minimum.y || maximum.z < minimum.z
    }
    
    var size: Vector {
        
        return isEmpty ? .zero : maximum - minimum
    }
    
    var center: Vector {
        
        return isEmpty ? .zero : (minimum + size) / 2
    }
    
    var corners: [Vector] {
        
        return [minimum,
                Vector(x: minimum.x, y: maximum.y, z: minimum.z),
                Vector(x: maximum.x, y: maximum.y, z: minimum.z),
                Vector(x: maximum.x, y: minimum.y, z: minimum.z),
                Vector(x: minimum.x, y: minimum.y, z: maximum.z),
                Vector(x: minimum.x, y: maximum.y, z: maximum.z),
                maximum,
                Vector(x: maximum.x, y: minimum.y, z: maximum.z)]
    }
}

extension Bounds {
    
    func union(bounds: Bounds) -> Bounds {
        
        guard !isEmpty else { return bounds }
        guard !bounds.isEmpty else { return self }
        
        return Bounds(minimum: Vector.minimum(lhs: minimum, rhs: bounds.minimum), maximum: Vector.maximum(lhs: maximum, rhs: bounds.maximum))
    }
    
    func intersection(bounds: Bounds) -> Bounds {
        
        return Bounds(minimum: Vector.maximum(lhs: minimum, rhs: bounds.minimum), maximum: Vector.minimum(lhs: maximum, rhs: bounds.maximum))
    }
    
    func intersects(bounds: Bounds) -> Bool {
        
        return !(bounds.maximum.x + Math.epsilon < minimum.x || bounds.minimum.x > maximum.x + Math.epsilon || bounds.maximum.y + Math.epsilon < minimum.y || bounds.minimum.y > maximum.y + Math.epsilon || bounds.maximum.z + Math.epsilon < minimum.z || bounds.minimum.z > maximum.z + Math.epsilon)
    }
    
    func contains(vector: Vector) -> Bool {
        
        return vector.x >= minimum.x && vector.x <= maximum.x && vector.y >= minimum.y && vector.y <= maximum.y && vector.z >= minimum.z && vector.z <= maximum.z
    }
}

extension Bounds {
    
    typealias Intersection = (intersecting: (lhs: [Polygon], rhs: [Polygon]), remainder: (lhs: [Polygon], rhs: [Polygon]))
    
    func intersect(lhs: [Polygon], rhs: [Polygon]) -> Intersection {
     
        var p0 = lhs
        var p1 = rhs
        var p2: [Polygon] = []
        var p3: [Polygon] = []
        
        for (i, polygon) in lhs.enumerated().reversed() {
            
            if !polygon.bounds.intersects(bounds: self) {                                                         
                
                p2.append(polygon)
                p0.remove(at: i)
            }
        }
        
        for (i, polygon) in rhs.enumerated().reversed() {
            
            if !polygon.bounds.intersects(bounds: self) {
                
                p3.append(polygon)
                p1.remove(at: i)
            }
        }
        
        return ((p0, p1), (p2, p3))
    }
}

extension Bounds {
    
    func compare(with plane: Plane) -> Plane.Comparison {
     
        var comparitor = Plane.Comparison.coplanar
        
        for vector in corners {
            
            comparitor = comparitor.union(comparitor: vector.compare(with: plane))
            
            if comparitor == .spanning {
                
                break
            }
        }
        
        return comparitor
    }
}
