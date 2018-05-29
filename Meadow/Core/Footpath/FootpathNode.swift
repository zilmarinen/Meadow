//
//  FootpathNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class FootpathNodeJSON
 @abstract
 */
public class FootpathNodeJSON: GridNodeJSON {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case footpathType
        case slope
    }
    
    /*!
     @property footpathType
     @abstract The FootpathType used to paint the FootpathNode with the appropriate ColorPalette.
     */
    public var footpathType: String?
    
    /*!
     @property slope
     @abstract The edge from which the FootpathNode slopes upwards.
     */
    public var slope: GridEdge?
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footpathType = try container.decodeIfPresent(String.self, forKey: .footpathType)
        
        slope = try container.decodeIfPresent(GridEdge.self, forKey: .slope)
    }
}

/*!
 @class FootpathNode
 @abstract FootpathNodes are used to define regions within a Grid which can be traversed.
 */
public class FootpathNode: GridNode {
    
    /*!
     @property neighbours
     @abstract An array of neighbouring grid nodes.
     */
    private var neighbours: Set<GridNodeNeighbour> = []
    
    /*!
     @property footpathType
     @abstract The FootpathType used to paint the FootpathNode with the appropriate ColorPalette.
     */
    public var footpathType: FootpathType? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property slope
     @abstract The edge from which the FootpathNode slopes upwards.
     */
    public var slope: GridEdge? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case footpathType
        case slope
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    override public func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(footpathType?.name, forKey: .footpathType)
        try container.encodeIfPresent(slope, forKey: .slope)
    }
}

extension FootpathNode {
    
    /*!
     @property FixedHeight
     @abstract Returns the fixed height value for a FootpathNode Volume.
     */
    static var FixedHeight: Int = 6
    
    /*!
     @method FixedVolume:coordinate
     @abstract Clamp and return a fixed volume for a given coordinate.
     @discussion This method will return a volume with a fixed height defined by the given coordinate y + `FootpathNode.FixedHeight` as well as a fixed width and depth defined by `World.TileSize`.
     */
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let coordinate = Coordinate(x: coordinate.x, y: World.Floor, z: coordinate.z)
        let size = Size(width: World.TileSize, height: FixedHeight, depth: World.TileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension FootpathNode {
    
    /*!
     @method add:neighbour:edge
     @abstract Attempt to create a relationship between two nodes along the specified edge.
     @param neighbour The node to become neighbours with.
     @param edge The edge shared between the two nodes.
     */
    func add(neighbour node: FootpathNode, edge: GridEdge) {
        
        guard node.volume.coordinate.adjacency(to: volume.coordinate) == .adjacent else { return }
        
        remove(neighbour: edge)
        
        neighbours.insert(GridNodeNeighbour(edge: edge, node: node))
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if node.find(neighbour: oppositeEdge) == nil {
            
            node.add(neighbour: self, edge: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    /*!
     @method remove:neighbour:edge
     @abstract Attempt to remove the relationship between two nodes along the specified edge.
     @param edge The edge shared between the two nodes.
     */
    func remove(neighbour edge: GridEdge) {
        
        guard let neighbour = find(neighbour: edge) else { return }
        
        neighbours.remove(neighbour)
        
        guard let neighbouringNode = neighbour.node as? FootpathNode else { return }
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        if let _ = neighbouringNode.find(neighbour: oppositeEdge) {
            
            neighbouringNode.remove(neighbour: oppositeEdge)
        }
        
        becomeDirty()
    }
    
    /*!
     @method find:neighbour
     @abstract Attempt to find and return the neighbouring node along the specified edge.
     @param edge The edge shared between the two nodes.
     */
    func find(neighbour edge: GridEdge) -> GridNodeNeighbour? {
        
        return neighbours.first { neighbour -> Bool in
            
            return neighbour.edge == edge
        }
    }
}
