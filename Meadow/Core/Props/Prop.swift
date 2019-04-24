//
//  Prop.swift
//  Meadow
//
//  Created by Zack Brown on 12/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Prop: SCNNode, SceneGraphChild {
    
    public var observer: SceneGraphObserver?
    
    var isDirty: Bool = false
    
    public override var isHidden: Bool {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume { return footprint.volume }
    
    public let footprint: Footprint
    
    public let prototype: PropPrototype
    
    public var colorPalette: ColorPalette? {
        
        didSet {
            
            if colorPalette != oldValue {
            
                becomeDirty()
            }
        }
    }
    
    init(observer: SceneGraphObserver, prototype: PropPrototype, footprint: Footprint) {
        
        self.observer = observer
        
        self.prototype = prototype
        
        self.footprint = footprint
        
        super.init()
        
        self.name = prototype.name
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Prop: SceneGraphSoilable {
    
    @discardableResult public func becomeDirty() -> Bool {
        
        if !isDirty {
            
            isDirty = true
        }
        
        return isDirty
    }
    
    @discardableResult public func clean() -> Bool {
        
        if !isDirty { return false }
        
        
        
        //
        //
        //
        
        guard let colorPalette = colorPalette else { return false }
        
        var meshFaces: [MeshFace] = []
        
        footprint.nodes.forEach { footprintNode in
            
            let lowerPolytope = Polytope(x: MDWFloat(footprintNode.coordinate.x), y0: footprintNode.coordinate.y, y1: footprintNode.coordinate.y, y2: footprintNode.coordinate.y, y3: footprintNode.coordinate.y, z: MDWFloat(footprintNode.coordinate.z))
            
            let upperPolytope = Polytope.translate(polytope: lowerPolytope, translation: SCNVector3(x: 0.0, y: Axis.unitY / 2, z: 0.0))
            
            let polyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
            
            footprintNode.edges.forEach { edge in
                
                let corners = GridCorner.corners(edge: edge)
                
                let normal = GridEdge.normal(edge: edge)
                
                meshFaces.append(MeshFace.apex(corners: corners, polytope: polyhedron.upperPolytope, color: colorPalette.primary.vector))
                
                meshFaces.append(contentsOf: MeshFace.edge(corners: corners, polyhedron: polyhedron, normal: normal, color: colorPalette.primary.vector))
            }
        }
        
        self.geometry = SCNGeometry(mesh: Mesh(faces: meshFaces))
        
        //
        //
        //
        
        
        
        /*guard let model = Model(named: prototype.name), let colorPalette = colorPalette else { return false }
        
        let mesh = model.mesh(colorPalette: colorPalette)
        
        self.geometry = SCNGeometry(mesh: mesh)*/
        
        isDirty = false
        
        return true
    }
}

extension Prop: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case coordinate
        case rotation
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.footprint.coordinate, forKey: .coordinate)
        try container.encode(self.footprint.rotation, forKey: .rotation)
    }
}
