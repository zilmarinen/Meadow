//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct TerrainLayerJSON
 @abstract
 */
public struct TerrainLayerJSON: Decodable {
    
    /*!
     @property corners
     @abstract Defines the world height values of the layer corners.
     */
    let corners: [Int]
    
    /*!
     @property terrainTypes
     @abstract Holds the terrain types for each edge.
     */
    let terrainTypes: [TerrainLayerEdgeJSON]
}

/*!
 @struct TerrainLayerEdgeJSON
 @abstract
 */
public struct TerrainLayerEdgeJSON: Decodable {
    
    /*!
     @property edge
     @abstract The edge of the layer to be painted.
     */
    public let edge: GridEdge
    
    /*!
     @property terrainType
     @abstract The TerrainType used to paint the edge of the layer.
     */
    public let terrainType: String
}

/*!
 @struct TerrainLayerEdge
 @abstract Defines a relationship between an edge and a TerrainType.
 */
public struct TerrainLayerEdge: Hashable, Encodable {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case edge
        case terrainType
    }
    
    /*!
     @property edge
     @abstract The edge of the layer to be painted.
     */
    public let edge: GridEdge
    
    /*!
     @property terrainType
     @abstract The TerrainType used to paint the edge of the layer.
     */
    public let terrainType: TerrainType
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(edge, forKey: .edge)
        try container.encode(terrainType.name, forKey: .terrainType)
    }
}

/*!
 @struct TerrainLayerHierarchy
 @abstract Defines the relationship between upper and lower nodes when stacked.
 */
public struct TerrainLayerHierarchy {
    
    /*!
     @property upper
     @abstract The layer directly above the layer.
     */
    var upper: TerrainLayer?
    
    /*!
     @property lower
     @abstract The layer directly below the layer.
     */
    var lower: TerrainLayer?
}

/*!
 @class TerrainLayer
 @abstract TerrainLayers define an area of space within a TerrainNode represented as a Polyhedron.
 */
public class TerrainLayer: Encodable {
    
    /*!
     @property isDirty
     @abstract Represents staleness of the layer.
     */
    private var isDirty: Bool = true
    
    /*!
     @property corners
     @abstract Defines the world height values of the layer corners.
     */
    private var corners: [Int]
    
    /*!
     @property terrainTypes
     @abstract Holds the terrain types for each edge.
     */
    private var terrainTypes: Set<TerrainLayerEdge> = []
    
    /*!
     @property cachedPolyhedron
     @abstract Cached version of the Polyhedron calculated after becoming dirty.
     */
    private var cachedPolyhedron: Polyhedron?
    
    /*!
     @property node
     @param node The parent node for the layer.
     */
    public unowned let node: TerrainNode
    
    /*!
     @property isHidden
     @abstract Determines whether the layer is displayed
     */
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    /*!
     @property hierarchy
     @abstract Defines the relationship between upper and lower nodes when stacked.
     */
    var hierarchy: TerrainLayerHierarchy
    
    /*!
     @property upper
     @abstract The layer directly above the layer.
     */
    public var upper: TerrainLayer? { return hierarchy.upper }
    
    /*!
     @property lower
     @abstract The layer directly below the layer.
     */
    public var lower: TerrainLayer? { return hierarchy.lower }
    
    /*!
     @property polyhedron
     @abstract Returns a Polyhedron calculated from the world corner heights in relation to any upper and/or lower layers.
     */
    var polyhedron: Polyhedron {
        
        if !isDirty, let cachedPolyhedron = cachedPolyhedron {
            
            return cachedPolyhedron
        }
        
        let unit = Polytope.Unit
        
        var vertices: [SCNVector3] = []
        
        for index in 0..<corners.count {
            
            vertices.append(SCNVector3(x: SCNFloat(node.volume.coordinate.x) + unit.vertices[index].x, y: World.Y(y: corners[index]), z: SCNFloat(node.volume.coordinate.z) + unit.vertices[index].z))
        }
        
        let upperPolytope = Polytope(vertices: vertices)
        
        var lowerPolytope: Polytope
        
        if let lower = lower {
            
            lowerPolytope = lower.polyhedron.upperPolytope
        }
        else {
            
            lowerPolytope = Polytope(x: SCNFloat(node.volume.coordinate.x), y: World.Y(y: node.volume.coordinate.y), z: SCNFloat(node.volume.coordinate.z))
        }
        
        cachedPolyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
        
        return cachedPolyhedron!
    }
    
