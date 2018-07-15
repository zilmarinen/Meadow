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
     @abstract Holds the TerrainLayerEdge for each edge.
     */
    private var terrainTypes: Set<TerrainLayerEdge> = []
    
    /*!
     @property cachedPolyhedron
     @abstract Cached version of the Polyhedron calculated after being cleaned.
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
            
            if isHidden != oldValue {
            
                becomeDirty()
            }
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
    public var polyhedron: Polyhedron {
        
        if let cachedPolyhedron = cachedPolyhedron {
            
            return cachedPolyhedron
        }
        
        let upperPolytope = Polytope(x: MDWFloat(volume.coordinate.x), y: corners, z: MDWFloat(volume.coordinate.z))
        
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
    public static let Crown: MDWFloat = (World.UnitY / 2.0)
}

extension TerrainLayer: Soilable {
    
    /*!
     @method becomeDirty
     @abstract If not already true, toggle the isDirty flag to true.
     */
    public func becomeDirty() {
        
        if isDirty { return }
        
        isDirty = true
        
        upper?.becomeDirty()
        lower?.becomeDirty()
        
        node.becomeDirty()
    }
    
    /*!
     @method clean
     @abstract Enumerate through children and clean.
     */
    public func clean() -> Bool {
        
        if !isDirty { return false }
        
        isDirty = false
        
        cachedPolyhedron = nil
        
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
        
        var cornerHeight = min(max(height, World.Floor + 1), World.Ceiling)
        
        if let upper = upper {
            
            cornerHeight = min(cornerHeight, upper.get(height: corner))
        }
        
        if let lower = lower {
            
            cornerHeight = max(cornerHeight, lower.get(height: corner))
        }
        
        if get(height: corner) != cornerHeight {
         
            let connectedCorners = GridCorner.Corners(corner: corner)
            let oppositeCorner = GridCorner.Opposite(corner: corner)
            
            resolve(height: cornerHeight, corner: connectedCorners.first!, clamp: 1, smooth: smooth)
            resolve(height: cornerHeight, corner: connectedCorners.last!, clamp: 1, smooth: smooth)
            
            corners[corner.rawValue] = cornerHeight
            
            becomeDirty()
            
            if smooth {
                
                let connectedEdges = GridEdge.Edges(corner: corner)
                
                let e0 = connectedEdges.first!
                let e1 = connectedEdges.last!
                
                let c0 = GridCorner.Adjacent(corner: corner, edge: e0)
                let c1 = GridCorner.Adjacent(corner: corner, edge: e1)
                
                let a0 = node.find(neighbour: e0)?.node as? TerrainNode
                let a1 = node.find(neighbour: e1)?.node as? TerrainNode
                let d = node.find(neighbour: corner)?.node as? TerrainNode
                
                if let a0 = a0, let topLayer = a0.topLayer { topLayer.set(height: cornerHeight, corner: c0, smooth: smooth) }
                if let a1 = a1, let topLayer = a1.topLayer { topLayer.set(height: cornerHeight, corner: c1, smooth: smooth) }
                if let d = d, let topLayer = d.topLayer { topLayer.set(height: cornerHeight, corner: oppositeCorner, smooth: smooth) }
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
    func resolve(height: Int, corner: GridCorner, clamp: Int, smooth: Bool) {
     
        let delta = get(height: corner) - height
        
        if abs(delta) > clamp {
            
            let cornerHeight = height + (delta <= -clamp ? -clamp : (delta >= clamp ? clamp : delta))
            
            set(height: cornerHeight, corner: corner, smooth: smooth)
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
        
        if let existingType = get(terrainEdge: edge) {
        
            terrainTypes.remove(existingType)
        }
        
        terrainTypes.insert(TerrainLayerEdge(edge: edge, terrainType: terrainType))
        
        becomeDirty()
    }
    
    /*!
     @method get:terrainEdge
     @abstract Returns the TerrainLayerEdge of the given edge.
     @param edge The edge to search and return the TerrainLayerEdge for.
     */
    public func get(terrainEdge edge: GridEdge) -> TerrainLayerEdge? {
        
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
    public func mesh(cutaways: [Polyhedron]) -> Mesh {
        
        var faces: [MeshFace] = []
        
        let polyhedrons = Polyhedron.Subtract(polyhedrons: cutaways, from: polyhedron)
        
        GridEdge.Edges.forEach { edge in
            
            if let terrainLayerEdge = get(terrainEdge: edge) {
                
                let nodeNeighbour = node.find(neighbour: edge)

                var layers: [Polyhedron] = []
                
                if let neighbour = nodeNeighbour?.node as? TerrainNode {
                    
                    for index in 0..<neighbour.totalChildren {
                        
                        if let layer = neighbour.sceneGraph(childAtIndex: index) as? TerrainLayer {
                            
                            if let cutaways = neighbour.find(cutaways: layer.polyhedron) {
                            
                                let intersections = Polyhedron.Subtract(polyhedrons: cutaways, from: layer.polyhedron)
                                
                                layers.append(contentsOf: intersections)
                            }
                            else {
                                
                                layers.append(layer.polyhedron)
                            }
                        }
                    }
                }
                
                let corners = GridCorner.Corners(edge: edge)
                
                let edgeNormal = GridEdge.Normal(edge: edge)
                
                let apexColor = terrainLayerEdge.terrainType.colorPalette.primary.vector
                let edgeColor = terrainLayerEdge.terrainType.colorPalette.secondary.vector
            
                polyhedrons.forEach { division in
                    
                    if (upper == nil && division.upperPolytope == polyhedron.upperPolytope) || division.upperPolytope != polyhedron.upperPolytope {
                        
                        faces.append(meshFace(apex: division, corners: corners, color: apexColor))
                    }
                    
                    let stencils = Polyhedron.Stencil(polyhedrons: layers, against: division, edge: edge)
                    
                    stencils.forEach { stencil in
                        
                        let v0 = stencil.upperPolytope.vertices[corners.first!.rawValue]
                        let v1 = stencil.upperPolytope.vertices[corners.last!.rawValue]
                        let v2 = stencil.lowerPolytope.vertices[corners.last!.rawValue]
                        let v3 = stencil.lowerPolytope.vertices[corners.first!.rawValue]
                        
                        let c0equal = v0.y == v3.y
                        let c1equal = v1.y == v2.y
                        
                        let acuteCorner = (c0equal ? corners.first : (c1equal ? corners.last : nil))
                        
                        if !c0equal || !c1equal {
                            
                            let vertices = [v0, v1, v2, v3]
                            
                            faces.append(contentsOf: meshFaces(crown: stencil, corners: corners, acuteCorner: acuteCorner, vertices: vertices, normal: edgeNormal, color: apexColor))
                            faces.append(contentsOf: meshFaces(throne: stencil, corners: corners, acuteCorner: acuteCorner, vertices: vertices, normal: edgeNormal, color: edgeColor))
                        }
                    }
                }
            }
        }
        
        return Mesh(faces: faces)
    }
    
    /*!
     @method meshFace:apex:polyhedron:corners:color
     @abstract Creates a mesh face for the specified edge from the center and connected corners of the Polyhedron.
     @param polyhedron The polyhedron being drawn.
     @param corners The corners of the edge being drawn.
     @param color The color of the mesh face.
     */
    func meshFace(apex polyhedron: Polyhedron, corners: [GridCorner], color: SCNVector4) -> MeshFace {
        
        let apexCenter = polyhedron.upperPolytope.center
        
        let apexNormal = apexCenter + SCNVector3.Up
        
        let v0 = polyhedron.upperPolytope.vertices[corners.first!.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[corners.last!.rawValue]
        
        let plane = Plane(v0: v0, v1: v1, v2: apexCenter)
        
        var normal = plane.normal
        
        if plane.side(vector: apexNormal) == .interior {
            
            normal = SCNVector3.Negate(vector: plane.normal)
        }
        
        return MeshFace(vertices: [v1, v0, apexCenter], normals: [normal, normal, normal], colors: [color, color, color])
    }
    
    /*!
     @method meshFaces:crown:polyhedron:corners:normal:color
     @abstract Creates the mesh faces required for the crown of a Polyhedron along the specified edge.
     @param polyhedron The polyhedron being drawn.
     @param corners The corners of the edge being drawn.
     @param acuteCorner The optional corner of the Polyhedron whose corners are equal.
     @param vertices The vertices of the edge being drawn.
     @param normal The normal facing outwards from the edge.
     @param color The color of the mesh face.
     */
    func meshFaces(crown polyhedron: Polyhedron, corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.Crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        if let acuteCorner = acuteCorner {
            
            let v0 = vertices[0]
            let v1 = vertices[1]
            let v2 = (acuteCorner == corners.first ? vertices[1] - crown : SCNVector3.Lerp(from: vertices[2], to: vertices[3], factor: TerrainLayer.Crown))
            let v3 = (acuteCorner == corners.first ? SCNVector3.Lerp(from: vertices[3], to: vertices[2], factor: TerrainLayer.Crown) : vertices[0] - crown)
            
            return [    MeshFace(vertices: [v0, v1, v2], normals: normals, colors: colors),
                        MeshFace(vertices: [v0, v2, v3], normals: normals, colors: colors)]
        }
        
        return [    MeshFace(vertices: [vertices[0], vertices[1], vertices[1] - crown], normals: normals, colors: colors),
                    MeshFace(vertices: [vertices[0], vertices[1] - crown, vertices[0] - crown], normals: normals, colors: colors)]
    }
    
    /*!
     @method meshFaces:throne:polyhedron:corners:normal:color
     @abstract Creates the mesh faces required for the throne of a Polyhedron along the specified edge.
     @param polyhedron The polyhedron being drawn.
     @param corners The corners of the edge being drawn.
     @param acuteCorner The optional corner of the Polyhedron whose corners are equal.
     @param vertices The vertices of the edge being drawn.
     @param normal The normal facing outwards from the edge.
     @param color The color of the mesh face.
     */
    func meshFaces(throne polyhedron: Polyhedron, corners: [GridCorner], acuteCorner: GridCorner?, vertices: [SCNVector3], normal: SCNVector3, color: SCNVector4) -> [MeshFace] {
        
        let crown = SCNVector3(x: 0.0, y: TerrainLayer.Crown, z: 0.0)
        let normals = [normal, normal, normal]
        let colors = [color, color, color]
        
        if let acuteCorner = acuteCorner {
            
            let v0 = (acuteCorner == corners.first ? vertices[1] : vertices[0]) - crown
            let v1 = (acuteCorner == corners.first ? vertices[2] : vertices[3])
            let v2 = SCNVector3.Lerp(from: vertices[acuteCorner.rawValue], to: v1, factor: TerrainLayer.Crown)
            
            let i0 = (acuteCorner == corners.first ? v0 : v1)
            let i1 = (acuteCorner == corners.first ? v1 : v0)
            
            return [MeshFace(vertices: [i0, i1, v2], normals: normals, colors: colors)]
        }
        
        return [    MeshFace(vertices: [vertices[0] - crown, vertices[1] - crown, vertices[2]], normals: normals, colors: colors),
                    MeshFace(vertices: [vertices[0] - crown, vertices[2], vertices[3]], normals: normals, colors: colors)]
    }
}
