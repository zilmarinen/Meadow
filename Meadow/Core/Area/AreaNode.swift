//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @class AreaNodeJSON
 @abstract
 */
public class AreaNodeJSON: GridNodeJSON {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case surfaceType
        case perimeterEdges
        case externalPrefabType
        case internalPrefabType
        case externalMaterialType
        case internalMaterialType
    }
    
    /*!
     @property perimeterEdges
     @abstract An array of the stored AreaPerimeterEdge for each edge.
     */
    var perimeterEdges: [AreaPerimeterEdge]?
    
    /*!
     @property surfaceType
     @abstract The AreaSurfaceType used to paint the AreaNode with the appropriate ColorPalette.
     */
    var surfaceType: String?
    
    /*!
     @property externalPrefabType
     @abstract Defines the AreaPrefabType that should be used to draw the external edges of the AreaNode.
     */
    var externalPrefabType: AreaPrefabType?
    
    /*!
     @property internalPrefabType
     @abstract Defines the AreaPrefabType that should be used to draw the internal edges of the AreaNode.
     */
    var internalPrefabType: AreaPrefabType?
    
    /*!
     @property externalMaterialType
     @abstract Defines the AreaMaterialType that should be used to paint the external edges of the AreaNode.
     */
    var externalMaterialType: AreaMaterialType?
    
    /*!
     @property internalMaterialType
     @abstract Defines the AreaMaterialType that should be used to paint the internal edges of the AreaNode.
     */
    var internalMaterialType: AreaMaterialType?
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        surfaceType = try container.decodeIfPresent(String.self, forKey: .surfaceType)
        
        perimeterEdges = try container.decodeIfPresent([AreaPerimeterEdge].self, forKey: .perimeterEdges)
        
        externalPrefabType = try container.decodeIfPresent(AreaPrefabType.self, forKey: .externalPrefabType)
        internalPrefabType = try container.decodeIfPresent(AreaPrefabType.self, forKey: .internalPrefabType)
        
        externalMaterialType = try container.decodeIfPresent(AreaMaterialType.self, forKey: .externalMaterialType)
        internalMaterialType = try container.decodeIfPresent(AreaMaterialType.self, forKey: .internalMaterialType)
    }
}

/*!
 @class AreaNode
 @abstract AreaNodes are used to define regions within a Grid which can be traversed.
 */
public class AreaNode: GridNode {
    
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
     @property perimeterEdges
     @abstract An array of the stored AreaPerimeterEdge for each edge.
     */
    private var perimeterEdges: Set<AreaPerimeterEdge> = []
    