    /*!
     @method init:node:terrainType
     @abstract Creates and initialises a layer with the specified node and terrain type.
     @param node The parent node for the layer.
     @param terrainType The terrain type used to paint the layer.
     */
    
    init(node: TerrainNode, terrainType: TerrainType) {
        
        self.node = node
        
        self.corners = [0, 0, 0, 0]
        
        self.hierarchy = TerrainLayerHierarchy(upper: nil, lower: nil)
        
        set(terrainType: terrainType)
    }
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case corners
        case terrainTypes
    }
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(corners, forKey: .corners)
        try container.encode(terrainTypes, forKey: .terrainTypes)
    }
}

extension TerrainLayer: Equatable {
    
    /*!
     @method ==
     @abstract Determine the equality of two TerrainLayers.
     */
    public static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.node == rhs.node && lhs.polyhedron == rhs.polyhedron
    }
}

extension TerrainLayer {
    
    /*!
     @property Ceiling
     @abstract The highest y axis value allowed.
     */
    public static var Crown: MDWFloat = (World.UnitY / 2.0)
}

extension TerrainLayer: Soilable {
    
    /*!
     @method becomeDirty
     @abstract If not already true, toggle the isDirty flag to true.
     */
    public func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        node.becomeDirty()
    }
    
    /*!
     @method clean
     @abstract Enumerate through children and clean.
     */
    public func clean() -> Bool {
        
        if !isDirty { return false }
        
        isDirty = false
        
        return true
    }
}

extension TerrainLayer {
    
    /*!
     @method set:height:corner:smooth
     @abstract Clamp and set the height of the specified corner to be both within the world bounds and relative to any upper and/or lower nodes.
     @discussion Setting the height of a corner will also constrain any connected corner heights for the layer. Smooth adjustments to neighbouring nodes can also be propagated by setting the `smooth` parameter to `true`.
     @param height The world height of the corner.
     @param corner The corner for which the height should be set.
     @param smooth Determines whether neighbouring nodes should be updated of changes in height.
     */
    public func set(height: Int, corner: GridCorner, smooth: Bool = false) {
        
        var value = min(max(height, World.Floor + 1), World.Ceiling)
        
        if let upper = upper {
            
            value = min(value, upper.get(height: corner))
        }
        
        if let lower = lower {
            
            value = max(value, lower.get(height: corner))
        }
        
        if get(height: corner) != value {
         
            corners[corner.rawValue] = value
            
            becomeDirty()
            
            let connectedCorners = GridCorner.Corners(corner: corner)
            let oppositeCorner = GridCorner.Opposite(corner: corner)
            
            resolve(height: value, corner: connectedCorners[0], clamp: 1)
            resolve(height: value, corner: connectedCorners[1], clamp: 1)
            resolve(height: value, corner: oppositeCorner, clamp: 2)
            
            if smooth {
                
                let connectedEdges = GridEdge.Edges(corner: corner)
                
                let ce0 = connectedEdges[0]
                let ce1 = connectedEdges[1]
                
                let ac0 = GridCorner.Adjacent(corner: corner, edge: ce0)
                let ac1 = GridCorner.Adjacent(corner: corner, edge: ce1)
                
                let n0 = node.find(neighbour: ce0)?.node as? TerrainNode
                let n1 = node.find(neighbour: ce1)?.node as? TerrainNode
                let n2 = (n0 != nil ? n0!.find(neighbour: ce1) : (n1 != nil ? n1!.find(neighbour: ce0) : nil))?.node as? TerrainNode
                
                if let n0 = n0, let topLayer = n0.topLayer { topLayer.set(height: value, corner: ac0, smooth: smooth) }
                if let n1 = n1, let topLayer = n1.topLayer { topLayer.set(height: value, corner: ac1, smooth: smooth) }
                if let n2 = n2, let topLayer = n2.topLayer { topLayer.set(height: value, corner: oppositeCorner, smooth: smooth) }
            }
        }
    }
    
