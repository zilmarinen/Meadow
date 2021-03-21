//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class SurfaceTile: Codable, Equatable, Renderable, Responder {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tileType
        case edgeType
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    let coordinate: Coordinate
    let tileType: SurfaceTileType
    let edgeType: SurfaceEdgeType
    
    var neighbours: [Cardinal : SurfaceTile] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        edgeType = try container.decode(SurfaceEdgeType.self, forKey: .edgeType)
        
        becomeDirty()
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tileType, forKey: .tileType)
        try container.encode(edgeType, forKey: .edgeType)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
    
    func render(position: Vector) -> [Polygon] {
        
        var vectors = Ordinal.corners.map { $0 + position }
        
        var cornerElevation = Array(repeating: coordinate.y, count: 4)
        
        for ordinal in Ordinal.allCases {
            
            let (c0, c1) = ordinal.cardinals
            
            let n0 = find(neighbour: c0)?.coordinate.y ?? coordinate.y
            let n1 = find(neighbour: c1)?.coordinate.y ?? coordinate.y
            let n2 = find(neighbour: ordinal)?.coordinate.y ?? coordinate.y
            
            let height = min(n0, n1, n2, coordinate.y)
            
            vectors[ordinal.rawValue].y = Double(height) * World.Constants.slope
            
            cornerElevation[ordinal.rawValue] = height
        }
        
        let normal = vectors.normal()
        
        var vertices: [Vertex] = []
        
        for index in 0..<vectors.count {
            
            let vector = vectors[index]
            let uvs = Ordinal.uvs[index]
          
            vertices.append(Vertex(position: vector, normal: normal, color: .green, textureCoordinates: uvs))
        }
        
        return [Polygon(vertices: vertices)]
    }
}

extension SurfaceTile {
    
    public static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}

extension SurfaceTile {
    
    func add(neighbour: SurfaceTile, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> SurfaceTile? {
        
        return neighbours[cardinal]
    }
    
    func find(neighbour ordinal: Ordinal) -> SurfaceTile? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours[cardinal] else { return }
        
        neighbours.removeValue(forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}
