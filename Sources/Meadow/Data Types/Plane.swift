//
//  Plane.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public struct Plane: Comparable, Hashable {
    
    let normal: Vector
    let distance: Double
    
    init(normal: Vector, distance: Double) {
        
        self.normal = normal.isNormalised ? normal : normal.normalised()
        self.distance = distance
    }
    
    init(vectors: [Vector]) {
        
        var normal = vectors.normal()
        
        if vectors.count > 3, !vectors.degenerate() {
            
            if !vectors.convex() {
                
                let plane = Plane.Flattening(bounds: Bounds(vectors: vectors))
                
                let vertices = vectors.map { plane.flatten(vector: $0) }
                
                let faceNormal = vertices.normal()
                
                if (faceNormal.z > 0) == vertices.clockwise() {
                    
                    normal = -normal
                }
            }
        }
        
        self.init(normal: normal, distance: normal.dot(vector: vectors.first!))
    }
}

extension Plane {
    
    static let xy = Plane(normal: Vector(x: 0, y: 0, z: 1), distance: 0)
    static let xz = Plane(normal: Vector(x: 0, y: 1, z: 0), distance: 0)
    static let yz = Plane(normal: Vector(x: 1, y: 0, z: 0), distance: 0)
}

extension Plane {
    
    public static func < (lhs: Plane, rhs: Plane) -> Bool {
     
        return lhs.compare(with: rhs) == .front
    }
    
    public static func <= (lhs: Plane, rhs: Plane) -> Bool {
     
        return lhs.compare(with: rhs) == Plane.Comparison.front.union(comparitor: .spanning)
    }
    
    public static func > (lhs: Plane, rhs: Plane) -> Bool {
     
        return lhs.compare(with: rhs) == .back
    }
    
    public static func >= (lhs: Plane, rhs: Plane) -> Bool {
     
        return lhs.compare(with: rhs) == Plane.Comparison.back.union(comparitor: .spanning)
    }
    
    public static func == (lhs: Plane, rhs: Plane) -> Bool {
        
        return abs(lhs.distance - rhs.distance) < Math.epsilon && lhs.normal == rhs.normal
    }
}

extension Plane {
    
    func inverted() -> Plane {
        
        return Plane(normal: -normal, distance: distance)
    }
    
    func contains(vector: Vector) -> Bool {
        
        return abs(vector.distance(from: self)) < Math.epsilon
    }
    
    func compare(with other: Plane) -> Plane.Comparison {
            
        guard self != other else { return .coplanar }
        
        return Plane.Comparison.coplanar.union(comparitor: (normal * distance).compare(with: other))
    }
}

extension Plane {
    
    enum Comparison: Int {
        
        case back = 2
        case coplanar = 0
        case front = 1
        case spanning = 3
        
        func union(comparitor: Comparison) -> Comparison {
            
            return Comparison(rawValue: rawValue | comparitor.rawValue)!
        }
    }
    
    enum Flattening: RawRepresentable {
        
        case xy
        case xz
        case yz
        
        var rawValue: Plane {
            
            switch self {
            
            case .xy: return .xy
            case .xz: return .xz
            case .yz: return .yz
            }
        }
        
        init?(rawValue: Plane) {
            
            switch rawValue {
                
            case .xy: self = .xy
            case .xz: self = .xz
            case .yz: self = .yz
            default: return nil
            }
        }
        
        init(bounds: Bounds) {
            
            let size = bounds.size
            
            if size.x > size.y {
                
                self = size.z > size.y ? .xz : .xy
            }
            else {
                
                self = size.z > size.x ? .yz : .xy
            }
        }
        
        func flatten(vector: Vector) -> Vector {
            
            switch self {
                
            case .xy: return Vector(x: vector.x, y: vector.y, z: 0)
            case .xz: return Vector(x: vector.x, y: vector.z, z: 0)
            case .yz: return Vector(x: vector.y, y: vector.z, z: 0)
            }
        }
    }
}