    /*!
     @method resolve:height:corner:clamp
     @abstract Resolve the height of a corner within the degree of tolerance defined by `clamp`.
     @param height The world height of the corner.
     @param corner The corner for which the height should be set.
     @param clamp Defines a level of tolerance for constraining differences in height.
     */
    func resolve(height: Int, corner: GridCorner, clamp: Int) {
     
        let delta = get(height: corner) - height
        
        if abs(delta) > clamp {
            
            corners[corner.rawValue] = height + (delta <= -clamp ? -clamp : (delta >= clamp ? clamp : delta))
        }
    }
    
    /*!
     @method get:corner
     @abstract Returns the world height of the given corner.
     @param corner The corner to return the world height for.
     */
    public func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
}

extension TerrainLayer {
    
    /*!
     @method set:terrainType
     @abstract Set the TerrainType for all edges.
     @param terrainType The TerrainType to set for all edges.
     */
    public func set(terrainType: TerrainType) {
        
        set(terrainType: terrainType, edge: .north)
        set(terrainType: terrainType, edge: .east)
        set(terrainType: terrainType, edge: .south)
        set(terrainType: terrainType, edge: .west)
    }
    
    /*!
     @method set:terrainType:edge
     @abstract Set the TerrainType for the given edge.
     @param terrainType The TerrainType to set for the given edge.
     @param edge The edge to be painted with the given TerrainType.
     */
    public func set(terrainType: TerrainType, edge: GridEdge) {
        
        if let existingType = get(terrainType: edge) {
        
            terrainTypes.remove(existingType)
        }
        
        terrainTypes.insert(TerrainLayerEdge(edge: edge, terrainType: terrainType))
        
        becomeDirty()
    }
    
    /*!
     @method get:terrainType
     @abstract Returns the TerrainType of the given edge.
     @param edge The edge to search and return the TerrainType for.
     */
    public func get(terrainType edge: GridEdge) -> TerrainLayerEdge? {
        
        return terrainTypes.first { terrainLayerEdge -> Bool in
            
            return terrainLayerEdge.edge == edge
        }
    }
}

extension TerrainLayer: SceneGraphNode {
    
    /*!
     @property nodeName
     @abstract Returns the name of the SceneGraphNode.
     */
    public var nodeName: String { return "Layer" }
    
    /*!
     @property totalChildren
     @abstract Returns the total number of child SceneGraphNodes for the SceneGraphNode.
     */
    public var totalChildren: Int { return 0 }
    
    /*!
     @property volume
     @abstract Fixed bounding volume of the SceneGraphNode.
     @discussion Returns the fixed bounding volume of the parent TerrainNode.
     */
    public var volume: Volume { return node.volume }
    
    /*!
     @method sceneGraph:childAtIndex
     @abstract Attempt to find and return a child SceneGraphNode at the specified index.
     @property index The index of the child SceneGraphNode to be found and returned.
     */
    public func sceneGraph(childAtIndex index: Int) -> SceneGraphNode? { return nil }
    
    /*!
     @method sceneGraph:indexOf
     @abstract Attempt to find and return the index of the specified child.
     @param child The child for which the index should be found and returned.
     */
    public func sceneGraph(indexOf child: SceneGraphNode) -> Int? { return nil }
}

extension TerrainLayer {
    
    /*!
     @method mesh:cutaways
     @abstract Returns a mesh of the layer after all of the applicable intersecting Polyhedrons have been subtracted.
     @param cutaways An array of Polyhedrons that should be subtracted from the layer Polyhedron.
     */
    func mesh(cutaways: [Polyhedron]) -> Mesh {
        
        var faces: [MeshFace] = []
        
        let polyhedrons = Polyhedron.Subtract(polyhedrons: cutaways, from: polyhedron)
        
        let edges: [GridEdge] = [ .north, .east, .south, .west ]
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.Crown, z: 0.0)
        
