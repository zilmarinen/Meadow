//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class AreaNode<NodeEdge: AreaNodeEdge>: GridNode, SceneGraphParent {
    
    var children = Tree<NodeEdge>()
    
    public var floor: AreaNodeFloor? {
        
        didSet {
            
            if floor != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case children
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.children.children, forKey: .children)
    }
    
    @discardableResult public override func clean() -> Bool {
        
        if !isDirty { return false }
        
        children.forEach { edge in
            
            edge.clean()
        }
        
        isDirty = false
        
        return true
    }
    
    public override func child(didBecomeDirty child: SceneGraphChild) {
        
        super.child(didBecomeDirty: child)
        
        guard let child = child as? NodeEdge else { return }
        
        find(neighbour: child.edge)?.node.becomeDirty()
    }
    
    public override var mesh: Mesh {
        
        var faces: [MeshFace] = []
        
        let nodePolyhedron = polyhedron
        
        if let floor = floor {
            
            let polytope = Polytope.translate(polytope: nodePolyhedron.lowerPolytope, translation: SCNVector3(x: 0.0, y: AreaNodeEdge.surface, z: 0.0))
            
            faces.append(contentsOf: floor.floorType.meshBuilder.area(floor: polytope, colorPalette: floor.colorPalette))
        }
        
        children.forEach { nodeEdge in
            
            let connectedEdges = GridEdge.edges(edge: nodeEdge.edge)
            let oppositeEdge = GridEdge.opposite(edge: nodeEdge.edge)
            
            let neighbour = find(neighbour: nodeEdge.edge)?.node as? AreaNode
            
            let n0 = find(neighbour: connectedEdges.e0)?.node as? AreaNode
            let n1 = find(neighbour: connectedEdges.e1)?.node as? AreaNode
            
            let i0 = find(edge: connectedEdges.e0)
            let i1 = find(edge: connectedEdges.e1)
            
            let d0 = (neighbour?.find(neighbour: connectedEdges.e0) ?? n0?.find(neighbour: nodeEdge.edge))?.node as? AreaNode
            let d1 = (neighbour?.find(neighbour: connectedEdges.e1) ?? n1?.find(neighbour: nodeEdge.edge))?.node as? AreaNode
            
            let a0 = (n0?.find(edge: nodeEdge.edge) ?? d0?.find(edge: oppositeEdge))
            let a1 = (n1?.find(edge: nodeEdge.edge) ?? d1?.find(edge: oppositeEdge))
            
            let p0 = (neighbour?.find(edge: connectedEdges.e0) ?? d0?.find(edge: connectedEdges.e1))
            let p1 = (neighbour?.find(edge: connectedEdges.e1) ?? d1?.find(edge: connectedEdges.e0))
            
            let graph = AreaNodeEdge.Graph(edge: nodeEdge.edge, adjacent: (a0, a1), intersector: (i0, i1), perpendicular: (p0, p1))
            
            let size = Size<MDWFloat>(width: Axis.unitXZ, height: Axis.Y(y: (nodeEdge.renderState == .raised ? AreaNodeEdge.edgeHeight : AreaNodeEdge.foundationHeight)), depth: AreaNodeEdge.internalWallDepth)
            
            faces.append(contentsOf: SetDesigner.sharedInstance.area(edge: graph, polyhedron: nodePolyhedron, edgeType: nodeEdge.edgeType, edgeFace: nodeEdge.internalEdgeFace, renderState: nodeEdge.renderState, size: size))
            
            if neighbour == nil {
                
                let graph = AreaNodeEdge.Graph(edge: oppositeEdge, adjacent: (a1, a0), intersector: (p1, p0), perpendicular: (i1, i0))
             
                let size = Size<MDWFloat>(width: size.width, height: size.height, depth: AreaNodeEdge.externalWallDepth)
                
                let neighbourPolyhedron = Polyhedron.translate(polyhedron: nodePolyhedron, translation: GridEdge.normal(edge: nodeEdge.edge))
                
                faces.append(contentsOf: SetDesigner.sharedInstance.area(edge: graph, polyhedron: neighbourPolyhedron, edgeType: nodeEdge.edgeType, edgeFace: nodeEdge.externalEdgeFace, renderState: nodeEdge.renderState, size: size))
            }
            /*
            let tuples = [(graph.edges.e0, c0, graph.adjacent.e0, graph.intersector.e0, graph.perpendicular.e0), (graph.edges.e1, c1, graph.adjacent.e1, graph.intersector.e1, graph.perpendicular.e1)]
            
            tuples.forEach { (edge, corner, adjacent, intersector, perpendicular) in
                
                if intersector == nil && adjacent == nil {
                    
                    let corner = GridCorner.adjacent(corner: corner, edge: edge)
                    
                    let cornerPolyhedron = Polyhedron.translate(polyhedron: nodePolyhedron, translation: GridEdge.normal(edge: edge))
                    
                    faces.append(contentsOf: SetDesigner.sharedInstance.area(corner: corner, edge: nodeEdge.edge, polyhedron: cornerPolyhedron, edgeType: nodeEdge.edgeType, edgeFace: nodeEdge.internalEdgeFace, renderState: nodeEdge.renderState))
                }
                
                if perpendicular == nil && adjacent == nil {
                    
                    let corner = GridCorner.opposite(corner: corner)
                    
                    let cornerPolyhedron = Polyhedron.translate(polyhedron: nodePolyhedron, translation: GridEdge.normal(edge: nodeEdge.edge) + GridEdge.normal(edge: edge))
                    
                    faces.append(contentsOf: SetDesigner.sharedInstance.area(corner: corner, edge: nodeEdge.edge, polyhedron: cornerPolyhedron, edgeType: nodeEdge.edgeType, edgeFace: nodeEdge.internalEdgeFace, renderState: nodeEdge.renderState))
                }
            }*/
        }
        
        return Mesh(faces: faces)
    }
}

