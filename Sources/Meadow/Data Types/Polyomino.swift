//
//  Polyomino.swift
//
//  Created by Zack Brown on 03/10/2021.
//

public enum Polyomino: String, Codable, CaseIterable, Identifiable {
    
    case f
    case i
    case l
    case n
    case o
    case p
    case t
    case u
    case v
    case w
    case x
    case y
    case z
    
    case box
    case dot
    
    public var id: String { rawValue }
    
    public var footprint: Footprint {
            
        switch self {
            
        case .f: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .i: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .l: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 1, y: 0, z: 1)])
            
        case .n: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: 1)])
            
        case .o: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: 1),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 1, y: 0, z: 1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1)])
            
        case .p: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .t: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0)])
            
        case .u: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 1, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0)])
            
        case .v: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -2),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 2, y: 0, z: 0)])
            
        case .w: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 1)])
            
        case .x: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1)])
            
        case .y: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: -1, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 0, y: 0, z: 2)])
            
        case .z: return Footprint(coordinate: .zero, nodes: [Coordinate(x: -1, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: -1),
                                                             Coordinate(x: 0, y: 0, z: 0),
                                                             Coordinate(x: 0, y: 0, z: 1),
                                                             Coordinate(x: 1, y: 0, z: 1)])
            
        case .box: return Footprint(coordinate: .zero, nodes: [Coordinate(x: 0, y: 0, z: 0),
                                                               Coordinate(x: 1, y: 0, z: 0),
                                                               Coordinate(x: 0, y: 0, z: 1),
                                                               Coordinate(x: 1, y: 0, z: 1)])
            
        case .dot: return Footprint(coordinate: .zero, nodes: [.zero])
        }
    }
}
