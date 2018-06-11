//
//  FootpathNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

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
    public var slope: FootpathNodeSlope?
    
    /*!
     @method init:from
     @abstract Creates and initialises a node, decoded by the provided decoder.
     @param decoder The decoder to read data from.
     */
    public required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        footpathType = try container.decodeIfPresent(String.self, forKey: .footpathType)
        
        slope = try container.decodeIfPresent(FootpathNodeSlope.self, forKey: .slope)
    }
}

/*!
 @class FootpathNode
 @abstract FootpathNodes are used to define regions within a Grid which can be traversed.
 */
public class FootpathNode: GridNode {
    
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
    public var slope: FootpathNodeSlope? {
        
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
        let upperY = (volume.coordinate.y + volume.size.height - 2)
        
        var lowerCornerHeights = [ lowerY, lowerY, lowerY, lowerY ]
        var upperCornerHeights = [ upperY, upperY, upperY, upperY ]
        
        if let slope = slope {
            
            let corners = GridCorner.Corners(edge: slope.edge)
            
            let inclination = 1 + (slope.steepInclination ? 1 : 0)
            
            lowerCornerHeights[corners.first!.rawValue] += inclination
            lowerCornerHeights[corners.last!.rawValue] += inclination
            
            upperCornerHeights[corners.first!.rawValue] += inclination
            upperCornerHeights[corners.last!.rawValue] += inclination
        }
        
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
    
    /*!
     @method compactMesh
     @abstract Returns the compound mesh of the node.
     */
    override public func compactMesh() -> Mesh {
        
        var faces: [MeshFace] = []
        
        if let apexColor = footpathType?.colorPalette.primary.vector {
            
            let throne = SCNVector3(x: 0.0, y: FootpathNode.Throne, z: 0.0)
        
            let apexCenter = polyhedron.lowerPolytope.center
            
            let apexNormal = apexCenter + SCNVector3.Up
            
            let primaryColors = [ apexColor, apexColor, apexColor ]
            
            var insetVertices: [SCNVector3] = []
            
            let length = (FootpathNode.Furrow * 2.0)
            
            polyhedron.lowerPolytope.vertices.forEach { vertex in
                
                insetVertices.append(SCNVector3.Lerp(from: vertex, to: apexCenter, scalar: length) + throne)
            }
            
            let plane = Plane(v0: insetVertices[0], v1: insetVertices[1], v2: insetVertices[2])
            
            var normal = plane.normal
            
            if plane.side(vector: apexNormal) {
                
                normal = SCNVector3.Negate(vector: plane.normal)
            }
            
            let normals = [normal, normal, normal]
            
            faces.append(MeshFace(vertices: [insetVertices[0], insetVertices[2], insetVertices[1]], normals: normals, colors: primaryColors))
            faces.append(MeshFace(vertices: [insetVertices[0], insetVertices[3], insetVertices[2]], normals: normals, colors: primaryColors))
            
            GridEdge.Edges.forEach { edge in
             
                let corners = GridCorner.Corners(edge: edge)
                
                if let c0 = corners.first, let c1 = corners.last, let nodeNeighbour = find(neighbour: edge), let neighbour = nodeNeighbour.node as? FootpathNode {
                    
                    let v0 = polyhedron.lowerPolytope.vertices[c0.rawValue] + throne
                    let v1 = polyhedron.lowerPolytope.vertices[c1.rawValue] + throne
                    let v2 = insetVertices[c1.rawValue]
                    let v3 = insetVertices[c0.rawValue]
                    var v4 = v0
                    var v5 = v1
                    
                    let e0 = GridEdge.Edges(corner: c0).first { $0 != edge }!
                    let e1 = GridEdge.Edges(corner: c1).first { $0 != edge }!
                    
                    let a0 = find(neighbour: e0)?.node as? FootpathNode
                    let a1 = find(neighbour: e1)?.node as? FootpathNode
                    
                    let d0 = neighbour.find(neighbour: e0)?.node as? FootpathNode
                    let d1 = neighbour.find(neighbour: e1)?.node as? FootpathNode
                    
                    if a0 == nil || (a0 != nil && d0 == nil) {
                        
                        v4 = SCNVector3.Lerp(from: v0, to: v1, scalar: FootpathNode.Furrow)
                    }
                    
                    if a1 == nil || (a1 != nil && d1 == nil) {
                        
                        v5 = SCNVector3.Lerp(from: v1, to: v0, scalar: FootpathNode.Furrow)
                    }
                    
                    faces.append(MeshFace(vertices: [v4, v2, v5], normals: normals, colors: primaryColors))
                    faces.append(MeshFace(vertices: [v4, v3, v2], normals: normals, colors: primaryColors))
                }
            }
        }
        
        return Mesh(faces: faces)
    }
    
    /*!
     @method clean
     @abstract Enumerate through children and clean each layer.
     */
    override public func clean() -> Bool {
        
        if !super.clean() { return false }
        
        cachedPolyhedron = nil
        
        return true
    }
}

extension FootpathNode {
    
    /*!
     @property Furrow
     @abstract Defines the inset of the FootpathNode from the edge of the tile along the x and z axis.
     */
    static let Furrow: MDWFloat = 0.05
    
    /*!
     @property Throne
     @abstract Defines the inset of the FootpathNode from the base of the node along the y axis.
     */
    static let Throne: MDWFloat = 0.01
    
    /*!
     @property FixedHeight
     @abstract Returns the fixed height value for a FootpathNode Volume.
     */
    static let FixedHeight: Int = 6
    
    /*!
     @method FixedVolume:coordinate
     @abstract Clamp and return a fixed volume for a given coordinate.
     @discussion This method will return a volume with a fixed height defined by the given coordinate y + `FootpathNode.FixedHeight` as well as a fixed width and depth defined by `World.TileSize`.
     */
    static func FixedVolume(_ coordinate: Coordinate) -> Volume {
        
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