        edges.forEach { edge in
            
            let corners = GridCorner.Corners(edge: edge)
            
            let nodeNeighbour = node.find(neighbour: edge)
            
            if let c0 = corners.first, let c1 = corners.last, let terrainLayerEdge = get(terrainType: edge) {
                
                let edgeNormal = GridEdge.Normal(edge: edge)
                
                let apexColor = terrainLayerEdge.terrainType.colorPalette.primary.vector
                let edgeColor = terrainLayerEdge.terrainType.colorPalette.secondary.vector
                
                let primaryColors = [ apexColor, apexColor, apexColor ]
                let secondaryColors = [ edgeColor, edgeColor, edgeColor ]

                var edgeIntersections: [Polyhedron] = []
                
                if let neighbour = nodeNeighbour?.node as? TerrainNode {
                    
                    for index in 0..<neighbour.totalChildren {
                        
                        if let layer = neighbour.sceneGraph(childAtIndex: index) as? TerrainLayer {
                            
                            if let cutaways = neighbour.find(cutaways: layer.polyhedron) {
                            
                                let intersections = Polyhedron.Subtract(polyhedrons: cutaways, from: layer.polyhedron)
                                    
                                edgeIntersections.append(contentsOf: intersections)
                            }
                        }
                    }
                }
            
                polyhedrons.forEach { division in
                    
                    let apexCenter = division.upperPolytope.center
                  
                    if (upper == nil && division.upperPolytope == polyhedron.upperPolytope) || division.upperPolytope != polyhedron.upperPolytope {
                        
                        let apexNormal = apexCenter + SCNVector3.Up
                        
                        let v0 = division.upperPolytope.vertices[c0.rawValue]
                        let v1 = division.upperPolytope.vertices[c1.rawValue]
                        
                        let plane = Plane(v0: v0, v1: v1, v2: apexCenter)
                        
                        var normal = plane.normal
                        
                        if plane.side(vector: apexNormal) {
                            
                            normal = plane.normal.negated()
                        }
                        
                        faces.append(MeshFace(vertices: [v0, v1, apexCenter], normals: [normal, normal, normal], colors: primaryColors))
                    }
                    
                    let remainingEdges = Polyhedron.Subtract(polyhedrons: edgeIntersections, from: division)
                    
                    remainingEdges.forEach { edgePolyhedron in
                        
                        let v0 = edgePolyhedron.upperPolytope.vertices[c0.rawValue]
                        let v1 = edgePolyhedron.upperPolytope.vertices[c1.rawValue]
                        let v2 = edgePolyhedron.lowerPolytope.vertices[c1.rawValue]
                        let v3 = edgePolyhedron.lowerPolytope.vertices[c0.rawValue]
                        let v4 = v0 - crown
                        let v5 = v1 - crown
                        
                        let c0equal = v0.y == v3.y
                        let c1equal = v1.y == v2.y

                        if c0equal && !c1equal {

                            let v6 = SCNVector3.Lerp(from: v5, to: v4, scalar: World.UnitXZ)
                            
                            faces.append(MeshFace(vertices: [v0, v5, v1], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))
                            faces.append(MeshFace(vertices: [v0, v4, v5], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))
                            
                            faces.append(MeshFace(vertices: [v6, v2, v5], normals: [edgeNormal, edgeNormal, edgeNormal], colors: secondaryColors))
                        }
                        else if !c0equal && c1equal {
                            
                            let v6 = SCNVector3.Lerp(from: v4, to: v5, scalar: World.UnitXZ)
                            
                            faces.append(MeshFace(vertices: [v0, v5, v1], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))
                            faces.append(MeshFace(vertices: [v0, v4, v5], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))

                            faces.append(MeshFace(vertices: [v4, v3, v6], normals: [edgeNormal, edgeNormal, edgeNormal], colors: secondaryColors))
                        }
                        else if !c0equal && !c1equal {
                            
                            faces.append(MeshFace(vertices: [v0, v5, v1], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))
                            faces.append(MeshFace(vertices: [v0, v4, v5], normals: [edgeNormal, edgeNormal, edgeNormal], colors: primaryColors))
                            
                            faces.append(MeshFace(vertices: [v4, v2, v5], normals: [edgeNormal, edgeNormal, edgeNormal], colors: secondaryColors))
                            faces.append(MeshFace(vertices: [v4, v3, v2], normals: [edgeNormal, edgeNormal, edgeNormal], colors: secondaryColors))
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: faces)
    }
}
