//
//  TerrainNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class TerrainNodeJSON
 @abstract
 */
public class TerrainNodeJSON: GridNodeJSON {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case layers
    }
    
    /*!
     @property layers
     @abstract Holds instances of TerrainLayers added to the node.
     */
    var layers: [TerrainLayerJSON] = []
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        layers = try container.decode([TerrainLayerJSON].self, forKey: .layers)
    }
}

/*!
 @class TerrainNode
 @abstract TerrainNodes are used to define regions within a Grid upon which TerrainLayers can be added.
 */
public class TerrainNode: GridNode {
    
    /*!
     @property neighbours
     @abstract An array of neighbouring grid nodes.
     */
    private var neighbours: Set<GridNodeNeighbour> = []
    
    /*!
     @property layers
     @abstract Holds instances of TerrainLayers added to the node.
     */
    private var layers: [TerrainLayer] = []
    
    /*!
     @property cutaways
     @abstract An array of cutaways within the layers of the node.
     */
    private var cutaways: [Polyhedron] = []
    
    /*!
     @property topLayer
     @abstract Returns the upper most TerrainLayer with the highest elevation.
     */
    public var topLayer: TerrainLayer? {
        
        return layers.max(by: { (lhs, rhs) -> Bool in
            
            return lhs.polyhedron.upperPolytope.peak < rhs.polyhedron.upperPolytope.peak
        })
    }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    override public var totalChildren: Int { return layers.count }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    override public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? {
        
        return layers[index]
    }
    
    /*!
     @method sceneGraph:indexOf
     @abstract Attempt to find and return the index of the specified child.
     @param child The child for which the index should be found and returned.
     */
    override public func sceneGraph(indexOf child: SceneGraphNode) -> Int? {
        
        guard let child = child as? TerrainLayer else { return nil }
        
        return layers.index(of: child)
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case layers
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    override public func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(layers, forKey: .layers)
    }
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the node.
     */
    override func compactMesh() -> Mesh {
        
        let meshes = layers.compactMap { $0.mesh(cutaways: cutaways) }
        
        return Mesh(meshes: meshes)
    }
}

extension TerrainNode {
    
    /*!
     @method add:neighbour:edge
     @abstract Attempt to create a relationship between two nodes along the specified edge.
     @param neighbour The node to become neighbours with.
     @param edge The edge shared between the two nodes.
     */
    func add(neighbour node: TerrainNode, edge: GridEdge) {
        
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
        
        guard let neighbouringNode = neighbour.node as? TerrainNode else { return }
        
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

extension TerrainNode {
    
    /*!
     @method add:layer
     @abstract Attempt to create and return a new layer with the specified terrain type.
     @param terrainType The terrain type for the layer.
     */
    public func add(layer terrainType: TerrainType) -> TerrainLayer? {
        
        if let topLayer = topLayer {
            
            if World.Y(y: topLayer.polyhedron.upperPolytope.base) == World.Ceiling {
                
                return nil
            }
        }
        
        let layer = TerrainLayer(node: self, terrainType: terrainType)
        
        let currentTopLayer = topLayer
        
        layer.hierarchy.lower = currentTopLayer
        
        layers.append(layer)
        
        currentTopLayer?.hierarchy.upper = layer
        
        let height = (layer.hierarchy.lower != nil ? World.Y(y: layer.hierarchy.lower!.polyhedron.upperPolytope.peak) : World.Floor) + 1
        
        GridCorner.Corners.forEach { corner in
            
            layer.set(height: height, corner: corner)
        }
        
        becomeDirty()
        
        return layer
    }
    
    /*!
     @method remove:layer
     @abstract Attempt to find and remove the specified layer.
     @param layer The layer to be found and removed.
     */
    public func remove(layer: TerrainLayer) {
        
        guard let index = layers.index(of: layer) else { return }
            
        layers.remove(at: index)
        
        if let upper = layer.hierarchy.upper {
            
            upper.hierarchy.lower = layer.hierarchy.lower
        }
        
        if let lower = layer.hierarchy.lower {
            
            lower.hierarchy.upper = layer.hierarchy.upper
        }
        
        layer.hierarchy.upper = nil
        layer.hierarchy.lower = nil
        
        becomeDirty()
    }
}

extension TerrainNode {
    
    /*!
     @method add:cutaway
     @abstract Attempt to add a cutaway with the specified Polyhedron.
     @param polyhedron The Polyhedron the cutaway occupies.
     */
    func add(cutaway polyhedron: Polyhedron) {
        
        guard find(cutaways: polyhedron)?.count == 0 else { return }
        
        cutaways.append(polyhedron)
    }
    
    /*!
     @method remove:cutaway
     @abstract Attempt to find and remove the cutaway with the specified Polyhedron.
     @param polyhedron The Polyhedron the to find and remove.
     */
    func remove(cutaway polyhedron: Polyhedron) {
        
        guard let index = cutaways.index(of: polyhedron) else { return }
            
        cutaways.remove(at: index)
            
        becomeDirty()
    }
    
    /*!
     @method find:cutaways
     @abstract Attempt to find and return any cutaways that intersect with the specified Polyhedron.
     @param polyhedron The Polyhedron to check for intersections against.
     */
    func find(cutaways polyhedron: Polyhedron) -> [Polyhedron]? {
        
        return cutaways.filter { cutaway -> Bool in
            
            let elevation = cutaway.elevation(referencing: polyhedron)
            
            return elevation == .equal || elevation == .intersecting
        }
    }
}
