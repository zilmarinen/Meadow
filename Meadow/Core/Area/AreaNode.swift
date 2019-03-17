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
    
    var floorColorPalette: ColorPalette?
    
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
        
        if let floorColorPalette = floorColorPalette {
            
            let polytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: AreaNodeEdge.surface, z: 0.0))
            
            faces.append(contentsOf: MeshFace.quad(polytope: polytope, color: floorColorPalette.primary.vector))
        }
        
        //
        
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
