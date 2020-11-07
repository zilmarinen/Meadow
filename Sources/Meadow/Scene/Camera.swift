//
//  Camera.swift
//
//  Created by Zack Brown on 07/11/2020.
//

import SceneKit

public class Camera: SCNNode, SceneGraphNode {
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.camera.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Camera"
        camera = SCNCamera()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
