//
//  Skeleton.swift
//
//  Created by Zack Brown on 15/01/2021.
//

import SceneKit

class Skeleton: SCNNode, Responder, SceneGraphNode, Soilable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    let bones: [Bone]
    
    public var children: [SceneGraphNode] { bones }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.blueprint.rawValue }
    
    init(structure: Bone.Structure) {
        
        bones = structure.bones
        
        super.init()
        
        guard let hips = bones.first else { return }
        
        addChildNode(hips)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Skeleton {
    
    func find(bone named: Bone.Name) -> Bone? {
        
        return bones.first { $0.name == named.rawValue }
    }
}

extension Skeleton {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        for bone in bones {
            
            bone.clean()
        }
        
        isDirty = false
        
        return true
    }
}
