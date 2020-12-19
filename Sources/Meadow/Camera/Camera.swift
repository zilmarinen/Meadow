//
//  Camera.swift
//
//  Created by Zack Brown on 07/11/2020.
//

import SceneKit

public class Camera: SCNNode, SceneGraphNode, Soilable, Updatable {
    
    public var ancestor: SoilableParent? { return parent as? SoilableParent }
    
    public var isDirty: Bool = false
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.camera.rawValue }
    
    public lazy var jig: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = false
        
        node.camera = camera
        
        return node
    }()
    
    public lazy var controller: CameraController = {
       
        return CameraController(initialState: .focus(node: SCNNode(), ordinal: .northEast, zoom: 1.0))
    }()
    
    override init() {
        
        super.init()
        
        name = "Camera"
        
        addChildNode(jig)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Camera {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Camera {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {

        case .focus(let node, let ordinal, let zoom):
            
            let theta = Math.radians(degrees: 35)
            let angle = Math.radians(degrees: 90) * Double(ordinal.rawValue)
            
            let zoomScale = (Constants.maximumZoom * zoom)
            
            let orthographicScale = Double(min(max(zoomScale, Constants.minimumZoom), Constants.maximumZoom))
            
            let adjacent = Double(World.Constants.ceiling - World.Constants.floor)
            let hypotenuse = sqrt((adjacent * adjacent) + (adjacent * adjacent))
            let opposite = sin(theta) * hypotenuse
            
            let x = (sin(angle + theta))
            let y = (cos(theta) * hypotenuse)
            let z = (cos(angle + theta))
            
            let eye = Vector(x: opposite, y: y, z: opposite)
            
            let quaternion = Rotation.focus(eye: eye, focus: .zero, up: .up)
            
            self.position = node.position
            
            jig.position = SCNVector3(vector: eye)
            jig.rotation = SCNQuaternion(quaternion: quaternion)
            jig.camera?.orthographicScale = orthographicScale
        }
    }
}
