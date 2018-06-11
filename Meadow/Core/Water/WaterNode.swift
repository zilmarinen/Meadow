//
//  WaterNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class WaterNodeJSON
 @abstract
 */
public class WaterNodeJSON: GridNodeJSON {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case waterType
        case waterLevel
    }
    
    /*!
     @property waterType
     @abstract The WaterType used to paint the WaterNode with the appropriate ColorPalette.
     */
    var waterType: String = ""
    
    /*!
     @property waterLevel
     @abstract The y axis value of the water level.
     */
    var waterLevel: Int = World.Floor
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        waterType = try container.decode(String.self, forKey: .waterType)
    }
}

/*!
 @class WaterNode
 @abstract WaterNode are used to define regions within a Grid are bodies of water.
 */
public class WaterNode: GridNode {
    
    /*!
     @property cachedPolyhedron
     @abstract Cached version of the Polyhedron calculated after being cleaned.
     */
    private var cachedPolyhedron: Polyhedron?
    
    /*!
     @property neighbours
     @abstract An array of neighbouring grid nodes.
     */
    private var neighbours: Set<GridNodeNeighbour> = []
    
    /*!
     @property waterType
     @abstract The WaterType used to paint the WaterNode with the appropriate ColorPalette.
     */
    public var waterType: WaterType? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property waterLevel
     @abstract The y axis value of the water level.
     */
    public var waterLevel: Int = World.Floor {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property polyhedron
     @abstract Returns a Polyhedron calculated from the edge slope and inclination.
     */
    var polyhedron: Polyhedron {
        
        if let cachedPolyhedron = cachedPolyhedron {
            
            return cachedPolyhedron
        }
        
        let lowerY = volume.coordinate.y
        
        let lowerCornerHeights = [ lowerY, lowerY, lowerY, lowerY ]
        let upperCornerHeights = [ waterLevel, waterLevel, waterLevel, waterLevel ]
        
        let upperPolytope = Polytope(x: MDWFloat(volume.coordinate.x), y: upperCornerHeights, z: MDWFloat(volume.coordinate.z))
        let lowerPolytope = Polytope(x: MDWFloat(volume.coordinate.x), y: lowerCornerHeights, z: MDWFloat(volume.coordinate.z))
        
        cachedPolyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
        
        return cachedPolyhedron!
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case waterType
        case waterLevel
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    override public func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(waterType?.name, forKey: .waterType)
        try container.encode(waterLevel, forKey: .waterLevel)
    }
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the node.
     */
    override public func compactMesh() -> Mesh {
        
        var faces: [MeshFace] = []
        
        if let apexColor = waterType?.colorPalette.primary.vector, let edgeColor = waterType?.colorPalette.primary.vector {
            
            let apexCenter = polyhedron.lowerPolytope.center
            
            let apexNormal = apexCenter + SCNVector3.Up
            
            let apexNormals = [apexNormal, apexNormal, apexNormal]
            
            let primaryColors = [ apexColor, apexColor, apexColor ]
            let secondaryColors = [ edgeColor, edgeColor, edgeColor ]
            
            GridEdge.Edges.forEach { edge in
                
                let corners = GridCorner.Corners(edge: edge)
                
                let edgeNormal = GridEdge.Normal(edge: edge)
                
                let edgeNormals = [edgeNormal, edgeNormal, edgeNormal]
                
                if let c0 = corners.first, let c1 = corners.last {
                
                    let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
                    let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
                    let v2 = polyhedron.upperPolytope.vertices[c1.rawValue]
                    let v3 = polyhedron.upperPolytope.vertices[c0.rawValue]
                    
                    faces.append(MeshFace(vertices: [v1, v0, apexCenter], normals: apexNormals, colors: primaryColors))
                    
                    if find(neighbour: edge) == nil {
                    
                        faces.append(MeshFace(vertices: [v0, v2, v1], normals: edgeNormals, colors: secondaryColors))
                        faces.append(MeshFace(vertices: [v0, v3, v2], normals: edgeNormals, colors: secondaryColors))
                    }
                }
            }
        }
        
        return Mesh(faces: faces)
    }
}

extension WaterNode {
    
    /*!
     @method add:neighbour:edge
     @abstract Attempt to create a relationship between two nodes along the specified edge.
     @param neighbour The node to become neighbours with.
     @param edge The edge shared between the two nodes.
     */
    func add(neighbour node: WaterNode, edge: GridEdge) {
        
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
        
        guard let neighbouringNode = neighbour.node as? WaterNode else { return }
        
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