    /*!
     @property surfaceType
     @abstract The AreaSurfaceType used to paint the AreaNode with the appropriate ColorPalette.
     */
    public var surfaceType: AreaSurfaceType? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property externalPrefabType
     @abstract Defines the AreaPrefabType that should be used to draw the external edges of the AreaNode.
     */
    public var externalPrefabType: AreaPrefabType = .concrete {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property internalPrefabType
     @abstract Defines the AreaPrefabType that should be used to draw the internal edges of the AreaNode.
     */
    public var internalPrefabType: AreaPrefabType = .concrete {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property externalMaterialType
     @abstract Defines the AreaMaterialType that should be used to paint the external edges of the AreaNode.
     */
    public var externalMaterialType: AreaMaterialType? {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property internalMaterialType
     @abstract Defines the AreaMaterialType that should be used to paint the internal edges of the AreaNode.
     */
    public var internalMaterialType: AreaMaterialType? {
        
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
        let upperY = (volume.coordinate.y + volume.size.height)
        
        let lowerCornerHeights = [ lowerY, lowerY, lowerY, lowerY ]
        let upperCornerHeights = [ upperY, upperY, upperY, upperY ]
        
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
        
        case surfaceType
        case perimeterEdges
        case externalPrefabType
        case internalPrefabType
        case externalMaterialType
        case internalMaterialType
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    override public func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(perimeterEdges, forKey: .perimeterEdges)
        try container.encodeIfPresent(surfaceType?.name, forKey: .surfaceType)
        try container.encodeIfPresent(externalPrefabType, forKey: .externalPrefabType)
        try container.encodeIfPresent(internalPrefabType, forKey: .internalPrefabType)
        try container.encodeIfPresent(externalMaterialType, forKey: .externalMaterialType)
        try container.encodeIfPresent(internalMaterialType, forKey: .internalMaterialType)
    }
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the node.
     */
    override public func compactMesh() -> Mesh {
        
        var meshes: [Mesh] = []
        var faces: [MeshFace] = []
        
        if let apexColor = surfaceType?.colorPalette.primary.vector {
            
            let throne = SCNVector3(x: 0.0, y: FootpathNode.Throne, z: 0.0)
            
            let primaryColors = [ apexColor, apexColor, apexColor ]
            
            GridEdge.Edges.forEach { edge in
                
                let corners = GridCorner.Corners(edge: edge)
                
                let apexCenter = polyhedron.lowerPolytope.center + throne
                
                let apexNormal = apexCenter + SCNVector3.Up
                
                let v0 = polyhedron.lowerPolytope.vertices[corners.first!.rawValue] + throne
                let v1 = polyhedron.lowerPolytope.vertices[corners.last!.rawValue] + throne
                
                let plane = Plane(v0: v0, v1: v1, v2: apexCenter)
                
                var normal = plane.normal
                
                if plane.side(vector: apexNormal) {
                    
                    normal = SCNVector3.Negate(vector: plane.normal)
                }
                
                faces.append(MeshFace(vertices: [v1, v0, apexCenter], normals: [normal, normal, normal], colors: primaryColors))
                
                if let perimeterEdge = get(perimeterEdge: edge) {
                    
                    let externalMesh = externalPrefabType.mesh(polyhedron: polyhedron, perimeterEdge: perimeterEdge, colorPalette: surfaceType!.colorPalette)
                    let internalMesh = internalPrefabType.mesh(polyhedron: polyhedron, perimeterEdge: perimeterEdge, colorPalette: surfaceType!.colorPalette)
                    
                    meshes.append(externalMesh)
                    meshes.append(internalMesh)
                }
            }
            
            meshes.append(Mesh(faces: faces))
        }
        
        return Mesh(meshes: meshes)
    }
}

extension AreaNode {
    
    /*!
     @property Throne
     @abstract Defines the inset of the AreaNode from the base of the node along the y axis.
     */
    static let Throne: MDWFloat = 0.01
    
    /*!
     @property FixedHeight
     @abstract Returns the fixed height value for a AreaNode Volume.
     */
    static let FixedHeight: Int = 6
    
    /*!
     @method FixedVolume:coordinate
     @abstract Clamp and return a fixed volume for a given coordinate.
     @discussion This method will return a volume with a fixed height defined by the given coordinate y + `AreaNode.FixedHeight` as well as a fixed width and depth defined by `World.TileSize`.
     */
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.TileSize, height: FixedHeight, depth: World.TileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension AreaNode {
    
    /*!
     @method add:neighbour:edge
     @abstract Attempt to create a relationship between two nodes along the specified edge.
     @param neighbour The node to become neighbours with.
     @param edge The edge shared between the two nodes.
     */
    func add(neighbour node: AreaNode, edge: GridEdge) {
        
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
        
        guard let neighbouringNode = neighbour.node as? AreaNode else { return }
        
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

extension AreaNode {
    
    /*!
     @method set:perimeterType:edge
     @abstract Set the AreaPerimeterType for the given edge.
     @param terrainType The AreaPerimeterType to set for the given edge.
     @param edge The edge to set for the given AreaPerimeterType.
     */
    public func set(perimeterType: AreaPerimeterType, edge: GridEdge) {
        
        if let existingType = get(perimeterEdge: edge) {
            
            perimeterEdges.remove(existingType)
        }
        
        perimeterEdges.insert(AreaPerimeterEdge(edge: edge, perimeterType: perimeterType))
        
        becomeDirty()
    }
    
    /*!
     @method get:perimeterEdge
     @abstract Returns the AreaPerimeterEdge of the given edge.
     @param edge The edge to search and return the AreaPerimeterEdge for.
     */
    public func get(perimeterEdge edge: GridEdge) -> AreaPerimeterEdge? {
        
        return perimeterEdges.first { perimeterEdge -> Bool in
            
            return perimeterEdge.edge == edge
        }
    }
}
