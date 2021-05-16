//
//  Camera.swift
//
//  Created by Zack Brown on 07/11/2020.
//

import SceneKit

public class Camera: SCNNode, Responder, Soilable, Updatable {
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.camera.rawValue }
    
    public lazy var jig: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = false
        camera.orthographicScale = Constants.maximumZoom
        
        //node.camera = camera
        
        return node
    }()
    
    public lazy var controller: CameraController = {
       
        return CameraController(initialState: .focus(node: self, cardinal: .north, zoom: 1.0))
    }()
    
    override init() {
        
        super.init()
        
        name = "Camera"
        categoryBitMask = category
        
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
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        switch controller.state {

        case .focus(let node, let cardinal, let zoom):
            
            let zoomScale = (Constants.maximumZoom * zoom)
            
            let pitch = atan(4.0 / 3.0)
            let yaw = Math.radians(degrees: 90.0 * Double(cardinal.rawValue))
            
            let adjacent = Double(World.Constants.ceiling - World.Constants.floor)
            let opposite = tan(pitch) * adjacent
            let hypotenuse = sqrt((adjacent * adjacent) + (opposite * opposite))
            
            let x = CGFloat(cos(yaw) * opposite)
            let y = CGFloat(cos(pitch) * hypotenuse)
            let z = CGFloat(sin(yaw) * opposite)
            
            let rotation = Rotation.yaw(radians: -yaw).quaternion
            
            self.position = node.position
            
            jig.position = SCNVector3(x: MDWFloat(x), y: MDWFloat(y), z: MDWFloat(z))
            jig.rotation = SCNQuaternion(quaternion: rotation)
            jig.camera?.orthographicScale = Double(min(max(zoomScale, Constants.minimumZoom), Constants.maximumZoom))
            jig.look(at: node.position)
        }
    }
}
