//
//  Area.swift
//  
//  Created by Zack Brown on 08/12/2020.
//

import SceneKit

public class Area: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case chunks
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var chunks: [AreaChunk] = []
    
    public var children: [SceneGraphNode] { chunks }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.area.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Area"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        chunks = try container.decode([AreaChunk].self, forKey: .chunks)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for chunk in chunks {
            
            for tile in chunk.tiles {
                
                for cardinal in Cardinal.allCases {
                 
                    if let neighbour = find(tile: tile.coordinate + cardinal.coordinate) {
                        
                        tile.add(neighbour: neighbour, cardinal: cardinal)
                    }
                }
            }
            
            addChildNode(chunk)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(chunks, forKey: .chunks)
    }
}

extension Area {
    
    public typealias TileConfiguration = ((AreaTile) -> Void)
    
    public func add(tile coordinate: Coordinate, configure: TileConfiguration? = nil) -> AreaTile? {
        
        guard find(tile: coordinate) == nil else { return nil }
        
        let chunk = find(chunk: coordinate) ?? AreaChunk(coordinate: coordinate)
        
        guard let tile = chunk.add(tile: coordinate) else { return nil }
        
        if chunk.parent == nil {
            
            chunks.append(chunk)
            
            addChildNode(chunk)
        }
        
        for cardinal in Cardinal.allCases {
         
            if let neighbour = find(tile: coordinate + cardinal.coordinate) {
                
                tile.add(neighbour: neighbour, cardinal: cardinal)
            }
        }
        
        configure?(tile)
        
        becomeDirty()
        
        return tile
    }
    
    public func find(tile coordinate: Coordinate) -> AreaTile? {
        
        return find(chunk: coordinate)?.find(tile: coordinate)
    }
    
    public func remove(tile coordinate: Coordinate) {
        
        guard let chunk = find(chunk: coordinate) else { return }
        
        chunk.remove(tile: coordinate)
        
        guard chunk.tiles.isEmpty,
              let index = chunks.firstIndex(of: chunk) else { return }
        
        chunks.remove(at: index)
        
        chunk.removeFromParentNode()
        
        becomeDirty()
    }
    
    func find(chunk coordinate: Coordinate) -> AreaChunk? {
        
        return chunks.first { $0.contains(coordinate: coordinate) }
    }
}

extension Area {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for chunk in chunks {
            
            chunk.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Area {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for chunk in chunks {
            
            chunk.update(delta: delta, time: time)
        }
    }
}