extension AreaNode {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index]
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? NodeEdge else { return nil }
        
        return children.index(of: child)
    }
}

extension AreaNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let y = volume.coordinate.y + volume.size.height
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: y, y1: y, y2: y, y3: y, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: volume.coordinate.y, y1: volume.coordinate.y, y2: volume.coordinate.y, y3: volume.coordinate.y, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension AreaNode {
    
    public func add(edge: GridEdge, edgeType: AreaNodeEdgeType, internalEdgeFace: AreaNodeEdgeFace, externalEdgeFace: AreaNodeEdgeFace) -> NodeEdge? {
        
        guard find(edge: edge) == nil else { return nil }
        
        let nodeEdge = NodeEdge(observer: self, volume: self.volume, edge: edge, edgeType: edgeType, internalEdgeFace: internalEdgeFace, externalEdgeFace: externalEdgeFace)
        
        children.append(nodeEdge)
        
        if let neighbour = find(neighbour: edge)?.node as? AreaNode {
            
            let oppositeEdge = GridEdge.opposite(edge: edge)
            
            if let neighbourNodeEdge = neighbour.find(edge: oppositeEdge) {
                
                if neighbourNodeEdge.edgeType != edgeType || neighbourNodeEdge.internalEdgeFace != externalEdgeFace || neighbourNodeEdge.externalEdgeFace != internalEdgeFace {
                 
                    neighbour.remove(edge: neighbourNodeEdge)
                }
            }
            
            let _ = neighbour.add(edge: oppositeEdge, edgeType: edgeType, internalEdgeFace: externalEdgeFace, externalEdgeFace: internalEdgeFace)
        }
        
        becomeDirty()
        
        return nodeEdge
    }
    
    public func find(edge: GridEdge) -> NodeEdge? {
    
        return children.first { $0.edge == edge }
    }
    
    @discardableResult public func remove(edge: NodeEdge) -> Bool {
        
        if let index = children.index(of: edge) {
            
            children.remove(at: index)
            
            edge.observer = nil
            
            becomeDirty()
            
            return true
        }
        
        return false
    }
}

extension AreaNode {
    
    public var renderState: AreaNodeEdge.RenderState {
        
        get {
            
            let cutaway = children.filter { $0.renderState == .cutaway }
            
            return (cutaway.count == totalChildren ? .cutaway : .raised)
        }
        
        set {
            
            children.forEach { $0.renderState = newValue }
        }
    }
}
