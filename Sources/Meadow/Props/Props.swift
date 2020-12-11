//
//  Props.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import SceneKit

public class Props: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case props
    }
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    var props: [Prop] = []
    
    public var children: [SceneGraphNode] { props }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.props.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Props"
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        props = try container.decode([Prop].self, forKey: .props)
        
        super.init()
        
        name = try container.decode(String.self, forKey: .name)
        categoryBitMask = category
        
        for prop in props {
            
            addChildNode(prop)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(props, forKey: .props)
    }
}

extension Props {
    
    func add(prop footprint: Footprint) -> Prop? {
        
        guard find(prop: footprint) == nil else { return nil }
        
        let prop = Prop(footprint: footprint)
        
        props.append(prop)
        
        addChildNode(prop)
        
        becomeDirty()
        
        return prop
    }
    
    func find(prop node: GridNode) -> Prop? {
        
        return props.first { $0.contains(node: node) }
    }
    
    func find(prop intersecting: Footprint) -> Prop? {
        
        return props.first { $0.footprint.intersects(footprint: intersecting) }
    }
    
    func remove(prop node: GridNode) {
        
        guard let prop = find(prop: node),
              let index = props.firstIndex(of: prop) else { return }
        
        props.remove(at: index)
        
        prop.removeFromParentNode()
        
        becomeDirty()
    }
}

extension Props {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for prop in props {
            
            prop.clean()
        }
        
        isDirty = false
        
        return true
    }
}

extension Props {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        for prop in props {
            
            prop.update(delta: delta, time: time)
        }
    }
}

