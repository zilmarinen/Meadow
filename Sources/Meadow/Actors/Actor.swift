//
//  Actor.swift
//
//  Created by Zack Brown on 09/12/2020.
//

import SceneKit

public class Actor: SCNNode, Codable, Hideable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
    }
    
    public var ancestor: SoilableParent? { parent as? SoilableParent }
    
    public var isDirty: Bool = true
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.actor.rawValue }
    
    lazy var director: Director = {
       
        return Director(initialState: .idle)
    }()
    
    public var node: GridNode = GridNode(coordinate: .zero, cardinal: .north)
    
    override init() {
        
        super.init()
        
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //
        
        super.init()
        
        categoryBitMask = category
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //
    }
}

extension Actor {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        //
        //
        
        for node in childNodes {
            
            node.removeFromParentNode()
        }
        
        let box = SCNBox(width: 0.25, height: 0.75, length: 0.25, chamferRadius: 0.0)
        
        box.firstMaterial?.diffuse.contents = MDWColor.systemPink
        
        let node = SCNNode(geometry: box)
        
        node.position = SCNVector3(x: 0.0, y: (box.height / 2.0), z: 0.0)
        
        addChildNode(node)
        
        //
        //
        //
        
        isDirty = false
        
        return true
    }
}

extension Actor {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch director.state {
        
        case .interacting(let interactive, let slot):
            
            interactive.release(slot: slot)
            
        case .travelling(let path, let interactive):
            
            guard node != path.nodes.last else {
                
                guard let interactive = interactive,
                      let slot = interactive.claim(node: node, actor: self) else {
                    
                    self.director.idle()
                
                    return
                }
                
                self.director.interact(interactive: interactive, slot: slot)
                
                return
            }
            
            //
            
        default: break
        }
    }
}
